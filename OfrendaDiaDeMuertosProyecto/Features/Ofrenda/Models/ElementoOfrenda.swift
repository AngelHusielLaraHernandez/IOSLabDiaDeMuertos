//
//  ElementoOfrenda.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import simd

struct ElementoOfrenda: Identifiable {
    var id: String { nombre }

    var nombreVisible: String { nombre == "Calaveritas" ? "Calaveritas de azúcar" : nombre }
    let nombre: String
    let icono: IlustracionOfrenda
    let tituloHistoria: String
    let descripcionHistoria: String
    let significado: String

    let anclaNormalizada: SIMD3<Float>

    var entidadesAncla: [String] = []

    var zoomMaximoEtiqueta: Float = 2.5
 
    var esElementoDelAltar = true
}

