//
//  Objeto3DInspectionState.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import simd


struct Objeto3DInspectionState {
    var yaw: Float = 0
    var pitch: Float = 0.25
    var zoom: Float = 1
    var tiempo: Float = 0

    mutating func avanzar(segundos: Float, giroAutomatico: Bool, reducirMovimiento: Bool) {
        guard !reducirMovimiento else { return }
        let paso = min(0.05, max(0, segundos))
        tiempo += paso
        if giroAutomatico { yaw = (yaw + paso * 0.24).truncatingRemainder(dividingBy: 2 * .pi) }
    }

    mutating func girar(x: Float, y: Float) {
        yaw = (yaw + x * 0.009).truncatingRemainder(dividingBy: 2 * .pi)
        pitch = min(1.2, max(-1.2, pitch + y * 0.008))
    }

    mutating func acercar(escala: Float) {
        guard escala.isFinite, escala > 0 else { return }
        zoom = min(1.8, max(0.65, zoom / escala))
    }

    func elevacion(reducirMovimiento: Bool) -> Float {
        guard !reducirMovimiento else { return 0 }
        let entrada = max(0, 1 - tiempo / 0.5)
        return -0.22 * entrada * entrada + sin(tiempo * 1.5) * 0.035
    }

    var orientacion: simd_quatf {
        simd_quatf(angle: yaw, axis: [0, 1, 0]) * simd_quatf(angle: pitch, axis: [1, 0, 0])
    }

 
    static func distancia(radio: Float, aspecto: Float) -> Float {
        let mitadVertical: Float = 34 * .pi / 360
        let mitadHorizontal = atan(tan(mitadVertical) * max(0.1, aspecto))
        return max(0.1, radio) / sin(min(mitadVertical, mitadHorizontal)) * 1.15
    }
}
