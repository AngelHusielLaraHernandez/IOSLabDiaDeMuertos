//
//  HistoriaElemento.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct HitoHistorico: Identifiable {
    let id = UUID()
    let epoca: String
    let titulo: String
    let descripcion: String
    let colorPunto: Color
    let fuentes: [FuenteDocumental]
}

struct FuenteDocumental: Identifiable {
    let id = UUID()
    let periodo: String
    let titulo: String
    let detalle: String
    let referencia: String
    var url: URL? = nil
}

