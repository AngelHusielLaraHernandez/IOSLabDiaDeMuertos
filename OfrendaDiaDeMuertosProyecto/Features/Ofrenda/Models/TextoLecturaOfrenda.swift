//
//  TextoLecturaOfrenda.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation


enum TextoLecturaOfrenda {
    static let introduccionFuentes = "Se diferencian antecedentes, contextos históricos, registros documentados y usos actuales. Las prácticas cambian entre regiones y familias."

    nonisolated static func limpiar(_ texto: String) -> String {
        let plano = (try? AttributedString(markdown: texto, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
            .map { String($0.characters) } ?? texto
        return plano.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    nonisolated static func unir(_ partes: [String]) -> String {
        partes.map(limpiar).filter { !$0.isEmpty }.joined(separator: "\n\n")
    }

    static func cronologia(_ titulo: String, hitos: [HitoHistorico]) -> String {
        unir([titulo] + hitos.flatMap { [$0.epoca, $0.titulo, $0.descripcion] })
    }

    static func fuentes(nombre: String, hitos: [HitoHistorico]) -> String {
        unir(["Fuentes de \(nombre)", introduccionFuentes] + hitos.flatMap(\.fuentes).flatMap {
            [$0.periodo, $0.titulo, $0.detalle, "Referencia: \($0.referencia)"]
        })
    }

    static func mapa(para elemento: String) -> String {
        guard let vinculo = TradicionesCatalog.vinculo(para: elemento) else {
            return "Sin ubicación asociada. Puedes consultar la historia y sus referencias en Conocer más."
        }
        let lugar = vinculo.lugar
        return unir(["Origen y tradición", vinculo.tipo.rawValue, vinculo.origen,
                     "Tradición en México", lugar.nombre, lugar.region, vinculo.contexto,
                     "Referencia: \(lugar.referencia). Las tradiciones también se viven en otras regiones.",
                     lugar.avisoVisita])
    }
}
