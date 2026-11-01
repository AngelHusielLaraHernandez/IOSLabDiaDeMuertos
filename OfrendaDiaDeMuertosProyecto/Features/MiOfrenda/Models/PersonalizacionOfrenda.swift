//
//  PersonalizacionOfrenda.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Victor Flores on 16/10/26.
//

import SwiftUI

struct PersonalizacionOfrenda: Identifiable, Codable, Equatable {
    var id = UUID()
    var marcoRetrato: MarcoOfrenda = .izquierdo
    var nombre: String = ""
    var retratos: ConfiguracionMarcos? = nil
    var comidaFavorita: String = ""
    var musicaFavorita: String = ""
    var aficiones: Set<String> = []
    var recuerdoCompartido: String = ""
    

    var estaCompleta: Bool {
        !nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !comidaFavorita.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && (retratos == nil || retratos?.errorIdentidad == nil)
    }
    

    var nombresResumen: String { retratos?.nombresCortos.isEmpty == false ? retratos!.nombresCortos : IdentidadRetrato.primerNombre(de: nombre) }
    var musicaResumen: String {
        guard let retratos else { return musicaFavorita }
        return retratos.visibles.map { marco in
            let persona = retratos.persona(en: marco)
            return persona.musica.isEmpty ? "" : "\(persona.primerNombre): \(persona.musica)"
        }.filter { !$0.isEmpty }.joined(separator: " · ")
    }
    func configuracionInicial(desde guardada: ConfiguracionMarcos) -> ConfiguracionMarcos {
        var configuracion = retratos ?? guardada
        if configuracion.personas.isEmpty, !nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            configuracion.asignar(IdentidadRetrato(nombre: nombre, musica: musicaFavorita), en: marcoRetrato)
        }
        return configuracion
    }
    mutating func aplicarRetratos(_ configuracion: ConfiguracionMarcos) {
        retratos = configuracion
        let principal = configuracion.persona(en: configuracion.cantidad == .uno ? configuracion.principal : .izquierdo)
        nombre = principal.nombre
        musicaFavorita = principal.musica
    }
    func paraCalaverita(marco: MarcoOfrenda?) -> PersonalizacionOfrenda {
        var resultado = self
        if let retratos {
            let elegido = marco.flatMap { retratos.visibles.contains($0) ? $0 : nil } ?? retratos.visibles[0]
            let persona = retratos.persona(en: elegido)
            resultado.nombre = persona.primerNombre
            resultado.musicaFavorita = persona.musica
        } else { resultado.nombre = IdentidadRetrato.primerNombre(de: nombre) }
        resultado.retratos = nil
        return resultado
    }
}

struct Aficion: Identifiable, Hashable {
    let nombre: String
    let descripcion: String
    let icono: IlustracionOfrenda
    var id: String { nombre }


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
    case retrato       
    case ajusteFoto
    case gustos
    case sugerencias
    case elementos
    case resultado
}
