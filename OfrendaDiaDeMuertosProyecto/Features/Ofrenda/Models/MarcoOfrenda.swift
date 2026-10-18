//
//  MarcoOfrenda.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 17/10/26.
//

import SwiftUI

/// Identidades de los dos retratos que ya contiene Ofrenda.usdz.
enum MarcoOfrenda: String, CaseIterable, Identifiable, Codable, Sendable {
    case izquierdo = "retrato__001"
    case derecho = "retrato__002"

    nonisolated var id: String { rawValue }
    nonisolated var titulo: String { self == .izquierdo ? "Marco izquierdo" : "Marco derecho" }

    /// Proporción del hueco interior, medida sobre la malla exportada, no del borde.
    nonisolated var relacionAspecto: CGFloat { 15.0 / 17.0 }
}

struct FotoMarco: Identifiable {
    let id = UUID()
    let imagen: UIImage
    var esPredeterminada = false
}

/// La hoja recibe una selección concreta en su primera presentación.
struct EditorMarcos: Identifiable {
    let id = UUID()
    let marco: MarcoOfrenda?
}

/// Elegir un marco no borra la fotografía del otro.
enum CantidadMarcos: String, CaseIterable, Codable, Sendable {
    case uno, dos
    var titulo: String { self == .uno ? "Un marco" : "Dos marcos" }
}

struct ConfiguracionMarcos: Codable, Equatable, Sendable {
    var cantidad: CantidadMarcos = .dos
    var principal: MarcoOfrenda = .izquierdo
    var visibles: [MarcoOfrenda] { cantidad == .uno ? [principal] : MarcoOfrenda.allCases }
}
