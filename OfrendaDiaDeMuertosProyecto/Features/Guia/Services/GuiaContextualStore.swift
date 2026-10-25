//
//  GuiaContextualStore.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import Combine

@MainActor
final class GuiaContextualStore: ObservableObject {
    let ambito: GuiaContextualAmbito
    private let defaults: UserDefaults
    @Published private(set) var indice: Int?
    var paso: PasoGuiaContextual? { indice.map { ambito.pasos[$0] } }
    var activa: Bool { indice != nil }

    init(ambito: GuiaContextualAmbito, defaults: UserDefaults = .standard) {
        self.ambito = ambito
        self.defaults = defaults
    }
    func presentarSiNecesaria() {
        if !defaults.bool(forKey: ambito.clave), indice == nil { indice = 0 }
    }
    func repetir() { indice = 0 }
    func anterior() { if let indice, indice > 0 { self.indice = indice - 1 } }
    func siguiente() {
        guard let indice else { return }
        if indice + 1 == ambito.pasos.count { terminar() }
        else { self.indice = indice + 1 }
    }
    func terminar() {
        defaults.set(true, forKey: ambito.clave)
        indice = nil
    }
    static func reiniciarAyudas(defaults: UserDefaults = .standard) {
        for ambito in GuiaContextualAmbito.allCases { defaults.removeObject(forKey: ambito.clave) }
    }
}
