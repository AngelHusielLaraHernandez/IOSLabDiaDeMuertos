//
//  PersonalizacionOfrenda.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Victor Flores on 16/10/26.
//

import SwiftUI

struct PersonalizacionOfrenda: Identifiable, Codable {
    var id = UUID() //Es el identificador para cada ofrenda se usa UUID para el anexo automatico
    //var foto: UIImage? = nil a ver si no lo rompo
    var marcoRetrato: MarcoOfrenda = .izquierdo
    var nombre: String = ""
    var comidaFavorita: String = ""
    var musicaFavorita: String = "" // Único campo para música/canción favorita (Opcional)
    var aficiones: Set<String> = []
    var recuerdoCompartido: String = ""
    
    /*
    var estaCompleta: Bool {
        foto != nil && !nombre.trimmingCharacters(in: .whitespaces).isEmpty
    }
     */
    
    //Lo cambie porque ahora depende de los marcos usando esta id
    
    var estaCompleta: Bool {
            !nombre.isEmpty && !comidaFavorita.isEmpty
        }
    
}

struct Aficion: Identifiable, Hashable {
    let nombre: String
    let descripcion: String
    let icono: IlustracionOfrenda
    var id: String { nombre }

    // Se retira "Música" para evitar duplicar el apartado
    static let todas: [Aficion] = [
        Aficion(nombre: "Jardinería", descripcion: "Flores y recuerdos de su jardín", icono: .flores),
        Aficion(nombre: "Cocina",     descripcion: "Recetas que preparaba en casa", icono: .comida),
        Aficion(nombre: "Lectura",    descripcion: "Libros que atesoraba", icono: .libro),
        Aficion(nombre: "Costura",    descripcion: "Telas y puntadas que hacía", icono: .costura),
        Aficion(nombre: "Café",       descripcion: "Las tardes con una taza", icono: .cafe)
    ]
}

enum PasoPersonalizacion {
    case retrato       // pantallas 1 y 4
    case ajusteFoto    // pantalla 3
    case gustos        // pantallas 5 y 6
    case sugerencias   // pantalla 7
    case elementos     // selección real de los objetos del modelo
    case resultado     // pantalla 8
}
