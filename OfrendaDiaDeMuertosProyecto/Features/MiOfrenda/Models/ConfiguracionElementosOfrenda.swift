//
//  ConfiguracionElementosOfrenda.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation

/// Identidades estables; los textos visibles pueden cambiar sin perder la selección guardada.
enum GrupoElementoOfrenda: String, CaseIterable, Identifiable, Sendable {
    case flores, retrato, velas, papel, agua, calaveritas, pan, comida, cana, frutas, incienso, cigarro, tequila
    var id: String { rawValue }
    var nombre: String {
        switch self {
        case .flores: "Flores"
        case .retrato: "Retrato"
        case .velas: "Velas"
        case .papel: "Papel picado"
        case .agua: "Agua y vasos"
        case .calaveritas: "Calaveritas"
        case .pan: "Pan de muerto"
        case .comida: "Comida"
        case .cana: "Caña de azúcar"
        case .frutas: "Frutas"
        case .incienso: "Incienso y copal"
        case .cigarro: "Cigarro"
        case .tequila: "Tequila"
        }
    }
    var icono: IlustracionOfrenda {
        switch self {
        case .flores: .flores
        case .retrato: .retrato
        case .velas: .velas
        case .papel: .papel
        case .agua: .agua
        case .calaveritas: .calaveritas
        case .pan: .pan
        case .comida: .comida
        case .cana: .cana
        case .frutas: .frutas
        case .incienso: .incienso
        case .cigarro: .cigarro
        case .tequila: .tequila
        }
    }
    var detalle: String {
        switch self {
        case .flores: "Ramos de cempasúchil y sus macetas."
        case .retrato: "Los marcos elegidos y sus fotografías."
        case .velas: "Todas las veladoras y sus llamas."
        case .papel: "Las guirnaldas y el papel de los niveles."
        case .agua: "Los vasos, su contenido y la jarra disponibles."
        case .calaveritas: "Las calaveritas de la mesa."
        case .pan: "Los panes y su plato central."
        case .comida: "Mole, tamales, tazones y el plato del tamal."
        case .cana: "Las dos porciones de caña."
        case .frutas: "Naranjas y tejocotes con sus hojas."
        case .incienso: "Las copaleras completas, con sus soportes."
        case .cigarro: "Los dos recuerdos de cigarro."
        case .tequila: "El vaso de tequila."
        }
    }
    /// Nombres contrastados con el USDZ y el informe de exportación de Blender.
    var entidades: [String] {
        func serie(_ prefix: String, _ range: ClosedRange<Int>) -> [String] {
            range.map { String(format: "%@__%03d", prefix, $0) }
        }
        switch self {
        case .flores: return serie("flores", 1...30)
        case .retrato: return serie("retrato", 1...2)
        case .velas: return serie("velas", 1...12)
        case .papel: return serie("papel", 1...30)
        case .agua: return serie("bebidas", 1...5)
        case .calaveritas: return serie("calaveras", 1...4)
        case .pan: return serie("pan", 1...5) + ["plato__001"]
        case .comida: return [1,2,7,8,9,16,17,18].map { String(format: "comida__%03d", $0) } + ["plato__002"]
        case .cana: return ["comida__012", "comida__013"]
        case .frutas: return [3,4,5,6,10,11,14,15].map { String(format: "comida__%03d", $0) }
        case .incienso: return serie("copal", 1...4)
        case .cigarro: return serie("recuerdos", 1...2)
        case .tequila: return ["bebidas__006"]
        }
    }
    static func para(elemento: String) -> Self? {
        switch elemento {
        case "Flores", "Cempasúchil": .flores
        case "Retrato": .retrato
        case "Velas": .velas
        case "Papel", "Papel picado": .papel
        case "Agua y sal": .agua
        case "Calaveritas": .calaveritas
        case "Pan", "Pan de muerto": .pan
        case "Comida": .comida
        case "Caña de azúcar": .cana
        case "Frutas": .frutas
        case "Incienso": .incienso
        case "Cigarro": .cigarro
        case "Tequila": .tequila
        default: nil
        }
    }
}

/// Por defecto conserva todo el altar. Los identificadores desconocidos no rompen la lectura.
struct ConfiguracionElementosOfrenda: Codable, Equatable, Sendable {
    private var ocultos: Set<String> = []
    var visibles: [GrupoElementoOfrenda] { GrupoElementoOfrenda.allCases.filter(muestra) }
    func muestra(_ grupo: GrupoElementoOfrenda) -> Bool { !ocultos.contains(grupo.rawValue) }
    func muestra(elemento: String) -> Bool { GrupoElementoOfrenda.para(elemento: elemento).map(muestra) ?? true }
    mutating func establecer(_ grupo: GrupoElementoOfrenda, visible: Bool) {
        if visible { ocultos.remove(grupo.rawValue) } else { ocultos.insert(grupo.rawValue) }
    }
}
