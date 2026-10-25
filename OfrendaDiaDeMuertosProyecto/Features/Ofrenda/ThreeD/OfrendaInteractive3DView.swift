//
//  OfrendaInteractive3DView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 15/10/26.
//

import SwiftUI
import UIKit
import RealityKit
import simd
import QuartzCore

struct OfrendaInteractive3DView: UIViewRepresentable {
    let elementos: [ElementoOfrenda]
    let resetToken: Int
    @Binding var viewport: OfrendaViewportState
    let focusRequest: OfrendaFocusRequest?
    let reduceMotion: Bool
    let onFocusCompleted: (UUID) -> Void
    let onLoad: (ModelLoadState) -> Void
    let fotosMarcos: [MarcoOfrenda: FotoMarco]
    let onSeleccionarMarco: (MarcoOfrenda) -> Void
    let onErrorFoto: (String) -> Void

    /// Si quieres que se siga viendo la pared café detrás del altar, cambia esto a `false`
    var ocultarParedDeFondo: Bool = true
    var configuracionMarcos = ConfiguracionMarcos()
    var seleccionElementos = ConfiguracionElementosOfrenda()
    var isObscured = false
    var renderSession: OfrendaRenderSession?

    func makeCoordinator() -> Coordinator { Coordinator(session: renderSession) }

    func makeUIView(context: Context) -> UIView {
        let host = OfrendaRenderHost()
        context.coordinator.mount(self, in: host)
        return host
    }

    func updateUIView(_ view: UIView, context: Context) {
        context.coordinator.update(self)
    }

    static func dismantleUIView(_ view: UIView, coordinator: Coordinator) {
        guard let host = view as? OfrendaRenderHost else { return }
        host.onLayout = nil
        host.onWindow = nil
        coordinator.unmount(from: host)
    }

    /// Puente de un montaje SwiftUI. El motor y la escena pertenecen a la sesión compartida.
    @MainActor
    final class Coordinator {
        private let owner = UUID()
        private let session: OfrendaRenderSession
        private let shared: Bool
        private var renderer: Renderer?

        init(session: OfrendaRenderSession?) {
            shared = session != nil
            self.session = session ?? OfrendaRenderSession()
        }

        func mount(_ parent: OfrendaInteractive3DView, in host: OfrendaRenderHost) {
            let renderer = session.mount(owner: owner, host: host) {
                let renderer = Renderer(parent: parent, session: session)
                let view = OfferingInteractiveARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: false)
                OfrendaRenderConfiguration.apply(to: view)
                view.backgroundColor = .clear
                view.isUserInteractionEnabled = true
                view.onResize = { [weak renderer] in renderer?.resize() }
                renderer.setup(view: view)
                return (view, renderer)
            }
            self.renderer = renderer
            host.onLayout = { [weak self] in self?.hostDidChange() }
            host.onWindow = { [weak self] in self?.hostDidChange() }
            renderer.bind(to: parent, newOwner: true)
        }

        func update(_ parent: OfrendaInteractive3DView) {
            guard session.owns(owner) else { return }
            renderer?.bind(to: parent, newOwner: false)
        }

        private func hostDidChange() {
            guard session.owns(owner) else { return }
            renderer?.resize()
        }

