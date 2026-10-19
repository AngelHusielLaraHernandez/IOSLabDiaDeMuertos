//
//  AppTabsView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

private enum AppTab: Hashable {
    case ofrenda, historias, miOfrenda
}

struct AppTabsView: View {
    @State private var renderSession = OfrendaRenderSession()
    @State private var tab: AppTab = .ofrenda
    @State private var elementoSeleccionado: ElementoOfrenda?
    @State private var elementosVisitados: Set<String> = []
    @State private var personalizacion = PersonalizacionOfrenda()
    @State private var fotosMarcos = FotosMarcosStore.shared
    @Environment(\.scenePhase) private var scenePhase
    private let elementos = OfrendaCatalog.elementos

    var body: some View {
        TabView(selection: $tab) {
            Tab("Ofrenda", systemImage: "house", value: .ofrenda) {
                OfrendaView(
                    elementos: elementos,
                    renderSession: renderSession,
                    fotosMarcos: fotosMarcos,
                    isActive: tab == .ofrenda && scenePhase == .active,
                    elementosVisitados: $elementosVisitados,
                    elementoSeleccionado: $elementoSeleccionado,
                    onPersonalizar: { tab = .miOfrenda }
                )
            }
            Tab("Historias", systemImage: "text.book.closed", value: .historias) {
                HistoriasView(
                    elementos: elementos,
                    elementoSeleccionado: $elementoSeleccionado
                )
            }
            Tab("Mi ofrenda", systemImage: "heart", value: .miOfrenda) {
                OfrendaPersonalizadaFlowView(personalizacion: $personalizacion, fotosMarcos: fotosMarcos, isActive: tab == .miOfrenda && scenePhase == .active) {
                    tab = .ofrenda
                }
            }
        }
        .tint(AppTheme.accent)
        .preferredColorScheme(.dark)
        .sheet(item: $elementoSeleccionado) { elemento in
            TarjetaDetalleElementoView(
                elemento: elemento,
                renderSession: renderSession,
                fotosMarcos: fotosMarcos,
                textoBotonCerrar: "Volver a la ofrenda"
            )
            .ofrendaSheet(detents: [.fraction(0.82), .large])
        }
    }
}
