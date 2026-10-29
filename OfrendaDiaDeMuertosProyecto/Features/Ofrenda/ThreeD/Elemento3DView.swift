//
//  Elemento3DView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI
import UIKit
import RealityKit
import QuartzCore
import simd


struct Elemento3DView: View {
    let elemento: ElementoOfrenda
    let fotosMarcos: FotosMarcosStore
    let renderSession: OfrendaRenderSession
    var isActive = true
    @State private var estado: ModelLoadState = .loading
    @State private var giroAutomatico = true
    @State private var resetToken = 0
    @State private var errorFoto: String?
    @Environment(\.accessibilityReduceMotion) private var reducirMovimiento
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.scenePhase) private var scenePhase

    private var marco: MarcoOfrenda {
        if fotosMarcos.configuracion.cantidad == .uno { return fotosMarcos.configuracion.principal }
        return MarcoOfrenda.allCases.first { fotosMarcos.fotos[$0]?.esPredeterminada == false } ?? .izquierdo
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VisorObjeto3D(
                session: renderSession,
                nombres: OfrendaElementSelection.nombres(para: elemento.nombre, marco: marco),
                marco: elemento.nombre == "Retrato" ? marco : nil,
                fotos: fotosMarcos.fotos,
                giroAutomatico: giroAutomatico,
                reducirMovimiento: reducirMovimiento,
                isActive: isActive && scenePhase == .active,
                resetToken: resetToken,
                onLoad: { estado = $0 },
                onGirar: { giroAutomatico = false },
                onErrorFoto: { errorFoto = $0 }
            )
            .accessibilityLabel("Modelo 3D de \(elemento.nombre)")
            .accessibilityHint("Arrastra para girarlo y pellizca para acercarlo")
            if estado == .loading {
                ProgressView("Cargando modelo 3D…").frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            if case .failed(let mensaje) = estado {
                Text(mensaje)
                    .font(.footnote).multilineTextAlignment(.center)
                    .padding().frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            if estado == .ready {
                HStack(spacing: 12) {
                    if !reducirMovimiento {
                        Button {
                            giroAutomatico.toggle()
                        } label: {
                            if dynamicTypeSize.isAccessibilitySize {
                                Image(systemName: giroAutomatico ? "pause.fill" : "play.fill")
                                    .font(.system(size: 18, weight: .semibold)).frame(width: 44, height: 44)
                            } else {
                                Label(giroAutomatico ? "Pausar giro" : "Reanudar giro", systemImage: giroAutomatico ? "pause.fill" : "play.fill")
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 12).frame(minHeight: 44)
                            }
                        }
                        .buttonStyle(.glass)
                        .accessibilityLabel(giroAutomatico ? "Pausar giro" : "Reanudar giro")
                    }
                    Spacer(minLength: 0)
                    GlassIconButton(systemImage: "arrow.counterclockwise", label: "Restablecer objeto 3D") {
                        resetToken += 1
                        giroAutomatico = true
                    }
                }
                .padding(10)
            }
        }
        .background(AppTheme.background)
        .clipShape(.rect(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(.white.opacity(0.1)))
        .alert("No se pudo mostrar la fotografía", isPresented: Binding(
            get: { errorFoto != nil }, set: { if !$0 { errorFoto = nil } }
        )) {
            Button("Entendido", role: .cancel) { errorFoto = nil }
        } message: { Text(errorFoto ?? "") }
    }
}

private struct VisorObjeto3D: UIViewRepresentable {
    let session: OfrendaRenderSession
    let nombres: [String]
    let marco: MarcoOfrenda?
    let fotos: [MarcoOfrenda: FotoMarco]
    let giroAutomatico: Bool
    let reducirMovimiento: Bool
    let isActive: Bool
    let resetToken: Int
    let onLoad: (ModelLoadState) -> Void
    let onGirar: () -> Void
    let onErrorFoto: (String) -> Void

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> OfrendaRenderHost {
        let host = OfrendaRenderHost()
        let coordinator = context.coordinator
        coordinator.session = session
        host.onLayout = { [weak coordinator] in coordinator?.updateCamera() }
        host.onWindow = { [weak coordinator] in coordinator?.updateAnimation() }
        if let view = session.borrow(into: host) { coordinator.setup(view) }
        return host
    }

