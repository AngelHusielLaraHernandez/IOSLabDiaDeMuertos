//
//  TarjetaDetalleElementoView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct TarjetaDetalleElementoView: View {
    let elemento: ElementoOfrenda
    let renderSession: OfrendaRenderSession
    let fotosMarcos: FotosMarcosStore
    var textoBotonCerrar = "Volver a la ofrenda"
    @StateObject private var exploracion = ExploracionGeografica()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Elemento3DView(elemento: elemento, fotosMarcos: fotosMarcos, renderSession: renderSession, isActive: exploracion.lugar == nil)
                    .frame(height: min(220, max(140, geometry.size.height * 0.29)))
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                contenido
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .ilustracionesOfrenda(activa: exploracion.lugar == nil)
        .environmentObject(exploracion)
        .fullScreenCover(item: $exploracion.lugar) { lugar in ExploradorLugarView(lugar: lugar) }
    }

    @ViewBuilder private var contenido: some View {
        switch elemento.nombre {
        case "Flores", "Cempasúchil": FloresView(textoBotonCerrar: textoBotonCerrar)
        case "Velas": VelasView(textoBotonCerrar: textoBotonCerrar)
        case "Agua y sal": AguaYSalView(textoBotonCerrar: textoBotonCerrar)
        case "Pan", "Pan de muerto": PanDeMuertoView(textoBotonCerrar: textoBotonCerrar)
        case "Comida": ComidaView(textoBotonCerrar: textoBotonCerrar)
        case "Retrato": RetratoView(textoBotonCerrar: textoBotonCerrar)
        case "Papel", "Papel picado": PapelView(textoBotonCerrar: textoBotonCerrar)
        case "Calaveritas": CalaveritasView(textoBotonCerrar: textoBotonCerrar)
        case "Caña de azúcar": CanaDeAzucarView(textoBotonCerrar: textoBotonCerrar)
        case "Frutas": FrutasView(textoBotonCerrar: textoBotonCerrar)
        case "Incienso": InciensoView(textoBotonCerrar: textoBotonCerrar)
        case "Cigarro": CigarroView(textoBotonCerrar: textoBotonCerrar)
        case "Tequila": TequilaView(textoBotonCerrar: textoBotonCerrar)
        default: FloresView(textoBotonCerrar: textoBotonCerrar)
        }
    }
}
