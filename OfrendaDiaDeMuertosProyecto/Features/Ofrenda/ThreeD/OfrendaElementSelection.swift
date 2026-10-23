//
//  OfrendaElementSelection.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation

/// Piezas que forman un ejemplar completo, sin duplicar el resto del altar.
enum OfrendaElementSelection {
    static func nombres(para elemento: String, marco: MarcoOfrenda) -> [String] {
        switch elemento {
        case "Flores", "Cempasúchil": ["flores__001", "flores__003"]
        case "Retrato": [marco.rawValue]
        case "Velas": ["velas__001"] // Su llama es hija del mismo objeto.
        case "Papel", "Papel picado": ["papel__001"]
        case "Agua y sal": ["bebidas__002", "bebidas__003"]
        case "Calaveritas": ["calaveras__001"]
        case "Pan", "Pan de muerto": ["pan__001"]
        case "Comida": ["comida__001"]
        case "Caña de azúcar": ["comida__012"]
        case "Frutas": ["comida__003"]
        case "Incienso": ["copal__001", "copal__002"]
        case "Cigarro": ["recuerdos__001"]
        case "Tequila": ["bebidas__006"]
        default: []
        }
    }
}
