//
//  OfrendaAssets.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import RealityKit
import OSLog

/// Las copias comparten mallas y texturas; cada visor conserva sus transformaciones.
@MainActor
final class OfrendaAssets {
    static let shared = OfrendaAssets()
    private let models = NSCache<NSString, Entity>()
    private var loading: [String: Task<Entity, Error>] = [:]
    private let logger = Logger(subsystem: "Tenshi.OfrendaDiaDeMuertosProyecto", category: "Modelo3D")

    private init() { models.countLimit = 2 }

    /// Calienta la misma caché que consumirá el altar, sin crear una ARView ni otro clon completo.
    func preload(named name: String) async throws {
        _ = try await source(named: name)
    }

    func clone(named name: String) async throws -> Entity {
        try await source(named: name).clone(recursive: true)
    }

    /// Comparte los recursos del prototipo y copia solamente las entidades elegidas.
    func cloneElement(nombres: [String], from existing: Entity? = nil) async throws -> Entity {
        guard !nombres.isEmpty else { throw AssetError.emptySelection }
        let modelo: Entity
        if let existing { modelo = existing }
        else { modelo = try await source(named: "Ofrenda") }
        try Task.checkCancellation()
        let detalle = Entity()
        detalle.name = "ObjetoAislado"
        for nombre in nombres {
            guard let original = modelo.findEntity(named: nombre) else { throw AssetError.notFound(nombre) }
            let copia = original.clone(recursive: true)
            copia.transform = Transform(matrix: original.transformMatrix(relativeTo: modelo))
            // Historias también muestra piezas ocultas en el altar; solo se activa la copia.
            copia.isEnabled = true
            // El retrato se vuelve a conectar al store, sin duplicar su panel de fotografía.
            removePhotoOverlays(from: copia)
            detalle.addChild(copia)
        }
        return detalle
    }

    private func removePhotoOverlays(from entity: Entity) {
        for child in Array(entity.children) {
            if child.name.hasPrefix("FotoUsuario_") { child.removeFromParent() }
            else { removePhotoOverlays(from: child) }
        }
    }

    private func source(named name: String) async throws -> Entity {
        if let model = models.object(forKey: name as NSString) { return model }
        let task: Task<Entity, Error>
        if let pending = loading[name] {
            task = pending
        } else {
            guard let url = Bundle.main.url(forResource: name, withExtension: "usdz") else {
                throw AssetError.notFound(name)
            }
            logger.info("Cargando recurso \(name, privacy: .public)")
            task = Task { try await Entity(contentsOf: url) }
            loading[name] = task
        }
        do {
            let model = try await task.value
            loading[name] = nil
            models.setObject(model, forKey: name as NSString)
            try Task.checkCancellation()
            return model
        } catch {
            loading[name] = nil
            throw error
        }
    }

    func clearCachedModels() { models.removeAllObjects() }

    private enum AssetError: LocalizedError {
        case notFound(String)
        case emptySelection
        var errorDescription: String? {
            switch self {
            case .notFound(let name): return "No se encontró el recurso \(name)."
            case .emptySelection: return "Este elemento todavía no tiene una pieza 3D asignada."
            }
        }
    }
}
