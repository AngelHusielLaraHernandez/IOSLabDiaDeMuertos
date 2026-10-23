//
//  CalaveritaGuardada.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation

/// Conserva una versión del poema y de su destinatario, independiente de ediciones del altar.
struct CalaveritaGuardada: Identifiable, Codable, Equatable {
    var id = UUID()
    let idOfrenda: UUID
    let nombrePersona: String
    let texto: String
    var fechaCreacion = Date()

    init(para ofrenda: PersonalizacionOfrenda, texto: String) {
        idOfrenda = ofrenda.id
        nombrePersona = ofrenda.nombre.trimmingCharacters(in: .whitespacesAndNewlines)
        self.texto = texto
    }
}
