//
//  CapturaOfrendaRegression.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import simd

@main
struct CapturaOfrendaRegression {
    static func main() {
        var total = 0
        func comprobar(_ valor: @autoclosure () -> Bool, _ mensaje: String) {
            precondition(valor(), mensaje); total += 1
        }
        // La condición observable es que ninguna esquina salga de la foto al proyectarse.
        for aspect: Float in [0.2, 0.46, 0.75, 1, 1.6, 3] {
            for extents in [SIMD3<Float>(2.65, 2.1, 1.2), SIMD3<Float>(1, 3, 0.5), SIMD3<Float>(4, 1, 2)] {
                let distance = OfrendaCaptureFraming.distance(extents: extents, aspect: aspect)
                comprobar(distance.isFinite && distance > 0, "La cámara siempre queda delante del altar")
                let vertical = tan(Float(47) * .pi / 360)
                for x: Float in [-0.5, 0.5] {
                    for y: Float in [-0.5, 0.5] {
                        for z: Float in [-0.5, 0.5] {
                            let point = OfrendaCaptureFraming.orientation.act(extents * SIMD3(x, y, z))
                            let depth = distance - point.z
                            comprobar(depth > 0, "No hay geometría detrás de la cámara")
                            comprobar(abs(point.x / (depth * vertical * aspect)) < 1, "Ninguna esquina queda recortada a los lados")
                            comprobar(abs(point.y / (depth * vertical)) < 1, "Ninguna esquina queda recortada arriba o abajo")
                        }
                    }
                }
            }
        }
        comprobar(OfrendaCaptureFraming.distance(extents: .zero, aspect: 1) > 0, "Un límite vacío no produce una cámara inválida")
        print("CAPTURA_OK: \(total) comprobaciones")
    }
}
