//
//  ProgresoRecorridoStore.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import Combine

enum ElementoVisitadoID: String, CaseIterable {
    case flores, retrato, velas, papel, aguaSal, calaveritas, pan, comida, cana, frutas, incienso, cigarro, tequila

    var nombre: String {
        switch self {
        case .flores: "Flores"; case .retrato: "Retrato"; case .velas: "Velas"; case .papel: "Papel"
        case .aguaSal: "Agua y sal"; case .calaveritas: "Calaveritas"; case .pan: "Pan"; case .comida: "Comida"
        case .cana: "Caña de azúcar"; case .frutas: "Frutas"; case .incienso: "Incienso"; case .cigarro: "Cigarro"; case .tequila: "Tequila"
        }
    }

    init?(nombre: String) {
        let canonico: String
        switch nombre {
        case "Cempasúchil": canonico = "Flores"
        case "Papel picado": canonico = "Papel"
        case "Pan de muerto": canonico = "Pan"
        case "Vaso de tequila": canonico = "Tequila"
        default: canonico = nombre
        }
        guard let valor = Self.allCases.first(where: { $0.nombre == canonico }) else { return nil }
        self = valor
    }
}

@MainActor
final class ProgresoRecorridoStore: ObservableObject {
    @Published private(set) var visitados: Set<ElementoVisitadoID>
    private let defaults: UserDefaults
    private let clave = "ofrenda.recorrido.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let ids = defaults.stringArray(forKey: clave) ?? []
        visitados = Set(ids.compactMap(ElementoVisitadoID.init(rawValue:)))
    }

    var cantidad: Int { visitados.count }
    var total: Int { ElementoVisitadoID.allCases.count }
    var nombresVisitados: Set<String> { Set(visitados.map(\.nombre)) }
    var completo: Bool { cantidad == total }

    func visitar(nombre: String) {
        guard let id = ElementoVisitadoID(nombre: nombre), !visitados.contains(id) else { return }
        visitados.insert(id)
        defaults.set(visitados.map(\.rawValue).sorted(), forKey: clave)
    }

    func registrar(nombres: Set<String>) {
        for nombre in nombres { visitar(nombre: nombre) }
    }

    func desbloqueada(_ celebracion: CelebracionCultural) -> Bool { cantidad >= celebracion.historiasRequeridas }
}
