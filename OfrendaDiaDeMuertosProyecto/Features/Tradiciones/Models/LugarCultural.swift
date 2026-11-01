//
//  LugarCultural.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import CoreLocation

struct FuenteCultural: Hashable {
    let titulo: String
    let url: URL
}


struct LugarCultural: Identifiable, Hashable {
    let id: String
    let nombre: String
    let region: String
    let referencia: String
    let latitud: Double
    let longitud: Double
    let descripcion: String
    let avisoVisita: String
    let fuentes: [FuenteCultural]

    var coordenada: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
    }
}


enum TipoVinculoCultural: String {
    case cultivo = "Región productora"
    case oficio = "Centro artesanal"
    case practica = "Tradición regional documentada"
    case bebida = "Historia regional de la bebida"
}

struct VinculoCultural {
    let lugar: LugarCultural
    let contexto: String
    let tipo: TipoVinculoCultural
    let origen: String
    let fuentesOrigen: [FuenteCultural]
}


struct CelebracionCultural: Identifiable {
    let id: String
    let nombre: String
    let simbolo: String
    let resumen: String
    let historia: String
    let datoDestacado: String
    let lugar: LugarCultural
    let referenciaTemporal: String
    let avisoEdicion: String
    let fuente: FuenteCultural
    let verificadoEl: String
    let historiasRequeridas: Int
}
