//
//  CalendarioMuertos.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation


enum ConmemoracionMuertos: String, CaseIterable, Identifiable {
    case mascotas, infancia, adultos
    var id: String { rawValue }
    var nombre: String {
        switch self {
        case .mascotas: "Mascotas"
        case .infancia: "Niñas y niños"
        case .adultos: "Adultos"
        }
    }
    var simbolo: String {
        switch self {
        case .mascotas: "pawprint"
        case .infancia: "figure.child"
        case .adultos: "person.2"
        }
    }
    var mes: Int { self == .mascotas ? 10 : 11 }
    var dia: Int {
        switch self {
        case .mascotas: 27
        case .infancia: 1
        case .adultos: 2
        }
    }
    var fechaCorta: String { self == .mascotas ? "27 oct" : "\(dia) nov" }

    func cuenta(desde ahora: Date, zonaHoraria: TimeZone = .autoupdatingCurrent) -> CuentaConmemoracion {
        
        var calendario = Calendar(identifier: .gregorian)
        calendario.timeZone = zonaHoraria
        let hoy = calendario.startOfDay(for: ahora)
        let anoActual = calendario.component(.year, from: hoy)
        func fecha(_ ano: Int) -> Date {
            calendario.startOfDay(for: calendario.date(from: DateComponents(year: ano, month: mes, day: dia, hour: 12))!)
        }
        let esteAno = fecha(anoActual)
        let proxima = hoy <= esteAno ? esteAno : fecha(anoActual + 1)
        return CuentaConmemoracion(fecha: proxima,
                                  dias: calendario.dateComponents([.day], from: hoy, to: proxima).day ?? 0,
                                  ano: calendario.component(.year, from: proxima),
                                  esSiguienteAno: hoy > esteAno)
    }
}

struct CuentaConmemoracion: Equatable {
    let fecha: Date
    let dias: Int
    let ano: Int
    let esSiguienteAno: Bool
    var texto: String { dias == 0 ? "Hoy" : dias == 1 ? "1 día" : "\(dias) días" }
}
