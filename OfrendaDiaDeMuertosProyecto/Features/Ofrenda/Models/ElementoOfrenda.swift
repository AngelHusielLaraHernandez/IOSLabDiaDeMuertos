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
    let nombre: String
    let icono: String
    let tituloHistoria: String
    let descripcionHistoria: String
    let significado: String
    /// Coordenadas normalizadas respecto a la caja delimitadora (Bounding Box) del altar 3D
    let anclaNormalizada: SIMD3<Float>
    /// Mallas reales que representan el elemento; el punto normalizado sirve de respaldo.
    var entidadesAncla: [String] = []
    /// Los detalles pequeños se descubren al acercar la cámara (un factor menor acerca).
    var zoomMaximoEtiqueta: Float = 2.5
}

