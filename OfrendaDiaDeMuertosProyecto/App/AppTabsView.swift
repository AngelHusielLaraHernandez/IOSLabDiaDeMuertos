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
    @State private var elementosStore = ElementosOfrendaStore.shared
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
                    seleccionElementos: elementosStore.configuracion,
                    nombrePersona: personalizacion.nombre,
                    isActive: tab == .ofrenda && scenePhase == .active,
                    elementosVisitados: $elementosVisitados,
                    elementoSeleccionado: $elementoSeleccionado,
                    onPersonalizar: { tab = .miOfrenda }
                )
            }
            Tab("Historias", systemImage: "text.book.closed", value: .historias) {
                AppTheme.background.ignoresSafeArea()
            }
            Tab("Mi ofrenda", systemImage: "heart", value: .miOfrenda) {
                OfrendaPersonalizadaFlowView(personalizacion: $personalizacion, renderSession: renderSession, fotosMarcos: fotosMarcos, elementosStore: elementosStore, isActive: tab == .miOfrenda && scenePhase == .active) {
                    tab = .ofrenda
                }
            }
        }
        .task { await elementosStore.cargar() }
        .onChange(of: elementosStore.configuracion) { _, seleccion in
            if let elementoSeleccionado, !seleccion.muestra(elemento: elementoSeleccionado.nombre) {
                self.elementoSeleccionado = nil
            }
        }
        .alert("Selección de la ofrenda", isPresented: Binding(
            get: { elementosStore.mensajeError != nil }, set: { if !$0 { elementosStore.mensajeError = nil } }
        )) {
            Button("Volver a guardar") { elementosStore.reintentarGuardado() }
            Button("Entendido", role: .cancel) { elementosStore.mensajeError = nil }
        } message: { Text(elementosStore.mensajeError ?? "") }
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