    func updateUIView(_ host: OfrendaRenderHost, context: Context) { context.coordinator.update(self) }

    static func dismantleUIView(_ host: OfrendaRenderHost, coordinator: Coordinator) {
        host.onLayout = nil
        host.onWindow = nil
        coordinator.dispose()
        coordinator.session?.giveBack(from: host)
    }

    @MainActor final class Coordinator: NSObject {
        private weak var view: ARView?
        var session: OfrendaRenderSession?
        private var anchor: AnchorEntity?
        private var gestures: [UIGestureRecognizer] = []
        private var generation = UUID()
        private let pivot = Entity()
        private let camera = PerspectiveCamera()
        private let photos = OfrendaPhotoFrames()
        private var state = Objeto3DInspectionState()
        private var radius: Float = 1
        private var key: String?
        private var resetToken = 0
        private var loaded = false
        private var giroAutomatico = true
        private var reducirMovimiento = false
        private var isActive = true
        private var fotos: [MarcoOfrenda: FotoMarco] = [:]
        private var loading: Task<Void, Never>?
        private var displayLink: CADisplayLink?
        private var lastTime: CFTimeInterval = 0
        private var onLoad: (ModelLoadState) -> Void = { _ in }
        private var onGirar: () -> Void = {}

        func setup(_ view: ARView) {
            self.view = view
            let anchor = AnchorEntity(world: .zero)
            anchor.addChild(pivot)
            camera.camera.fieldOfViewInDegrees = 34
            anchor.addChild(camera)
            let keyLight = DirectionalLight()
            keyLight.light.intensity = 1200
            keyLight.light.color = UIColor(red: 1, green: 0.94, blue: 0.86, alpha: 1)
            keyLight.look(at: .zero, from: [2, 3, 4], relativeTo: nil)
            anchor.addChild(keyLight)
            let fill = PointLight()
            fill.light.intensity = 1600
            fill.light.attenuationRadius = 10
            fill.position = [-2, 1, 3]
            anchor.addChild(fill)
            self.anchor = anchor
            view.scene.addAnchor(anchor)
            gestures = [UIPanGestureRecognizer(target: self, action: #selector(girar(_:))),
                        UIPinchGestureRecognizer(target: self, action: #selector(acercar(_:)))]
            gestures.forEach { view.addGestureRecognizer($0) }
            let proxy = TickProxy()
            proxy.owner = self
            let link = CADisplayLink(target: proxy, selector: #selector(TickProxy.tick(_:)))
            link.preferredFrameRateRange = CAFrameRateRange(minimum: 15, maximum: 30, preferred: 30)
            link.isPaused = true
            link.add(to: .main, forMode: .common)
            displayLink = link
        }

        func update(_ parent: VisorObjeto3D) {
            onLoad = parent.onLoad
            onGirar = parent.onGirar
            photos.onError = parent.onErrorFoto
            fotos = parent.fotos
            giroAutomatico = parent.giroAutomatico
            reducirMovimiento = parent.reducirMovimiento
            isActive = parent.isActive
            guard view != nil else {
                if key == nil {
                    key = "unavailable"
                    loading = Task { @MainActor [weak self] in
                        await Task.yield()
                        guard !Task.isCancelled else { return }
                        self?.onLoad(.failed("El visor 3D no está disponible. Cierra la tarjeta e intenta de nuevo."))
                    }
                }
                return
            }
            let newKey = parent.nombres.joined(separator: "|")
            if key != newKey {
                key = newKey
                load(nombres: parent.nombres, marco: parent.marco)
            }
            if resetToken != parent.resetToken {
                resetToken = parent.resetToken
                state = Objeto3DInspectionState()
            }
            photos.update(fotos)
            applyPose()
            updateAnimation()
        }

        private func load(nombres: [String], marco: MarcoOfrenda?) {
            loading?.cancel()
            photos.dispose()
            pivot.children.removeAll()
            loaded = false
            state = Objeto3DInspectionState()
            let requestID = UUID()
            generation = requestID
            loading = Task { @MainActor [weak self] in
                guard let self else { return }
                onLoad(.loading)
                do {
                    guard let session else { throw InspectionError.unavailable }
                    let objeto = try await session.cloneElement(nombres: nombres)
                    try Task.checkCancellation()
                    guard generation == requestID else { return }
                    OfrendaMaterials.prepare(objeto)
                    let bounds = objeto.visualBounds(relativeTo: objeto)
                    let longest = max(bounds.extents.x, bounds.extents.y, bounds.extents.z)
                    guard longest.isFinite, longest > 0 else { throw InspectionError.empty }
                    let scale: Float = 1.6 / longest
                    objeto.scale = SIMD3(repeating: scale)
                    objeto.position = -bounds.center * scale
                    radius = simd_length(bounds.extents * scale) / 2
                    pivot.addChild(objeto)
                    if let marco {
                        try photos.attach(to: objeto, marcos: [marco])
                        photos.update(fotos)
                    }
                    loaded = true
                    applyPose()
                    updateAnimation()
                    await Task.yield()
                    try Task.checkCancellation()
                    guard generation == requestID else { return }
                    onLoad(.ready)
                } catch is CancellationError {} catch {
                    onLoad(.failed("No se pudo preparar este objeto: \(error.localizedDescription)"))
                }
            }
        }

        func updateAnimation() {
            let visible = isActive && view?.window != nil
            view?.isHidden = !visible
            if let view, let anchor {
                let attached = view.scene.anchors.contains { $0 === anchor }
                if visible && !attached { view.scene.addAnchor(anchor) }
                else if !visible && attached { view.scene.removeAnchor(anchor) }
            }
            displayLink?.isPaused = !loaded || !visible || reducirMovimiento || !giroAutomatico
            lastTime = 0
        }

        fileprivate func tick(_ link: CADisplayLink) {
            let seconds = lastTime == 0 ? 0 : Float(link.timestamp - lastTime)
            lastTime = link.timestamp
            state.avanzar(segundos: seconds, giroAutomatico: giroAutomatico, reducirMovimiento: reducirMovimiento)
            applyPose()
        }

        private func applyPose() {
            pivot.orientation = state.orientacion
            pivot.position.y = state.elevacion(reducirMovimiento: reducirMovimiento)
            updateCamera()
        }

        func updateCamera() {
            guard let view, view.bounds.height > 0 else { return }
            let aspect = Float(view.bounds.width / view.bounds.height)
            let distance = Objeto3DInspectionState.distancia(radio: radius, aspecto: aspect) * state.zoom

            let target: SIMD3<Float> = [0, -0.16, 0]
            camera.look(at: target, from: target + [0, 0.04, distance], relativeTo: nil)
        }

        @objc private func girar(_ gesture: UIPanGestureRecognizer) {
            guard loaded, let view else { return }
            if gesture.state == .began { giroAutomatico = false; onGirar() }
            let delta = gesture.translation(in: view)
            state.girar(x: Float(delta.x), y: Float(delta.y))
            gesture.setTranslation(.zero, in: view)
            applyPose()
        }

        @objc private func acercar(_ gesture: UIPinchGestureRecognizer) {
            state.acercar(escala: Float(gesture.scale))
            gesture.scale = 1
            applyPose()
        }

        func dispose() {
            generation = UUID()
            view?.isHidden = false
            if let view {
                gestures.forEach { view.removeGestureRecognizer($0) }
                if let anchor { view.scene.removeAnchor(anchor) }
            }
            gestures.removeAll()
            anchor = nil
            onLoad = { _ in }
            onGirar = {}
            loading?.cancel()
            loading = nil
            displayLink?.invalidate()
            displayLink = nil
            photos.dispose()
            fotos.removeAll()
            pivot.children.removeAll()
            loaded = false
        }

        private enum InspectionError: LocalizedError {
            case empty, unavailable
            var errorDescription: String? {
                switch self {
                case .empty: "La pieza no contiene geometría visible."
                case .unavailable: "No está disponible el visor 3D."
                }
            }
        }
    }
}

@MainActor private final class TickProxy: NSObject {
    weak var owner: VisorObjeto3D.Coordinator?
    @objc func tick(_ link: CADisplayLink) { owner?.tick(link) }
}

