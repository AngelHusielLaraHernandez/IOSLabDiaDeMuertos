//
//  CalaveritaGenerator.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation

/// Plantilla local existente, sin servicios externos.
enum CalaveritaGenerator {
    static func generar(para personalizacion: PersonalizacionOfrenda) -> String {
        let nombre = personalizacion.nombre.isEmpty ? "el alma querida" : personalizacion.nombre
        let comida = personalizacion.comidaFavorita.isEmpty ? "pan de muerto" : personalizacion.comidaFavorita.lowercased()
        let aficion = personalizacion.aficiones.sorted().first?.lowercased() ?? "recordar"
        let recuerdo = personalizacion.recuerdoCompartido.isEmpty
            ? "las tardes en silencio" : personalizacion.recuerdoCompartido.lowercased()

        return """
        La Catrina llegó a casa
        con \(comida) entre las manos,
        y le dijo a \(nombre) al oído:
        «ya te esperan tus hermanos».

        Entre \(aficion) y velas,
        entre flores y cantar,
        se colaron los recuerdos
        de \(recuerdo), sin parar.

        Hoy la ofrenda se ilumina
        con tu risa y tu mirar,
        y en cada pétalo de cempasúchil
        te volvemos a abrazar.
        """
    }
}
