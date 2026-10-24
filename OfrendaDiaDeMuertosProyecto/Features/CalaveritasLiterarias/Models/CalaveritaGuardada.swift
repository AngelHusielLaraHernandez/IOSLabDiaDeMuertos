//
//  CalaveritaGuardada.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation

/// Una versión del poema, independiente de ediciones posteriores del altar.
struct CalaveritaGuardada: Identifiable, Codable, Equatable {
    var id = UUID()
    let idOfrenda: UUID
    let nombrePersona: String
    let texto: String
    var fechaCreacion = Date()
    // Opcional para leer las colecciones anteriores sin perder sus poemas.
    var titulo: String?

    init(para ofrenda: PersonalizacionOfrenda, texto: String) {
        idOfrenda = ofrenda.id
        nombrePersona = ofrenda.nombre.trimmingCharacters(in: .whitespacesAndNewlines)
        self.texto = texto
    }

    var tituloVisible: String { titulo ?? "Para \(nombrePersona)" }

    /// Comparte texto legible, sin los marcadores de énfasis usados en la app.
    var textoPlano: String {
        var opciones = AttributedString.MarkdownParsingOptions()
        opciones.interpretedSyntax = .inlineOnlyPreservingWhitespace
        guard let contenido = try? AttributedString(markdown: texto, options: opciones) else { return texto }
        return String(contenido.characters)
    }

    var textoParaCompartir: String { "\(tituloVisible)\n\n\(textoPlano)" }
}
