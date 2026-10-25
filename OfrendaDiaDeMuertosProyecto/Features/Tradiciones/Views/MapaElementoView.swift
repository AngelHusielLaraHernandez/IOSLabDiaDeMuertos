//
//  MapaElementoView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

/// La referencia geográfica se monta únicamente al elegir Mapa, separada de la cronología.
struct MapaElementoView: View {
    let nombreElemento: String

    var body: some View {
        if let vinculo = TradicionesCatalog.vinculo(para: nombreElemento) {
            TarjetaLugarView(lugar: vinculo.lugar, contexto: vinculo.contexto)
            Text(vinculo.lugar.avisoVisita)
                .font(.footnote).foregroundStyle(AppTheme.secondaryText)
        } else {
            ContentUnavailableView("Sin ubicación asociada", systemImage: "map",
                                   description: Text("Puedes consultar la historia y sus referencias en Conocer más."))
        }
    }
}
