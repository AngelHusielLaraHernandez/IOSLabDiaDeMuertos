//
//  OfrendaInteractive3DView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 15/10/26.
//

import SwiftUI
import UIKit
import RealityKit
import Combine
import simd

struct OfrendaInteractive3DView: UIViewRepresentable {
    let elementos: [ElementoOfrenda]
    let resetToken: Int
    @Binding var posicionesEnPantalla: [String: CGPoint]
    let onLoad: (ModelLoadState) -> Void

    /// Si quieres que se siga viendo la pared café detrás del altar, cambia esto a `false`
    var ocultarParedDeFondo: Bool = true

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, onLoad: onLoad)
    }

    func makeUIView(context: Context) -> ARView {
        let view = OfferingInteractiveARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: false)
        
        // Fondo morado oscuro (#1C0D2E) igual al de OfrendaExplorarView en lugar del naranja
        view.environment.background = .color(UIColor(red: 0.11, green: 0.05, blue: 0.18, alpha: 1.0))
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.renderOptions = [.disableMotionBlur, .disableDepthOfField]
        
        let coordinator = context.coordinator
        view.onResize = { [weak coordinator] in coordinator?.resize() }
        coordinator.setup(view: view)
        return view
    }

    func updateUIView(_ view: ARView, context: Context) {
        context.coordinator.parent = self
        context.coordinator.onLoad = onLoad
        if context.coordinator.resetToken != resetToken {
            context.coordinator.resetToken = resetToken
            context.coordinator.reset()
        }
    }

    static func dismantleUIView(_ view: ARView, coordinator: Coordinator) {
        coordinator.loadTask?.cancel()
        coordinator.loadTask = nil
        coordinator.updateSubscription?.cancel()
        view.scene.anchors.removeAll()
    }

    @MainActor
    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: OfrendaInteractive3DView
        var onLoad: (ModelLoadState) -> Void
        var resetToken = 0
        var loadTask: Task<Void, Never>?
        var updateSubscription: Cancellable?
        
        private weak var view: ARView?
        private let pivot = Entity()
        private let camera = PerspectiveCamera()
        private var nodosAncla: [String: Entity] = [:]
        
        private var yaw: Float = 0
        private var pitch: Float = 0
        private var zoomFactor: Float = 1
        private var offset = SIMD3<Float>.zero
        private var extents = SIMD3<Float>(repeating: 2.65)
        private var previousSize = CGSize.zero

        init(parent: OfrendaInteractive3DView, onLoad: @escaping (ModelLoadState) -> Void) {
            self.parent = parent
            self.onLoad = onLoad
            self.resetToken = parent.resetToken
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
            key.shadow = .init(maximumDistance: 12, depthBias: 1)
            key.look(at: .zero, from: [2, 3, 4], relativeTo: nil)
            anchor.addChild(key)

            let fill = PointLight()
            fill.light.intensity = 2200
            fill.light.attenuationRadius = 15
            fill.position = [-2.5, 1.5, 3]
            anchor.addChild(fill)

            let rim = PointLight()
            rim.light.intensity = 1600
            rim.light.color = UIColor(red: 0.92, green: 0.86, blue: 1, alpha: 1)
            rim.light.attenuationRadius = 12
            rim.position = [2, 2, -3]
            anchor.addChild(rim)

            view.scene.addAnchor(anchor)

            // Gestos interactivos (1 dedo girar, 2 dedos mover, pellizcar zoom, doble toque reset)
            let rotate = UIPanGestureRecognizer(target: self, action: #selector(rotate(_:)))
            rotate.maximumNumberOfTouches = 1
            let pan = UIPanGestureRecognizer(target: self, action: #selector(move(_:)))
            pan.minimumNumberOfTouches = 2
            pan.maximumNumberOfTouches = 2
            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:)))
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(resetFromGesture))
            doubleTap.numberOfTapsRequired = 2
            for gesture in [rotate, pan, pinch, doubleTap] {
                gesture.delegate = self
                view.addGestureRecognizer(gesture)
            }
            reset()

            // Suscripción por fotograma para actualizar la proyección 2D de los 8 botones
            updateSubscription = view.scene.subscribe(to: SceneEvents.Update.self) { [weak self] _ in
                self?.proyectarBotonesEnPantalla()
            }

            loadTask = Task { @MainActor [weak self] in
                guard let self else { return }
                self.onLoad(.loading)
                guard let url = Bundle.main.url(forResource: "Ofrenda", withExtension: "usdz") else {
                    self.onLoad(.failed("No se encontró Ofrenda.usdz en los recursos de la app."))
                    return
                }
                do {
                    let entity = try await Entity(contentsOf: url)
                    try Task.checkCancellation()
                    let bounds = self.contentBounds(of: entity)
                    let longest = max(bounds.extents.x, bounds.extents.y, bounds.extents.z)
                    guard longest.isFinite, longest > 0 else { throw ModelError.emptyGeometry }
                    
                    let scale: Float = 2.65 / longest
                    entity.scale = SIMD3(repeating: scale)
                    entity.position = -bounds.center * scale
                    self.extents = bounds.extents * scale
                    
                    self.pivot.addChild(entity)
                    self.prepareMaterials(entity)
                    self.addCandleLights(in: entity)
                    self.crearAnclasParaBotones()
                    self.reset()
                    self.onLoad(.ready) // Coincide con tu enum ModelLoadState
                } catch is CancellationError { }
                catch {
                    self.onLoad(.failed("No se pudo cargar la ofrenda: \(error.localizedDescription)"))
                }
            }
        }

        private func crearAnclasParaBotones() {
            for (_, oldNode) in nodosAncla {
                oldNode.removeFromParent()
            }
            nodosAncla.removeAll()

            // Posiciona cada botón dentro del pivote 3D según las dimensiones escaladas del altar
            for elemento in parent.elementos {
                let pin = Entity()
                pin.name = "Pin_\(elemento.nombre)"
                pin.position = SIMD3<Float>(
                    elemento.anclaNormalizada.x * extents.x,
                    (elemento.anclaNormalizada.y - 0.5) * extents.y,
                    elemento.anclaNormalizada.z * extents.z
                )
                pivot.addChild(pin)
                nodosAncla[elemento.nombre] = pin
            }
        }

        private func proyectarBotonesEnPantalla() {
            guard let view, !nodosAncla.isEmpty else { return }
            var nuevasPosiciones: [String: CGPoint] = [:]
            
            for (nombre, nodo) in nodosAncla {
                let worldPos = nodo.position(relativeTo: nil)
                if let punto2D = view.project(worldPos),
                   punto2D.x.isFinite, punto2D.y.isFinite {
                    nuevasPosiciones[nombre] = punto2D
                }
            }
            
            if parent.posicionesEnPantalla != nuevasPosiciones {
                parent.posicionesEnPantalla = nuevasPosiciones
            }
        }

        private func prepareMaterials(_ entity: Entity, path: String = "") {
            let fullPath = path + "/" + entity.name
            
            // Oculta el plano de fondo exportado de Blender si ocultarParedDeFondo es true
            if parent.ocultarParedDeFondo && entity.name.hasPrefix("fondo__") {
                entity.isEnabled = false
                return
            }

            if let model = entity as? ModelEntity, var component = model.model {
                component.materials = component.materials.map { material in
                    guard var pbr = material as? PhysicallyBasedMaterial else { return material }
                    if fullPath.contains("papel__") {
                        pbr.faceCulling = .none
                        pbr.opacityThreshold = 0.5
                    }
                    if fullPath.contains("flores__") { pbr.faceCulling = .none }
                    if fullPath.contains("llama__") || fullPath.contains("Llama___Compartida") {
                        pbr.emissiveColor = .init(color: UIColor(red: 1, green: 0.45, blue: 0.08, alpha: 1))
                        pbr.emissiveIntensity = 2.5
                    }
                    return pbr
                }
                model.model = component
            }
            for child in entity.children { prepareMaterials(child, path: fullPath) }
        }

        private func addCandleLights(in entity: Entity) {
            for name in ["llama__01", "llama__04", "llama__09"] {
                guard let flame = entity.findEntity(named: name) else { continue }
                let light = PointLight()
                light.light.color = UIColor(red: 1, green: 0.55, blue: 0.18, alpha: 1)
                light.light.intensity = 24
                light.light.attenuationRadius = 0.65
                light.position = flame.visualBounds(relativeTo: pivot).center + [0, 0.025, 0]
                pivot.addChild(light)
            }
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
            guard let view, view.bounds.size != previousSize else { return }
            previousSize = view.bounds.size
            updateCamera()
        }

        func reset() {
            yaw = -0.12; pitch = 0.12; zoomFactor = 1; offset = .zero
            updateCamera()
        }

        private func updateCamera() {
            guard let view else { return }
            let aspect = max(Float(view.bounds.width / max(view.bounds.height, 1)), 0.2)
            let verticalTangent = tan(Float(47) * .pi / 360)
            let fitWidth = extents.x / (2 * verticalTangent * aspect)
            let fitHeight = extents.y / (2 * verticalTangent)
            let distance = (max(fitWidth, fitHeight) * 1.18 + extents.z / 2) * zoomFactor
            pivot.orientation = simd_quatf(angle: yaw, axis: [0, 1, 0]) * simd_quatf(angle: pitch, axis: [1, 0, 0])
            pivot.position = offset
            camera.look(at: .zero, from: [0, 0.08, distance], relativeTo: nil)
            proyectarBotonesEnPantalla()
        }

        @objc private func resetFromGesture() { reset() }

        @objc private func rotate(_ gesture: UIPanGestureRecognizer) {
            guard let view else { return }
            let movement = gesture.translation(in: view)
            yaw += Float(movement.x) * 0.007
            pitch = min(.pi / 2, max(-.pi / 2, pitch + Float(movement.y) * 0.006))
            gesture.setTranslation(.zero, in: view)
            updateCamera()
        }

        @objc private func move(_ gesture: UIPanGestureRecognizer) {
            guard let view else { return }
            let movement = gesture.translation(in: view)
            offset.x = min(1.5, max(-1.5, offset.x + Float(movement.x) * 0.004))
            offset.y = min(1.5, max(-1.5, offset.y - Float(movement.y) * 0.004))
            gesture.setTranslation(.zero, in: view)
            updateCamera()
        }

        @objc private func zoom(_ gesture: UIPinchGestureRecognizer) {
            zoomFactor = min(2.5, max(0.3, zoomFactor / Float(gesture.scale)))
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
}


