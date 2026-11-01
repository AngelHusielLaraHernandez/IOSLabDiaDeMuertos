//
//  FotografiaCultural.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation

struct FotografiaCultural: Decodable, Identifiable {
    let id: String
    let archivo: String
    let pie: String
    let descripcion: String
    let credito: String
    let fuente: URL
    let licencia: String
    let urlLicencia: URL?
}

enum FotografiasCulturales {

    static let todas: [FotografiaCultural] = {
        guard let url = Bundle.main.url(forResource: "fotografias-creditos", withExtension: "json"),
              let datos = try? Data(contentsOf: url),
              let fotos = try? JSONDecoder().decode([FotografiaCultural].self, from: datos) else { return [] }
        return fotos
    }()
    static func foto(para lugar: LugarCultural) -> FotografiaCultural? { todas.first { $0.id == lugar.id } }
}
