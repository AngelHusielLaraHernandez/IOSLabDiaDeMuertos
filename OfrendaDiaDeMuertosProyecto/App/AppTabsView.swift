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
    
    // 1. Agregamos el OfrendasManager
    @StateObject private var ofrendasManager = OfrendasManager()
    
   
    
    // 3. Como borramos el .shared, creamos almacenes por defecto para el altar principal (didáctico)
    // Usamos un UUID de puros ceros para identificar a la ofrenda principal/educativa.
    @State private var elementosStore = ElementosOfrendaStore(idOfrenda: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!)

    @State private var fotosMarcos = FotosMarcosStore(idOfrenda: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!)
    
    
    
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
                    nombrePersona: "", // Como es la ofrenda general, dejamos el nombre vacío
                    isActive: tab == .ofrenda && scenePhase == .active,
                    elementosVisitados: $elementosVisitados,
                    elementoSeleccionado: $elementoSeleccionado,
                    onPersonalizar: { tab = .miOfrenda }
                )
            }
            Tab("Historias", systemImage: "text.book.closed", value: .historias) {
                HistoriasView(
                    isActive: tab == .historias && scenePhase == .active,
                    elementos: elementos,
                    elementoSeleccionado: $elementoSeleccionado
                )
            }
            Tab("Mi ofrenda", systemImage: "heart", value: .miOfrenda) {
                // 4. AQUÍ AGREGAMOS TU NUEVA LISTA
                ListaMisOfrendasView(
                    renderSession: renderSession,
                    onSalir: { tab = .ofrenda }
                )
            }
        }
        // 5. INYECTAMOS EL MANAGER A TODA LA APP
        .environmentObject(ofrendasManager)
        
        .task { await elementosStore.cargar() }
        .onChange(of: elementoSeleccionado?.id) { _, id in
            if let id { elementosVisitados.insert(id) }
        }
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
                textoBotonCerrar: tab == .historias ? "Volver a historias" : "Volver a la ofrenda"
            )
            .ofrendaSheet(detents: [.fraction(0.82), .large])
        }
    }
}

