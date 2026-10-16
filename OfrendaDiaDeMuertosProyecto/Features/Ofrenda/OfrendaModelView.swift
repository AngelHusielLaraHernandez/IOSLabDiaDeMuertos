import SwiftUI
import UIKit
import RealityKit
import simd
import PhotosUI

// MARK: - UIViewRepresentable
struct OfrendaModelView: UIViewRepresentable {
    let resetToken: Int
    @Binding var photo: UIImage?
    let onLoad: (ModelLoadState) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(onLoad: onLoad) }

    func makeUIView(context: Context) -> ARView {
        let view = OfferingARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: false)
        view.environment.background = .color(UIColor(red: 0.11, green: 0.05, blue: 0.18, alpha: 1))
        view.isUserInteractionEnabled = true
        view.renderOptions = [.disableMotionBlur, .disableDepthOfField]
        let coordinator = context.coordinator
        view.onResize = { [weak coordinator] in coordinator?.resize() }
        coordinator.setup(view: view)
        return view
    }

    func updateUIView(_ view: ARView, context: Context) {
        context.coordinator.onLoad = onLoad
        if context.coordinator.resetToken != resetToken {
            context.coordinator.resetToken = resetToken
            context.coordinator.reset()
        }
        if context.coordinator.currentPhoto !== photo {
            context.coordinator.setPhoto(photo)
        }
    }

    static func dismantleUIView(_ view: ARView, coordinator: Coordinator) {
        coordinator.loadTask?.cancel();  coordinator.loadTask  = nil
        coordinator.photoTask?.cancel(); coordinator.photoTask = nil
        view.scene.anchors.removeAll()
    }

    // MARK: - Coordinator
    @MainActor
    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onLoad: (ModelLoadState) -> Void
        var resetToken = 0
        var loadTask: Task<Void, Never>?
        var photoTask: Task<Void, Never>?
        private(set) var currentPhoto: UIImage?

        private weak var view: ARView?
        private let pivot  = Entity()
        private let camera = PerspectiveCamera()
        private var yaw: Float = 0
        private var pitch: Float = 0
        private var zoomFactor: Float = 1
        private var offset = SIMD3<Float>.zero
        private var extents = SIMD3<Float>(repeating: 2.65)
        private var previousSize = CGSize.zero

        private var ofrendaEntity: Entity?
        private var fotoEntity: Entity?

        init(onLoad: @escaping (ModelLoadState) -> Void) { self.onLoad = onLoad }

        func setup(view: ARView) {
            self.view = view
            let anchor = AnchorEntity(world: .zero)
            anchor.addChild(pivot)
            camera.camera.fieldOfViewInDegrees = 47
            anchor.addChild(camera)

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

            loadTask = Task { @MainActor [weak self] in
                guard let self else { return }
                self.onLoad(.loading)

                // ───────────── 1) Ofrenda ─────────────
                do {
                    let ofrenda = try await self.loadModel(named: "Ofrenda")
                    try Task.checkCancellation()

                    let oBounds = self.contentBounds(of: ofrenda, excludingPrefix: "fondo__")
                    let oLongest = self.longestSide(oBounds)
                    let oScale: Float = (oLongest.isFinite && oLongest > 0.0001)
                        ? 2.65 / oLongest
                        : 1.0
                    print("[OfrendaModelView] Ofrenda bounds: \(oBounds), longest: \(oLongest), scale: \(oScale)")

                    ofrenda.scale = SIMD3(repeating: oScale)
                    ofrenda.position = -oBounds.center * oScale
                    self.extents = oBounds.extents * oScale

                    self.pivot.addChild(ofrenda)
                    self.prepareMaterials(ofrenda)
                    self.addCandleLights(in: ofrenda)
                    self.ofrendaEntity = ofrenda
                } catch is CancellationError {
                    return
                } catch {
                    self.onLoad(.failed("Ofrenda: \(self.mensajeDe(error))"))
                    return
                }

                // ───────────── 2) Foto ─────────────
                do {
                    let foto = try await self.loadModel(named: "foto")
                    try Task.checkCancellation()

                    let fBounds = self.contentBounds(of: foto, excludingPrefix: nil)
                    let fLongest = self.longestSide(fBounds)
                    let normScale: Float = (fLongest.isFinite && fLongest > 0.0001)
                        ? 2.65 / fLongest
                        : 1.0
                    let finalScale = normScale * 0.2
                    print("[OfrendaModelView] foto bounds: \(fBounds), longest: \(fLongest), scale: \(finalScale)")

                    foto.scale = SIMD3(repeating: finalScale)
                    foto.orientation = simd_quatf(angle: .pi / 2, axis: [0, 0, 0])

                    self.pivot.addChild(foto)

                    // Recentrar tras S+R y subir un poco
                    let post = foto.visualBounds(relativeTo: self.pivot)
                    foto.position = -post.center + SIMD3<Float>(0, 0.4, 0)

                    self.fotoEntity = foto

                    if let currentPhoto = self.currentPhoto {
                        self.setPhoto(currentPhoto)
                    }
                } catch is CancellationError {
                    return
                } catch {
                    // La ofrenda ya cargó; reportamos sólo el fallo de la foto.
                    print("[OfrendaModelView] Error cargando foto: \(error)")
                    self.onLoad(.failed("foto: \(self.mensajeDe(error))"))
                    return
                }

                self.reset()
                self.onLoad(.ready)
            }
        }

        // MARK: - Helpers

        private func mensajeDe(_ error: Error) -> String {
            if let me = error as? ModelError {
                switch me {
                case .emptyGeometry:           return "geometría vacía (bounds = 0)"
                case .notFound(let n):         return "no se encontró \(n).usdz en el bundle"
                case .loadFailed(let n, let e): return "no se pudo cargar \(n).usdz: \(e)"
                }
            }
            return error.localizedDescription
        }

        private func longestSide(_ b: BoundingBox) -> Float {
            max(b.extents.x, b.extents.y, b.extents.z)
        }

        private func loadModel(named name: String) async throws -> Entity {
            guard let url = Bundle.main.url(forResource: name, withExtension: "usdz") else {
                throw ModelError.notFound(name)
            }
            do {
                return try await Entity(contentsOf: url)
            } catch {
                throw ModelError.loadFailed(name, error.localizedDescription)
            }
        }

        @MainActor
        func setPhoto(_ image: UIImage?) {
            currentPhoto = image
            photoTask?.cancel()
            guard let image else { return }

            let small = downscale(image, maxDimension: 1024)
            guard let cgImage = small.cgImage else { return }

            photoTask = Task { @MainActor [weak self] in
                guard let self else { return }
                do {
                    let texture = try await TextureResource.generate(
                        from: cgImage,
                        options: .init(semantic: .color)
                    )
                    try Task.checkCancellation()
                    self.applyPhotoTexture(texture)
                } catch is CancellationError {
                } catch {
                    self.onLoad(.failed("No se pudo aplicar la foto: \(error.localizedDescription)"))
                }
            }
        }

        private func applyPhotoTexture(_ texture: TextureResource) {
            guard let fotoEntity else { return }

            var material = PhysicallyBasedMaterial()
            material.baseColor = .init(tint: .white, texture: .init(texture))
            material.roughness = .init(floatLiteral: 0.85)
            material.metallic  = .init(floatLiteral: 0.0)
            material.faceCulling = .none

            for target in photoTargets(in: fotoEntity) {
                guard var component = target.model else { continue }
                component.materials = component.materials.map { _ in material }
                target.model = component
            }
        }

        private func photoTargets(in entity: Entity) -> [ModelEntity] {
            let candidates = ["foto__", "pantalla__", "photo__", "image__",
                              "cuadro__", "retrato__", "marco_foto__"]
            for name in candidates {
                if let e = entity.findEntity(named: name) as? ModelEntity {
                    return [e]
                }
            }
            var all: [ModelEntity] = []
            func walk(_ e: Entity) {
                if let m = e as? ModelEntity { all.append(m) }
                e.children.forEach(walk)
            }
            walk(entity)
            return all
        }

        private func downscale(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
            let longest = max(image.size.width, image.size.height)
            guard longest > maxDimension else { return image }
            let ratio = maxDimension / longest
            let newSize = CGSize(width:  image.size.width  * ratio,
                                 height: image.size.height * ratio)
            let renderer = UIGraphicsImageRenderer(size: newSize)
            return renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: newSize))
            }
        }

        private func prepareMaterials(_ entity: Entity, path: String = "") {
            let fullPath = path + "/" + entity.name
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

        /// Acumula bounds de todos los `ModelEntity` válidos; si no encuentra
        /// ninguno con geometría útil, cae a `root.visualBounds(relativeTo: nil)`.
        private func contentBounds(of root: Entity, excludingPrefix: String?) -> BoundingBox {
            var minimum = SIMD3<Float>(repeating: .greatestFiniteMagnitude)
            var maximum = SIMD3<Float>(repeating: -.greatestFiniteMagnitude)
            var found = false

            func include(_ entity: Entity) {
                if let p = excludingPrefix, entity.name.hasPrefix(p) { return }

                if entity is ModelEntity {
                    let b = entity.visualBounds(relativeTo: root)
                    let e = b.extents
                    let valid = e.x.isFinite && e.y.isFinite && e.z.isFinite &&
                                (e.x > 0.0001 || e.y > 0.0001 || e.z > 0.0001) &&
                                b.min.x.isFinite && b.min.y.isFinite && b.min.z.isFinite &&
                                b.max.x.isFinite && b.max.y.isFinite && b.max.z.isFinite
                    if valid {
                        minimum = simd_min(minimum, b.min)
                        maximum = simd_max(maximum, b.max)
                        found = true
                    }
                }
                for child in entity.children { include(child) }
            }
            include(root)

            if found { return BoundingBox(min: minimum, max: maximum) }

            // Fallback: bounds de todo el árbol (incluye fondo__). Mejor algo que nada.
            let fb = root.visualBounds(relativeTo: nil)
            if fb.extents.x.isFinite, fb.extents.y.isFinite, fb.extents.z.isFinite,
               (fb.extents.x > 0.0001 || fb.extents.y > 0.0001 || fb.extents.z > 0.0001) {
                return fb
            }
            // Último recurso: caja 1×1×1 centrada en el origen.
            return BoundingBox(min: SIMD3<Float>(-0.5, -0.5, -0.5),
                               max: SIMD3<Float>( 0.5,  0.5,  0.5))
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
            let fitWidth  = extents.x / (2 * verticalTangent * aspect)
            let fitHeight = extents.y / (2 * verticalTangent)
            let distance  = (max(fitWidth, fitHeight) * 1.18 + extents.z / 2) * zoomFactor
            pivot.orientation = simd_quatf(angle: yaw,   axis: [0, 1, 0])
                              * simd_quatf(angle: pitch, axis: [1, 0, 0])
            pivot.position = offset
            camera.look(at: .zero, from: [0, 0.08, distance], relativeTo: nil)
        }

        @objc private func resetFromGesture() { reset() }

        @objc private func rotate(_ gesture: UIPanGestureRecognizer) {
            guard let view else { return }
            let movement = gesture.translation(in: view)
            yaw   += Float(movement.x) * 0.007
            pitch  = min(.pi / 2, max(-.pi / 2, pitch + Float(movement.y) * 0.006))
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

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                               shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool {
            gestureRecognizer is UIPinchGestureRecognizer || other is UIPinchGestureRecognizer
        }
    }

    enum ModelError: Error {
        case emptyGeometry
        case notFound(String)
        case loadFailed(String, String)
    }
}

// MARK: - ARView con callback de resize
private final class OfferingARView: ARView {
    var onResize: (() -> Void)?
    override func layoutSubviews() {
        super.layoutSubviews()
        onResize?()
    }
}

// MARK: - Estados de carga
enum ModelLoadState: Equatable {
    case loading, ready, failed(String)
}
