//
//  PersonalizacionOfrenda.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Victor Flores on 16/10/26.
//

import SwiftUI

struct PersonalizacionOfrenda: Identifiable, Codable, Equatable {
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
    
    /// Son los datos obligatorios del flujo; las fotos y los demás gustos son opcionales.
    var estaCompleta: Bool {
        !nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !comidaFavorita.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}

struct Aficion: Identifiable, Hashable {
    let nombre: String
    let descripcion: String
    let icono: IlustracionOfrenda
    var id: String { nombre }

    /// Grupos del modelo 3D que activa este pasatiempo.
    /// Retrato se maneja por separado (viene de la foto elegida).
    var grupos: [GrupoElementoOfrenda] {
        switch nombre {
        case "Jardinería":            return [.flores]
        case "Cocina":                return [.comida]
        case "Café":                  return [.agua]
        case "Fe y oración":          return [.velas, .incienso]
        case "Fiestas y papel picado":return [.papel, .calaveritas]
        case "Panadería":             return [.pan]
        case "Campo y cosecha":       return [.frutas, .cana]
        case "Brindis":               return [.tequila]
        case "Puros":                 return [.cigarro]
        default:                      return []
        }
    }

    static let todas: [Aficion] = [
        Aficion(nombre: "Jardinería",             descripcion: "Flores y recuerdos de su jardín",  icono: .flores),
        Aficion(nombre: "Cocina",                 descripcion: "Recetas que preparaba en casa",     icono: .comida),
        Aficion(nombre: "Lectura",                descripcion: "Libros que atesoraba",              icono: .libro),
        Aficion(nombre: "Costura",                descripcion: "Telas y puntadas que hacía",        icono: .costura),
        Aficion(nombre: "Café",                   descripcion: "Las tardes con una taza",           icono: .cafe),
        Aficion(nombre: "Fe y oración",           descripcion: "Velas y copal para la casa",        icono: .velas),
        Aficion(nombre: "Fiestas y papel picado", descripcion: "Calaveritas y colores",             icono: .papel),
        Aficion(nombre: "Panadería",              descripcion: "El pan de muerto familiar",         icono: .pan),
        Aficion(nombre: "Campo y cosecha",        descripcion: "Frutas frescas y caña",             icono: .frutas),
        Aficion(nombre: "Brindis",                descripcion: "Un trago para recordarle",          icono: .tequila),
        Aficion(nombre: "Puros",                  descripcion: "Los momentos de pausa",             icono: .cigarro)
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
