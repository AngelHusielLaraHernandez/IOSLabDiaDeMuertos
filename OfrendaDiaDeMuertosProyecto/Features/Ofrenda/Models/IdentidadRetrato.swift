//
//  IdentidadRetrato.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation

struct IdentidadRetrato: Codable, Equatable, Sendable {
    var nombre = ""
    var musica = ""
    var primerNombre: String { Self.primerNombre(de: nombre) }
    nonisolated static func primerNombre(de nombre: String) -> String {
        String(nombre.split(whereSeparator: \.isWhitespace).first ?? "")
    }
    nonisolated static func normalizar(_ texto: String) -> String {
        texto.split(whereSeparator: \.isWhitespace).joined(separator: " ")
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: Locale(identifier: "es_MX"))
    }
    nonisolated static func permiteReemplazar(nombreAnterior: String, nombreNuevo: String, esPredeterminada: Bool) -> Bool {
        !normalizar(nombreNuevo).isEmpty && (esPredeterminada || normalizar(nombreAnterior).isEmpty || normalizar(nombreAnterior) != normalizar(nombreNuevo))
    }
}
