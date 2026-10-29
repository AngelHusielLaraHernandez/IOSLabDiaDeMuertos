//
//  CalaveritaGuardada.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation


struct CalaveritaGuardada: Identifiable, Codable, Equatable {
    var id = UUID()
    let idOfrenda: UUID
    let nombrePersona: String
    let texto: String
    var fechaCreacion = Date()

    var titulo: String?

    init(para ofrenda: PersonalizacionOfrenda, texto: String) {
        idOfrenda = ofrenda.id
        nombrePersona = ofrenda.nombre.trimmingCharacters(in: .whitespacesAndNewlines)
        self.texto = texto
    }

    var tituloVisible: String { titulo ?? "Para \(nombrePersona)" }


    var textoPlano: String {
        var opciones = AttributedString.MarkdownParsingOptions()
        opciones.interpretedSyntax = .inlineOnlyPreservingWhitespace
        guard let contenido = try? AttributedString(markdown: texto, options: opciones) else { return texto }
        return String(contenido.characters)
    }

    var textoParaCompartir: String { "\(tituloVisible)\n\n\(textoPlano)" }
}
