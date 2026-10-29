//
//  OfrendaMaterials.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import UIKit
import RealityKit

@MainActor
enum OfrendaMaterials {
    static func prepare(_ entity: Entity, ocultarPared: Bool = true, path: String = "") {
        let fullPath = path + "/" + entity.name

        
        if ocultarPared && entity.name.hasPrefix("fondo__") {
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
        for child in entity.children { prepare(child, ocultarPared: ocultarPared, path: fullPath) }
    }

}