        func unmount(from host: OfrendaRenderHost) {
            session.unmount(owner: owner, host: host, discard: !shared)
            renderer = nil
        }
    }

    @MainActor
    final class Renderer: NSObject, UIGestureRecognizerDelegate {
        private var elementos: [ElementoOfrenda]
        private let ocultarParedDeFondo: Bool
        private var publishViewport: ((OfrendaViewportState) -> Void)?
        private var pendingPublication: DispatchWorkItem?
        private var lastViewport = OfrendaViewportState()
        var lastFocusRequestID: UUID?
        var onFocusCompleted: (UUID) -> Void
        var reduceMotion: Bool
        private var focusTask: Task<Void, Never>?
        private var activeFocusID: UUID?
        private var cameraTarget = SIMD3<Float>.zero
        private var previousFraming: (zoom: Float, target: SIMD3<Float>)?
        var onLoad: (ModelLoadState) -> Void
        var onSeleccionarMarco: (MarcoOfrenda) -> Void
        let photoFrames = OfrendaPhotoFrames()
        private var fotosMarcos: [MarcoOfrenda: FotoMarco]
        var resetToken = 0
        var loadTask: Task<Void, Never>?

        private weak var view: ARView?
        private weak var renderSession: OfrendaRenderSession?
        private var requestedObscured = false
        private var loadState: ModelLoadState = .loading
        private var notifiedLoadState: ModelLoadState?
        private var pendingLoadNotification: DispatchWorkItem?
        private let pivot = Entity()
        private let camera = PerspectiveCamera()
        private var nodosAncla: [String: Entity] = [:]
        private var gruposAncla: [String: [Entity]] = [:]
        private var modeloCargado: Entity?
        private var sceneAnchor: AnchorEntity?
        private var isObscured = false
        private var configuracionMarcos = ConfiguracionMarcos()
        private var seleccionElementos = ConfiguracionElementosOfrenda()
        private let elementVisibility = OfrendaElementVisibility()
        private var candleLights: [PointLight] = []
        private struct CapturaPendiente {
            let id: UUID
            let orientation: simd_quatf
            let position: SIMD3<Float>
            let cameraTransform: Transform
            let interactionEnabled: Bool
            let completion: (Result<UIImage, Error>) -> Void
        }
        private var capturaPendiente: CapturaPendiente?
        private var tareaCaptura: Task<Void, Never>?
        private var tiempoLimiteCaptura: Task<Void, Never>?


        private var yaw: Float = 0
        private var pitch: Float = 0
        private var zoomFactor: Float = 1
        private var offset = SIMD3<Float>.zero
        private var extents = SIMD3<Float>(repeating: 2.65)
        private var previousSize = CGSize.zero

        init(parent: OfrendaInteractive3DView, session: OfrendaRenderSession) {
            self.seleccionElementos = parent.seleccionElementos
            self.renderSession = session
            self.elementos = parent.elementos
            self.ocultarParedDeFondo = parent.ocultarParedDeFondo
            let viewport = parent.$viewport
            self.publishViewport = { viewport.wrappedValue = $0 }
            self.onFocusCompleted = parent.onFocusCompleted
            self.reduceMotion = parent.reduceMotion
            self.onLoad = parent.onLoad
            self.resetToken = parent.resetToken
            self.onSeleccionarMarco = parent.onSeleccionarMarco
            self.fotosMarcos = parent.fotosMarcos
            self.photoFrames.onError = parent.onErrorFoto
        }

        func bind(to parent: OfrendaInteractive3DView, newOwner: Bool) {
            if newOwner {
                cancelarCaptura()
                cancelFocus()
                previousFraming = nil
                pendingPublication?.cancel()
                pendingLoadNotification?.cancel()
                lastViewport = OfrendaViewportState()
                previousSize = .zero
                notifiedLoadState = nil
                elementos = parent.elementos
                resetToken = parent.resetToken
                lastFocusRequestID = nil
            }
            let viewport = parent.$viewport
            publishViewport = { viewport.wrappedValue = $0 }
            onLoad = parent.onLoad
            onFocusCompleted = parent.onFocusCompleted
            reduceMotion = parent.reduceMotion
            onSeleccionarMarco = parent.onSeleccionarMarco
            photoFrames.onError = parent.onErrorFoto
            setObscured(parent.isObscured)
            setConfiguracion(parent.configuracionMarcos)
            setSeleccion(parent.seleccionElementos)
            setFotos(parent.fotosMarcos)
            if newOwner {
                if let modeloCargado { crearAnclasParaBotones(en: modeloCargado) }
                reset()
            } else if resetToken != parent.resetToken {
                resetToken = parent.resetToken
                reset()
                lastFocusRequestID = parent.focusRequest?.id
            } else if lastFocusRequestID != parent.focusRequest?.id {
                lastFocusRequestID = parent.focusRequest?.id
                if let request = parent.focusRequest { focus(on: request) }
                else { restoreFraming() }
            }
            notifyLoadState()
        }

        /// Retira el altar de la escena sin destruir mallas, texturas ni el motor de RealityKit.
        func suspend() {
            setObscured(true)
            cancelFocus()
            pendingPublication?.cancel()
            pendingLoadNotification?.cancel()
            publishViewport = nil
            onLoad = { _ in }
            onFocusCompleted = { _ in }
            onSeleccionarMarco = { _ in }
            photoFrames.onError = { _ in }
            notifiedLoadState = nil
        }

        private func reportLoad(_ state: ModelLoadState) {
            loadState = state
            notifyLoadState()
        }

        private func notifyLoadState() {
            guard notifiedLoadState != loadState else { return }
            // La nueva pantalla recibe ready cuando el visor ya tiene ventana, tamaño y escena.
            if loadState == .ready {
                guard !isObscured, let view, view.window != nil,
                      view.bounds.width > 0, view.bounds.height > 0 else { return }
            }
            pendingLoadNotification?.cancel()
            let state = loadState
            let notification = DispatchWorkItem { [weak self] in
                guard let self, self.loadState == state else { return }
                if state == .ready {
                    guard !self.isObscured, let view = self.view, view.window != nil,
                          view.bounds.width > 0, view.bounds.height > 0 else { return }
                }
                self.notifiedLoadState = state
                self.onLoad(state)
            }
            pendingLoadNotification = notification
            DispatchQueue.main.async(execute: notification)
        }

        func setup(view: ARView) {
            self.view = view
            let anchor = AnchorEntity(world: .zero)
            anchor.addChild(pivot)
            camera.camera.fieldOfViewInDegrees = 47
            anchor.addChild(camera)

            // Iluminación original de tu OfrendaModelView
            let key = DirectionalLight()
            key.light.intensity = 1100
            key.light.color = UIColor(red: 1, green: 0.94, blue: 0.86, alpha: 1)
            #if !targetEnvironment(simulator)
            key.shadow = .init(maximumDistance: 8, depthBias: 1)
            #endif
            key.look(at: .zero, from: [2, 3, 4], relativeTo: nil)
            anchor.addChild(key)

            let fill = PointLight()
            #if targetEnvironment(simulator)
            fill.light.intensity = 2800
            #else
            fill.light.intensity = 2200
            #endif
            fill.light.attenuationRadius = 6
            fill.position = [-2.5, 1.5, 3]
            anchor.addChild(fill)

            #if !targetEnvironment(simulator)
            let rim = PointLight()
            rim.light.intensity = 1600
            rim.light.color = UIColor(red: 0.92, green: 0.86, blue: 1, alpha: 1)
            rim.light.attenuationRadius = 6
            rim.position = [2, 2, -3]
            anchor.addChild(rim)
            #endif

            view.scene.addAnchor(anchor)
            sceneAnchor = anchor

            // Gestos interactivos (1 dedo girar, 2 dedos mover, pellizcar zoom, doble toque reset)
            let rotate = UIPanGestureRecognizer(target: self, action: #selector(rotate(_:)))
            rotate.maximumNumberOfTouches = 1
            let pan = UIPanGestureRecognizer(target: self, action: #selector(move(_:)))
            pan.minimumNumberOfTouches = 2
            pan.maximumNumberOfTouches = 2
            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:)))
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(resetFromGesture))
            doubleTap.numberOfTapsRequired = 2
            let tap = UITapGestureRecognizer(target: self, action: #selector(selectFrame(_:)))
            tap.require(toFail: doubleTap)
            for gesture in [rotate, pan, pinch, doubleTap, tap] {
                gesture.delegate = self
                view.addGestureRecognizer(gesture)
            }
            reset()

            loadTask = Task { @MainActor [weak self] in
                guard let self else { return }
                self.reportLoad(.loading)
                do {
                    let entity = try await OfrendaAssets.shared.clone(named: "Ofrenda")
                    try Task.checkCancellation()
                    let bounds = self.contentBounds(of: entity)
                    let longest = max(bounds.extents.x, bounds.extents.y, bounds.extents.z)
                    guard longest.isFinite, longest > 0 else { throw ModelError.emptyGeometry }

                    let scale: Float = 2.65 / longest
                    entity.scale = SIMD3(repeating: scale)
                    entity.position = -bounds.center * scale
                    self.extents = bounds.extents * scale

                    self.pivot.addChild(entity)
                    self.modeloCargado = entity
                    self.renderSession?.altar = entity
                    OfrendaMaterials.prepare(entity, ocultarPared: self.ocultarParedDeFondo)
                    self.addCandleLights(in: entity)
                    try self.photoFrames.attach(to: entity)
                    self.elementVisibility.attach(to: entity)
                    self.elementVisibility.apply(self.seleccionElementos)
                    self.photoFrames.configurar(self.configuracionMarcos, mostrarRetratos: self.seleccionElementos.muestra(.retrato))
                    self.photoFrames.update(self.fotosMarcos)
                    self.candleLights.forEach { $0.isEnabled = self.seleccionElementos.muestra(.velas) }
                    self.crearAnclasParaBotones(en: entity)
                    self.reset()
                    self.reportLoad(.ready)
                } catch is CancellationError { }
                catch {
                    self.reportLoad(.failed("No se pudo cargar la ofrenda: \(error.localizedDescription)"))
                }
            }
        }

        func dispose() {
            cancelarCaptura()
            pendingLoadNotification?.cancel()
            pendingLoadNotification = nil
            onLoad = { _ in }
            publishViewport = nil
            onFocusCompleted = { _ in }
            onSeleccionarMarco = { _ in }
            photoFrames.onError = { _ in }
            photoFrames.dispose()
            elementVisibility.dispose()
            candleLights.removeAll()
            fotosMarcos.removeAll()
            cancelFocus()
            pendingPublication?.cancel()
            pendingPublication = nil
            loadTask?.cancel()
            loadTask = nil
            nodosAncla.removeAll()
            gruposAncla.removeAll()
            modeloCargado = nil
            sceneAnchor = nil
            pivot.children.removeAll()
        }

        func setObscured(_ obscured: Bool) {
            requestedObscured = obscured
            applyVisibility()
        }

        func applyVisibility() {
            let obscured = requestedObscured || renderSession?.isInspecting == true
            guard isObscured != obscured, let view, let sceneAnchor else { return }
            isObscured = obscured
            if obscured {
                cancelarCaptura()
                cancelFocus()
                pendingPublication?.cancel()
                pendingPublication = nil
                view.scene.removeAnchor(sceneAnchor)
            } else {
                view.scene.addAnchor(sceneAnchor)
                updateCamera()
                notifyLoadState()
            }
        }

        func setConfiguracion(_ configuracion: ConfiguracionMarcos) {
            guard configuracionMarcos != configuracion else { return }
            configuracionMarcos = configuracion
            photoFrames.configurar(configuracion, mostrarRetratos: seleccionElementos.muestra(.retrato))
            if let modeloCargado {
                crearAnclasParaBotones(en: modeloCargado)
                updateCamera()
            }
        }

        func setSeleccion(_ seleccion: ConfiguracionElementosOfrenda) {
            guard seleccionElementos != seleccion else { return }
            seleccionElementos = seleccion
            elementVisibility.apply(seleccion)
            photoFrames.configurar(configuracionMarcos, mostrarRetratos: seleccion.muestra(.retrato))
            photoFrames.update(fotosMarcos)
            candleLights.forEach { $0.isEnabled = seleccion.muestra(.velas) }
            if let modeloCargado {
                crearAnclasParaBotones(en: modeloCargado)
                updateCamera()
            }
        }

        func setFotos(_ fotos: [MarcoOfrenda: FotoMarco]) {
            fotosMarcos = fotos
            photoFrames.update(fotos)
        }

        @objc private func selectFrame(_ gesture: UITapGestureRecognizer) {
            guard !isObscured, capturaPendiente == nil, gesture.state == .ended, focusTask == nil, let view,
                  let marco = photoFrames.frame(at: gesture.location(in: view), in: view, camera: camera) else { return }
            onSeleccionarMarco(marco)
        }

        private func crearAnclasParaBotones(en modelo: Entity) {
            for node in gruposAncla.values.flatMap({ $0 }) { node.removeFromParent() }
            gruposAncla.removeAll()
            nodosAncla.removeAll()

            for elemento in elementos where seleccionElementos.muestra(elemento: elemento.nombre) {
                let nombres = elemento.nombre == "Retrato" ? configuracionMarcos.visibles.map(\.rawValue) : elemento.entidadesAncla
                let centros = nombres.compactMap { nombre -> SIMD3<Float>? in
                    guard let objeto = modelo.findEntity(named: nombre), objeto.isEnabledInHierarchy else { return nil }
                    return objeto.visualBounds(relativeTo: pivot).center
                }
                let respaldo = SIMD3<Float>(
                    elemento.anclaNormalizada.x * extents.x,
                    (elemento.anclaNormalizada.y - 0.5) * extents.y,
                    elemento.anclaNormalizada.z * extents.z
                )
                let nodos = (centros.isEmpty ? [respaldo] : centros).enumerated().map { index, centro in
                    let pin = Entity()
                    pin.name = "Pin_\(elemento.nombre)_\(index)"
                    pin.position = centro
                    pivot.addChild(pin)
                    return pin
                }
                gruposAncla[elemento.nombre] = nodos
                nodosAncla[elemento.nombre] = nodos.first
            }
        }

        private func proyectarBotonesEnPantalla() {
            guard !isObscured, let view else { return }
            var nuevasPosiciones: [String: CGPoint] = [:]
            let centro = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
            for (nombre, nodos) in gruposAncla {
                // Un solo rótulo por categoría, ligado a la instancia más cercana al centro.
                let candidatos = nodos.compactMap { nodo -> (Entity, CGPoint)? in
                    let worldPos = nodo.position(relativeTo: nil)
                    let cameraSpace = camera.convert(position: worldPos, from: nil)
                    guard cameraSpace.z < -0.02, let punto = view.project(worldPos),
                          punto.x.isFinite, punto.y.isFinite else { return nil }
                    return (nodo, punto)
                }
                guard let elegido = candidatos.min(by: {
                    hypot($0.1.x - centro.x, $0.1.y - centro.y) < hypot($1.1.x - centro.x, $1.1.y - centro.y)
                }) else { continue }
                nodosAncla[nombre] = elegido.0
                nuevasPosiciones[nombre] = CGPoint(
                    x: (elegido.1.x * 2).rounded() / 2,
                    y: (elegido.1.y * 2).rounded() / 2
                )
            }

            let state = OfrendaViewportState(
                positions: nuevasPosiciones,
                zoomFactor: (zoomFactor * 1_000).rounded() / 1_000,
                frameProjections: photoFrames.projections(in: view, camera: camera)
            )
            guard lastViewport != state else { return }
            lastViewport = state
            pendingPublication?.cancel()
            let publication = DispatchWorkItem { [weak self] in
                self?.publishViewport?(state)
            }
            pendingPublication = publication
            // Publica fuera de layoutSubviews; el altar es estático y solo cambia con gestos/resize.
            DispatchQueue.main.async(execute: publication)
        }

        private func addCandleLights(in entity: Entity) {
            // El simulador conserva las llamas emisivas; evita luces por píxel extra.
            #if !targetEnvironment(simulator)
            for name in ["llama__01", "llama__04", "llama__09"] {
                guard let flame = entity.findEntity(named: name) else { continue }
                let light = PointLight()
                light.light.color = UIColor(red: 1, green: 0.55, blue: 0.18, alpha: 1)
                light.light.intensity = 24
                light.light.attenuationRadius = 0.65
                light.position = flame.visualBounds(relativeTo: pivot).center + [0, 0.025, 0]
                pivot.addChild(light)
                candleLights.append(light)
            }
            #endif
        }

        private func contentBounds(of root: Entity) -> BoundingBox {
            var minimum = SIMD3<Float>(repeating: .greatestFiniteMagnitude)
            var maximum = SIMD3<Float>(repeating: -.greatestFiniteMagnitude)
            var found = false
            func include(_ entity: Entity) {
                guard !entity.name.hasPrefix("fondo__") else { return }
                if entity is ModelEntity {
                    let bounds = entity.visualBounds(relativeTo: root)
                    minimum = simd_min(minimum, bounds.min)
                    maximum = simd_max(maximum, bounds.max)
                    found = true
                }
                for child in entity.children { include(child) }
            }
            include(root)
            return found ? BoundingBox(min: minimum, max: maximum) : root.visualBounds(relativeTo: nil)
        }

        func resize() {
            guard let view else { return }
            if view.bounds.size != previousSize {
                cancelarCaptura()
                previousSize = view.bounds.size
                updateCamera()
            }
            notifyLoadState()
        }

        /// Captura solo RealityKit: ninguna etiqueta SwiftUI ni controles entran en la imagen.
        func capturar(id: UUID, completion: @escaping (Result<UIImage, Error>) -> Void) {
            guard capturaPendiente == nil, loadState == .ready, !isObscured, focusTask == nil,
                  let view, view.window != nil, view.bounds.width > 0, view.bounds.height > 0 else {
                completion(.failure(OfrendaRenderSession.ErrorCaptura.noDisponible))
                return
            }
            capturaPendiente = CapturaPendiente(
                id: id, orientation: pivot.orientation, position: pivot.position,
                cameraTransform: camera.transform, interactionEnabled: view.isUserInteractionEnabled,
                completion: completion
            )
            view.isUserInteractionEnabled = false
            pivot.orientation = OfrendaCaptureFraming.orientation
            pivot.position = .zero
            let distance = OfrendaCaptureFraming.distance(
                extents: extents, aspect: Float(view.bounds.width / view.bounds.height)
            )
            camera.look(at: .zero, from: [0, 0, distance], relativeTo: nil)
            tareaCaptura = Task { @MainActor [weak self, weak view] in
                // Deja presentar el nuevo encuadre antes de solicitar el siguiente fotograma.
                do { try await Task.sleep(for: .milliseconds(180)) } catch { return }
                guard let self, let view, self.capturaPendiente?.id == id else { return }
                view.snapshot(saveToHDR: false) { [weak self] image in
                    Task { @MainActor in
                        guard let self else { return }
                        if let image {
                            self.finalizarCaptura(id: id, resultado: .success(image))
                        } else {
                            self.finalizarCaptura(id: id, resultado: .failure(OfrendaRenderSession.ErrorCaptura.fallida))
                        }
                    }
                }
            }
            tiempoLimiteCaptura = Task { @MainActor [weak self] in
                do { try await Task.sleep(for: .seconds(8)) } catch { return }
                self?.finalizarCaptura(id: id, resultado: .failure(OfrendaRenderSession.ErrorCaptura.fallida))
            }
        }

        func cancelarCaptura(id: UUID? = nil) {
            guard let pendiente = capturaPendiente, id == nil || pendiente.id == id else { return }
            finalizarCaptura(id: pendiente.id, resultado: .failure(CancellationError()))
        }

        private func finalizarCaptura(id: UUID, resultado: Result<UIImage, Error>) {
            guard let pendiente = capturaPendiente, pendiente.id == id else { return }
            capturaPendiente = nil
            tareaCaptura?.cancel()
            tareaCaptura = nil
            tiempoLimiteCaptura?.cancel()
            tiempoLimiteCaptura = nil
            pivot.orientation = pendiente.orientation
            pivot.position = pendiente.position
            camera.transform = pendiente.cameraTransform
            view?.isUserInteractionEnabled = pendiente.interactionEnabled
            proyectarBotonesEnPantalla()
            pendiente.completion(resultado)
        }

        func reset() {
            cancelFocus()
            previousFraming = nil
            yaw = -0.12; pitch = 0.12; zoomFactor = 1; offset = .zero
            cameraTarget = .zero
            updateCamera()
        }

        func cancelFocus() {
            activeFocusID = nil
            focusTask?.cancel()
            focusTask = nil
        }

        func focus(on request: OfrendaFocusRequest) {
            guard let node = nodosAncla[request.elementID] else {
                cancelFocus()
                focusTask = Task { @MainActor [weak self] in
                    await Task.yield()
                    guard !Task.isCancelled else { return }
                    self?.focusTask = nil
                    self?.onFocusCompleted(request.id)
                }
                return
            }
            if previousFraming == nil {
                previousFraming = (zoomFactor, cameraTarget)
            }
            let finalZoom = OfrendaCameraPolicy.focusZoom(from: zoomFactor)
            let worldPoint = node.position(relativeTo: nil)
            // Deja el objeto por encima de la hoja de media pantalla.
            let verticalOffset = cameraDistance(zoom: finalZoom) * tan(Float(47) * .pi / 360) * 0.5
            let target = worldPoint - SIMD3<Float>(0, verticalOffset, 0)
            animateCamera(zoom: finalZoom, target: target, duration: 0.36) { [weak self] in
                self?.onFocusCompleted(request.id)
            }
        }

        func restoreFraming() {
            guard let previousFraming else { cancelFocus(); return }
            animateCamera(zoom: previousFraming.zoom, target: previousFraming.target, duration: 0.28) { [weak self] in
                self?.previousFraming = nil
            }
        }

        private func animateCamera(
            zoom finalZoom: Float, target finalTarget: SIMD3<Float>, duration: Double,
            completion: @escaping @MainActor () -> Void
        ) {
            cancelFocus()
            let animationID = UUID()
            activeFocusID = animationID
            focusTask = Task { @MainActor [weak self] in
                guard let self else { return }
                defer {
                    if self.activeFocusID == animationID {
                        self.activeFocusID = nil
                        self.focusTask = nil
                    }
                }
                let initialZoom = self.zoomFactor
                let initialTarget = self.cameraTarget
                let duration = self.reduceMotion ? 0 : duration
                let start = CACurrentMediaTime()
                while !Task.isCancelled {
                    let progress = duration == 0 ? Float(1) : min(1, Float((CACurrentMediaTime() - start) / duration))
                    let eased = progress * progress * (3 - 2 * progress)
                    self.zoomFactor = initialZoom + (finalZoom - initialZoom) * eased
                    self.cameraTarget = initialTarget + (finalTarget - initialTarget) * eased
                    self.updateCamera()
                    if progress >= 1 { break }
                    do { try await Task.sleep(for: .milliseconds(16)) }
                    catch { return }
                }
                guard !Task.isCancelled, self.activeFocusID == animationID else { return }
                completion()
            }
        }

        private func cameraDistance(zoom: Float) -> Float {
            guard let view else { return 3 }
            let aspect = max(Float(view.bounds.width / max(view.bounds.height, 1)), 0.2)
            let verticalTangent = tan(Float(47) * .pi / 360)
            let fitWidth = extents.x / (2 * verticalTangent * aspect)
            let fitHeight = extents.y / (2 * verticalTangent)
            return (max(fitWidth, fitHeight) * 1.18 + extents.z / 2) * zoom
        }

        private func updateCamera() {
            guard !isObscured, capturaPendiente == nil, view != nil else { return }
            let distance = cameraDistance(zoom: zoomFactor)
            pivot.orientation = simd_quatf(angle: yaw, axis: [0, 1, 0]) * simd_quatf(angle: pitch, axis: [1, 0, 0])
            pivot.position = offset
            camera.look(at: cameraTarget, from: cameraTarget + [0, 0.08, distance], relativeTo: nil)
            proyectarBotonesEnPantalla()
        }

        @objc private func resetFromGesture() { reset() }

        @objc private func rotate(_ gesture: UIPanGestureRecognizer) {
            guard !isObscured, focusTask == nil, let view else { return }
            let movement = gesture.translation(in: view)
            yaw = OfrendaCameraPolicy.yaw(yaw + Float(movement.x) * 0.007)
            pitch = OfrendaCameraPolicy.pitch(pitch + Float(movement.y) * 0.006)
            gesture.setTranslation(.zero, in: view)
            updateCamera()
        }

        @objc private func move(_ gesture: UIPanGestureRecognizer) {
            guard !isObscured, focusTask == nil, let view else { return }
            let movement = gesture.translation(in: view)
            offset.x = min(1.5, max(-1.5, offset.x + Float(movement.x) * 0.004))
            offset.y = min(1.5, max(-1.5, offset.y - Float(movement.y) * 0.004))
            gesture.setTranslation(.zero, in: view)
            updateCamera()
        }

        @objc private func zoom(_ gesture: UIPinchGestureRecognizer) {
            guard !isObscured, focusTask == nil else { return }
            zoomFactor = OfrendaCameraPolicy.zoom(zoomFactor / Float(gesture.scale))
            gesture.scale = 1
            updateCamera()
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            gestureRecognizer is UIPinchGestureRecognizer || otherGestureRecognizer is UIPinchGestureRecognizer
        }
    }

    private enum ModelError: Error { case emptyGeometry }
}

private final class OfferingInteractiveARView: ARView {
    var onResize: (() -> Void)?
    override func layoutSubviews() {
        super.layoutSubviews()
        onResize?()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil else { return }
        // Se configura al montar el visor; no se renegocia en cada layout.
        contentScaleFactor = min(max(traitCollection.displayScale, 1), 2)
    }
}


