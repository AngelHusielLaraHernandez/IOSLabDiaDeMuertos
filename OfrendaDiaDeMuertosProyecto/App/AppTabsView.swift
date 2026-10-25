//
//  AppTabsView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

private enum AppTab: Hashable {
    case ofrenda, historias, miOfrenda, calaveritas, creditos
}

struct AppTabsView: View {
    @StateObject private var guia = GuiaOfrendaStore()
    @State private var renderSession = OfrendaRenderSession()
    @State private var tab: AppTab = .ofrenda
    @State private var elementoSeleccionado: ElementoOfrenda?
    @StateObject private var recorrido = ProgresoRecorridoStore()
    private var elementosVisitados: Binding<Set<String>> {
        Binding(get: { recorrido.nombresVisitados }, set: { recorrido.registrar(nombres: $0) })
    }
    
    // Manager global de las ofrendas
    @StateObject private var ofrendasManager = OfrendasManager()
    @StateObject private var calaveritasStore = CalaveritasStore()
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.scenePhase) private var scenePhase
    private let elementos = OfrendaCatalog.elementos

    var body: some View {
        TabView(selection: $tab) {
            Tab("Ofrenda", systemImage: "house", value: .ofrenda) {
                OfrendaPrincipalTabView(
                    renderSession: renderSession,
                    isActive: tab == .ofrenda && scenePhase == .active,
                    elementosVisitados: elementosVisitados,
                    elementoSeleccionado: $elementoSeleccionado,
                    onPersonalizar: { tab = .miOfrenda },
                    idOfrenda: ofrendasManager.idModeloPrincipal,
                    nombrePersona: ofrendasManager.ofrendaPrincipal?.nombre ?? ""
                )
                .id(ofrendasManager.versionPrincipal)
            }
            
            Tab("Historias", systemImage: "text.book.closed", value: .historias) {
                HistoriasView(
                    isActive: tab == .historias && scenePhase == .active,
                    elementos: elementos,
                    elementoSeleccionado: $elementoSeleccionado
                )
            }
            
            Tab("Mi ofrenda", systemImage: "heart", value: .miOfrenda) {
                ListaMisOfrendasView(
                    renderSession: renderSession,
                    isActive: tab == .miOfrenda && scenePhase == .active,
                    onSalir: { tab = .ofrenda }
                )
            }
            Tab("Calaveritas", systemImage: "pencil.and.outline", value: .calaveritas) {
                CalaveritasLiterariasView(
                    isActive: tab == .calaveritas && scenePhase == .active,
                    onPersonalizar: { tab = .miOfrenda }
                )
            }
            Tab("Créditos", systemImage: "person.3", value: .creditos) {
                CreditosView {
                    guia.actualizarDisponibilidad(false)
                    guia.repetir()
                    tab = .ofrenda
                }
            }
        }
        .accessibilityHidden(guia.activa && guia.altarDisponible)
        .overlayPreferenceValue(ObjetivosGuiaPreference.self) { objetivos in
            GeometryReader { geometria in
                if let paso = guia.paso, guia.altarDisponible, tab == .ofrenda, scenePhase == .active,
                   let ancla = objetivos[paso] ?? objetivos[.explorar] {
                    GuiaInicialOverlay(paso: paso, objetivo: geometria[ancla], pantalla: geometria.size, guia: guia)
                }
            }
        }
        .environmentObject(guia)
        // 1. INYECTAMOS EL MANAGER A TODA LA APP
        .environmentObject(ofrendasManager)
        .environmentObject(calaveritasStore)
        .environmentObject(recorrido)
        .onChange(of: elementoSeleccionado?.id) { _, id in
            if let id { recorrido.visitar(nombre: id) }
        }
        .tint(AppTheme.accent)
        .preferredColorScheme(.dark)
        .sheet(item: $elementoSeleccionado) { elemento in
            TarjetaDetalleElementoView(
                elemento: elemento,
                renderSession: renderSession,
                // El detalle del altar usa las fotos de la misma ofrenda que se está mostrando.
                fotosMarcos: FotosMarcosStore(idOfrenda: tab == .ofrenda ? ofrendasManager.idModeloPrincipal : OfrendasManager.ofrendaGeneralID),
                textoBotonCerrar: tab == .historias ? "Volver a historias" : "Volver a la ofrenda"
            )
            .ofrendaSheet(detents: dynamicTypeSize.isAccessibilitySize ? [.large] : [.fraction(0.82), .large])
        }
    }
}

// MARK: - Altar elegido desde Mi ofrenda

private struct OfrendaPrincipalTabView: View {
    @EnvironmentObject private var manager: OfrendasManager
    let renderSession: OfrendaRenderSession
    let isActive: Bool
    @Binding var elementosVisitados: Set<String>
    @Binding var elementoSeleccionado: ElementoOfrenda?
    let onPersonalizar: () -> Void
    let nombrePersona: String

    @State private var elementosStore: ElementosOfrendaStore
    @State private var fotosMarcos: FotosMarcosStore
    private let elementos = OfrendaCatalog.elementosDelAltar

    init(renderSession: OfrendaRenderSession,
         isActive: Bool,
         elementosVisitados: Binding<Set<String>>,
         elementoSeleccionado: Binding<ElementoOfrenda?>,
         onPersonalizar: @escaping () -> Void,
         idOfrenda: UUID,
         nombrePersona: String) {
        self.renderSession = renderSession
        self.isActive = isActive
        self._elementosVisitados = elementosVisitados
        self._elementoSeleccionado = elementoSeleccionado
        self.onPersonalizar = onPersonalizar
        self.nombrePersona = nombrePersona
        _elementosStore = State(initialValue: ElementosOfrendaStore(idOfrenda: idOfrenda))
        _fotosMarcos = State(initialValue: FotosMarcosStore(idOfrenda: idOfrenda))
    }

    var body: some View {
        OfrendaView(
            elementos: elementos,
            renderSession: renderSession,
            fotosMarcos: fotosMarcos,
            seleccionElementos: elementosStore.configuracion,
            nombrePersona: nombrePersona,
            perfil: manager.ofrendaPrincipal,
            onGuardarIdentidad: { configuracion in
                guard var perfil = manager.ofrendaPrincipal else { return true }
                perfil.aplicarRetratos(configuracion)
                return manager.actualizarOfrenda(perfil, actualizarModelo: false)
            },
            isActive: isActive,
            elementosVisitados: $elementosVisitados,
            elementoSeleccionado: $elementoSeleccionado,
            onPersonalizar: onPersonalizar
        )
        .task { await elementosStore.cargar() }
        .onChange(of: elementosStore.configuracion) { _, seleccion in
            if let elementoSeleccionado, !seleccion.muestra(elemento: elementoSeleccionado.nombre) {
                self.elementoSeleccionado = nil
            }
        }
        .alert("Selección de la ofrenda", isPresented: Binding(
            get: { elementosStore.mensajeError != nil },
            set: { if !$0 { elementosStore.mensajeError = nil } }
        )) {
            Button("Volver a guardar") { elementosStore.reintentarGuardado() }
            Button("Entendido", role: .cancel) { elementosStore.mensajeError = nil }
        } message: { Text(elementosStore.mensajeError ?? "") }
    }
}
