//
//  OfrendaCaptureFraming.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import simd

/// Encuadra las ocho esquinas del altar con margen, incluso en un visor horizontal.
enum OfrendaCaptureFraming {
    static let orientation = simd_quatf(angle: -0.08, axis: [0, 1, 0]) * simd_quatf(angle: 0.10, axis: [1, 0, 0])

    static func distance(extents: SIMD3<Float>, aspect: Float) -> Float {
        let vertical = tan(Float(47) * .pi / 360)
        let horizontal = vertical * max(aspect, 0.2)
        var distance: Float = 0
        for x: Float in [-0.5, 0.5] {
            for y: Float in [-0.5, 0.5] {
                for z: Float in [-0.5, 0.5] {
                    let point = orientation.act(extents * SIMD3(x, y, z))
                    distance = max(distance, point.z + max(abs(point.x) / horizontal, abs(point.y) / vertical))
                }
            }
        }
        return max(0.1, distance * 1.12)
    }
}
