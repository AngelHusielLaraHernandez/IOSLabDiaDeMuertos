//
//  OfrendaPhotoFrames.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 17/10/26.
//

import SwiftUI
import RealityKit
import simd

/// Añade únicamente la superficie de foto; conserva los materiales del marco original.
@MainActor
final class OfrendaPhotoFrames {
    private struct Surface {
        let parent: ModelEntity
        let overlay: ModelEntity
        let corners: [SIMD3<Float>]
    }

    private struct Frame {
        let entity: Entity
        let transform: Transform
        let center: SIMD3<Float>
    }
    private var frames: [MarcoOfrenda: Frame] = [:]
    private weak var root: Entity?
    private var visibles = Set(MarcoOfrenda.allCases)
    private var surfaces: [MarcoOfrenda: Surface] = [:]
    private var requested: [MarcoOfrenda: UUID] = [:]
    private var tasks: [MarcoOfrenda: Task<Void, Never>] = [:]
    var onError: (String) -> Void = { _ in }

    func attach(to root: Entity, marcos: [MarcoOfrenda] = MarcoOfrenda.allCases) throws {
        dispose()
        self.root = root
        visibles = Set(marcos)
        for frame in marcos {
            guard let entity = root.findEntity(named: frame.rawValue),
                  let parent = firstModel(in: entity),
                  let mesh = parent.model?.mesh else { throw FrameError.surfaceMissing(frame) }

            frames[frame] = Frame(entity: entity, transform: entity.transform,
                                  center: entity.visualBounds(relativeTo: root).center)
            // lambert2 es el panel frontal (dos triángulos) en este USDZ.
            // Se leen sus vértices reales para heredar escala, inclinación y posición.
            let parts = mesh.contents.models.flatMap { Array($0.parts) }
            guard let part = parts.first(where: {
                $0.materialIndex == 2 && $0.positions.count == 4 && $0.triangleIndices?.count == 6
            }) else { throw FrameError.surfaceMissing(frame) }

            let ordered = part.positions.elements.sorted { $0.z < $1.z }
            let bottom = ordered.prefix(2).sorted { $0.x < $1.x }
            let top = ordered.suffix(2).sorted { $0.x < $1.x }
            let corners = [bottom[0], bottom[1], top[1], top[0]]
            let normal = simd_normalize(simd_cross(corners[1] - corners[0], corners[3] - corners[0]))

            var descriptor = MeshDescriptor(name: "Foto_\(frame.rawValue)")
            // Separación mínima para evitar parpadeo entre dos caras coplanares.
            descriptor.positions = MeshBuffer(corners.map { $0 + normal * 0.0005 })
            descriptor.normals = MeshBuffer(Array(repeating: normal, count: 4))
            descriptor.textureCoordinates = MeshBuffer([SIMD2<Float>(0, 0), [1, 0], [1, 1], [0, 1]])
            descriptor.primitives = .triangles([0, 1, 2, 0, 2, 3])
            let overlay = ModelEntity(mesh: try MeshResource.generate(from: [descriptor]),
                                      materials: [UnlitMaterial(color: .white)])
            overlay.name = "FotoUsuario_\(frame.rawValue)"
            overlay.isEnabled = false
            parent.addChild(overlay)
            surfaces[frame] = Surface(parent: parent, overlay: overlay, corners: corners)
        }
    }

    func configurar(_ configuracion: ConfiguracionMarcos, mostrarRetratos: Bool = true) {
        visibles = mostrarRetratos ? Set(configuracion.visibles) : []
        for (marco, frame) in frames {
            frame.entity.transform = frame.transform
            frame.entity.isEnabled = visibles.contains(marco)
            if configuracion.cantidad == .uno, marco == configuracion.principal, let root {
                let original = frame.entity.position(relativeTo: root)
                frame.entity.setPosition(original - SIMD3<Float>(frame.center.x, 0, 0), relativeTo: root)
            }
        }
    }

