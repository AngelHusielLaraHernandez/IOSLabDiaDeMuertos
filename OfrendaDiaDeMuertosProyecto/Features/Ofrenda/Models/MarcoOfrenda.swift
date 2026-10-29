//
//  MarcoOfrenda.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 17/10/26.
//

import SwiftUI


enum MarcoOfrenda: String, CaseIterable, Identifiable, Codable, Sendable {
    case izquierdo = "retrato__001"
    case derecho = "retrato__002"

    nonisolated var id: String { rawValue }
    nonisolated var titulo: String { self == .izquierdo ? "Marco izquierdo" : "Marco derecho" }

    var numero: String { self == .izquierdo ? "Marco 1" : "Marco 2" }

   
    nonisolated var relacionAspecto: CGFloat { 15.0 / 17.0 }
}

struct FotoMarco: Identifiable {
    let id = UUID()
    let imagen: UIImage
    var esPredeterminada = false
}

struct EditorMarcos: Identifiable {
    let id = UUID()
    let marco: MarcoOfrenda?
}


enum CantidadMarcos: String, CaseIterable, Codable, Sendable {
    case uno, dos
    var titulo: String { self == .uno ? "Un marco" : "Dos marcos" }
}

struct ConfiguracionMarcos: Codable, Equatable, Sendable {
    var cantidad: CantidadMarcos = .dos
    var principal: MarcoOfrenda = .izquierdo
    var personas: [String: IdentidadRetrato] = [:]

    var archivosFotos: [String: String] = [:]
    func persona(en marco: MarcoOfrenda) -> IdentidadRetrato { personas[marco.rawValue] ?? IdentidadRetrato() }
    mutating func asignar(_ persona: IdentidadRetrato, en marco: MarcoOfrenda) { personas[marco.rawValue] = persona }
    var nombresCortos: String { visibles.map { persona(en: $0).primerNombre }.filter { !$0.isEmpty }.joined(separator: " y ") }

    func errorIdentidad(en marco: MarcoOfrenda) -> String? {
        let persona = persona(en: marco)
        if persona.primerNombre.isEmpty { return "Escribe el nombre del \(marco.numero.lowercased())." }
        if persona.nombre.count > 80 { return "El nombre debe tener como máximo 80 caracteres." }
        if persona.musica.count > 120 { return "La música debe tener como máximo 120 caracteres." }
        if cantidad == .dos {
            if IdentidadRetrato.normalizar(persona.musica).isEmpty { return "Añade una música o canción para esta persona." }
            let otra = self.persona(en: marco == .izquierdo ? .derecho : .izquierdo)
            if !otra.primerNombre.isEmpty && IdentidadRetrato.normalizar(persona.nombre) == IdentidadRetrato.normalizar(otra.nombre) {
                return "Escribe dos nombres diferentes, uno por marco."
            }
            if !IdentidadRetrato.normalizar(otra.musica).isEmpty && IdentidadRetrato.normalizar(persona.musica) == IdentidadRetrato.normalizar(otra.musica) {
                return "Elige una música diferente para cada persona."
            }
        }
        return nil
    }
    var errorIdentidad: String? {
        visibles.compactMap { errorIdentidad(en: $0) }.first
    }
    var visibles: [MarcoOfrenda] { cantidad == .uno ? [principal] : MarcoOfrenda.allCases }
}

extension ConfiguracionMarcos {
    private enum CodingKeys: String, CodingKey { case cantidad, principal, personas, archivosFotos }
    init(from decoder: Decoder) throws {
        let datos = try decoder.container(keyedBy: CodingKeys.self)
        cantidad = try datos.decodeIfPresent(CantidadMarcos.self, forKey: .cantidad) ?? .dos
        principal = try datos.decodeIfPresent(MarcoOfrenda.self, forKey: .principal) ?? .izquierdo
        personas = try datos.decodeIfPresent([String: IdentidadRetrato].self, forKey: .personas) ?? [:]
        archivosFotos = try datos.decodeIfPresent([String: String].self, forKey: .archivosFotos) ?? [:]
    }
}
