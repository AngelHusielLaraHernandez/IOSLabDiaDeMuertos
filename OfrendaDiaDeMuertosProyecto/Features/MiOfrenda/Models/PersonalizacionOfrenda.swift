//
//  PersonalizacionModels.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Victor Flores on 16/10/26.
//

import SwiftUI

struct PersonalizacionOfrenda {
    var foto: UIImage? = nil
    var marcoRetrato: MarcoOfrenda = .izquierdo
    var nombre: String = ""
    var comidaFavorita: String = ""
    var aficiones: Set<String> = []
    var recuerdoCompartido: String = ""

    var estaCompleta: Bool {
        foto != nil && !nombre.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

struct Aficion: Identifiable, Hashable {
    let nombre: String
    let descripcion: String
    let icono: String
    var id: String { nombre }

    static let todas: [Aficion] = [
        Aficion(nombre: "Jardinería", descripcion: "Flores y recuerdos de su jardín", icono: "🌻"),
        Aficion(nombre: "Música",     descripcion: "Canciones que le gustaba escuchar", icono: "🎵"),
        Aficion(nombre: "Cocina",     descripcion: "Recetas que preparaba en casa", icono: "🍳"),
        Aficion(nombre: "Lectura",    descripcion: "Libros que atesoraba", icono: "📖"),
        Aficion(nombre: "Costura",    descripcion: "Telas y puntadas que hacía", icono: "🧵"),
        Aficion(nombre: "Café",       descripcion: "Las tardes con una taza", icono: "☕")
    ]
}

enum PasoPersonalizacion {
    case retrato       // pantallas 1 y 4
    case ajusteFoto    // pantalla 3
    case gustos        // pantallas 5 y 6
    case sugerencias   // pantalla 7
    case resultado     // pantalla 8
}
