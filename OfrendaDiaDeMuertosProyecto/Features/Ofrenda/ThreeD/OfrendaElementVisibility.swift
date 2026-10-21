//
//  OfrendaElementVisibility.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import RealityKit

/// Indexa una vez las piezas; cambiar un selector solo activa o desactiva esas entidades.
@MainActor
final class OfrendaElementVisibility {
    private var grupos: [GrupoElementoOfrenda: [(entity: Entity, enabled: Bool)]] = [:]
    func attach(to root: Entity) {
        grupos = Dictionary(uniqueKeysWithValues: GrupoElementoOfrenda.allCases.map { grupo in
            (grupo, grupo.entidades.compactMap { nombre in
                root.findEntity(named: nombre).map { (entity: $0, enabled: $0.isEnabled) }
            })
        })
    }
    func apply(_ configuracion: ConfiguracionElementosOfrenda) {
        for (grupo, piezas) in grupos {
            let visible = configuracion.muestra(grupo)
            for pieza in piezas { pieza.entity.isEnabled = visible && pieza.enabled }
        }
    }
    func dispose() { grupos.removeAll() }
}