    func update(_ fotos: [MarcoOfrenda: FotoMarco]) {
        for frame in MarcoOfrenda.allCases {
            guard let surface = surfaces[frame] else { continue }
            guard visibles.contains(frame), let foto = fotos[frame] else {
                tasks.removeValue(forKey: frame)?.cancel()
                if requested.removeValue(forKey: frame) != nil, var component = surface.overlay.model {
                    component.materials = [UnlitMaterial(color: .white)]
                    surface.overlay.model = component
                }
                surface.overlay.isEnabled = false
                continue
            }
            guard requested[frame] != foto.id else { continue }
            requested[frame] = foto.id
            tasks.removeValue(forKey: frame)?.cancel()
            tasks[frame] = Task { @MainActor [weak self] in
                do {
                    guard let image = foto.imagen.cgImage else { throw FrameError.surfaceMissing(frame) }
                    let texture = try await TextureResource(image: image, options: .init(semantic: .color))
                    try Task.checkCancellation()
                    guard let self, self.requested[frame] == foto.id else { return }
                    var material = UnlitMaterial()
                    material.color = .init(tint: .white, texture: .init(texture))
                    material.faceCulling = .none
                    if var component = surface.overlay.model {
                        component.materials = [material]
                        surface.overlay.model = component
                    }
                    surface.overlay.isEnabled = true
                    self.tasks[frame] = nil
                } catch is CancellationError { }
                catch {
                    guard let self, self.requested[frame] == foto.id else { return }
                    self.tasks[frame] = nil
                    self.onError("No se pudo mostrar la foto del \(frame.titulo.lowercased()). Intenta elegirla de nuevo.")
                }
            }
        }
    }

    /// Proyección compartida para los botones de foto y la reserva de espacio de las historias.
    func projections(in view: ARView, camera: PerspectiveCamera) -> [MarcoOfrenda: MarcoProjection] {
        var result: [MarcoOfrenda: MarcoProjection] = [:]
        for frame in MarcoOfrenda.allCases {
            guard visibles.contains(frame), let surface = surfaces[frame] else { continue }
            let world = surface.corners.map { surface.parent.convert(position: $0, to: nil) }
            let normal = simd_cross(world[1] - world[0], world[3] - world[0])
            guard simd_dot(normal, camera.position(relativeTo: nil) - world[0]) > 0,
                  world.allSatisfy({ camera.convert(position: $0, from: nil).z < -0.02 }) else { continue }
            let points = world.compactMap { view.project($0) }
            guard points.count == 4, points.allSatisfy({ $0.x.isFinite && $0.y.isFinite }) else { continue }
            result[frame] = MarcoProjection(corners: points.map {
                CGPoint(x: ($0.x * 2).rounded() / 2, y: ($0.y * 2).rounded() / 2)
            })
        }
        return result
    }

    /// Hit-test de solo dos cuadriláteros, sin generar colisiones para toda la ofrenda.
    func frame(at point: CGPoint, in view: ARView, camera: PerspectiveCamera) -> MarcoOfrenda? {
        let projected = projections(in: view, camera: camera)
        return MarcoOfrenda.allCases.first { frame in
            guard let projection = projected[frame] else { return false }
            var path = Path()
            path.addLines(projection.corners)
            path.closeSubpath()
            return path.contains(point)
        }
    }


    func dispose() {
        tasks.values.forEach { $0.cancel() }
        tasks.removeAll()
        requested.removeAll()
        surfaces.values.forEach { $0.overlay.removeFromParent() }
        surfaces.removeAll()
        frames.removeAll()
        root = nil
    }

    private func firstModel(in entity: Entity) -> ModelEntity? {
        if let model = entity as? ModelEntity { return model }
        for child in entity.children {
            if let result = firstModel(in: child) { return result }
        }
        return nil
    }

    private enum FrameError: LocalizedError {
        case surfaceMissing(MarcoOfrenda)
        var errorDescription: String? {
            switch self {
            case .surfaceMissing(let frame):
                "No se encontró el espacio de fotografía del \(frame.titulo.lowercased())."
            }
        }
    }
}
