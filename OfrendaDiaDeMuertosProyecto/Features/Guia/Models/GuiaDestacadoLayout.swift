//
//  GuiaDestacadoLayout.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import CoreGraphics


enum GuiaDestacadoLayout {
    struct Colocacion {
        let recorte: CGRect
        let tarjetaAbajo: Bool
        let alturaTarjeta: CGFloat
    }
    static func colocar(objetivo: CGRect, pantalla: CGSize) -> Colocacion {
        let visible = CGRect(origin: .zero, size: pantalla).insetBy(dx: 8, dy: 8)
        let recorte = objetivo.insetBy(dx: -6, dy: -6).intersection(visible)
        let valido = !recorte.isNull && !recorte.isEmpty && recorte.minX.isFinite && recorte.minY.isFinite
        let marco = valido ? recorte : CGRect(x: pantalla.width * 0.2, y: pantalla.height * 0.4, width: pantalla.width * 0.6, height: 80)
        let arriba = max(0, marco.minY - 24)
        let abajo = max(0, pantalla.height - marco.maxY - 24)
        let alturaMinima = min(280, max(120, pantalla.height * 0.48))
        let altura = min(max(120, pantalla.height - 32), max(alturaMinima, max(arriba, abajo)))
        return Colocacion(recorte: marco, tarjetaAbajo: abajo > arriba, alturaTarjeta: altura)
    }
}
