//
//  AppTabsView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

private enum AppTab: Hashable {
    case ofrenda, historias, miOfrenda, calaveritas
}

struct AppTabsView: View {
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
                    ofrendas: ofrendasManager.ofrendas
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
        }
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
                // Usamos la ofrenda principal/didáctica para el detalle global
                fotosMarcos: FotosMarcosStore(idOfrenda: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!),
                textoBotonCerrar: tab == .historias ? "Volver a historias" : "Volver a la ofrenda"
            )
            .ofrendaSheet(detents: [.fraction(0.82), .large])
        }
    }
}

// MARK: - Pestaña principal con selector de ofrendas

private struct OfrendaPrincipalTabView: View {
    static let didacticID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!

    let renderSession: OfrendaRenderSession
    let isActive: Bool
    @Binding var elementosVisitados: Set<String>
    @Binding var elementoSeleccionado: ElementoOfrenda?
    let onPersonalizar: () -> Void
    let ofrendas: [PersonalizacionOfrenda]

    @State private var idSeleccionada: UUID? = nil // nil = ofrenda general/didáctica
    @State private var elementosStore: ElementosOfrendaStore
    @State private var fotosMarcos: FotosMarcosStore
    @State private var nombrePersona: String = ""

    private let elementos = OfrendaCatalog.elementos

    init(renderSession: OfrendaRenderSession,
         isActive: Bool,
         elementosVisitados: Binding<Set<String>>,
         elementoSeleccionado: Binding<ElementoOfrenda?>,
         onPersonalizar: @escaping () -> Void,
         ofrendas: [PersonalizacionOfrenda]) {
        self.renderSession = renderSession
        self.isActive = isActive
        self._elementosVisitados = elementosVisitados
        self._elementoSeleccionado = elementoSeleccionado
        self.onPersonalizar = onPersonalizar
        self.ofrendas = ofrendas
        let didactic = Self.didacticID
        _elementosStore = State(initialValue: ElementosOfrendaStore(idOfrenda: didactic))
        _fotosMarcos = State(initialValue: FotosMarcosStore(idOfrenda: didactic))
    }

    var body: some View {
        OfrendaView(
            elementos: elementos,
            renderSession: renderSession,
            fotosMarcos: fotosMarcos,
            seleccionElementos: elementosStore.configuracion,
            nombrePersona: nombrePersona,
            isActive: isActive,
            elementosVisitados: $elementosVisitados,
            elementoSeleccionado: $elementoSeleccionado,
            onPersonalizar: onPersonalizar
        )
        // Selector flotante en la esquina superior derecha
        .overlay(alignment: .topTrailing) {
            selectorDeOfrenda
                .padding(.top, 80)      // <-- Ajusta este valor si necesitas bajarlo o subirlo más
                .padding(.trailing, 20)
        }
        .task {
            await elementosStore.cargar()
        }
        .onChange(of: idSeleccionada) { _, _ in
            aplicarSeleccion()
        }
        // Mantenemos la validación de elementos ocultos
        .onChange(of: elementosStore.configuracion) { _, seleccion in
            if let elementoSeleccionado, !seleccion.muestra(elemento: elementoSeleccionado.nombre) {
                self.elementoSeleccionado = nil
            }
        }
        // Mantenemos la alerta de errores del Store
        .alert("Selección de la ofrenda", isPresented: Binding(
            get: { elementosStore.mensajeError != nil },
            set: { if !$0 { elementosStore.mensajeError = nil } }
        )) {
            Button("Volver a guardar") { elementosStore.reintentarGuardado() }
            Button("Entendido", role: .cancel) { elementosStore.mensajeError = nil }
        } message: {
            Text(elementosStore.mensajeError ?? "")
        }
    }

    private var selectorDeOfrenda: some View {
        Menu {
            Button {
                idSeleccionada = nil
            } label: {
                Label("Ofrenda general", systemImage: idSeleccionada == nil ? "checkmark" : "square.stack")
            }
            
            if !ofrendas.isEmpty {
                Divider()
                ForEach(ofrendas) { ofrenda in
                    Button {
                        idSeleccionada = ofrenda.id
                    } label: {
                        Label(ofrenda.nombre.isEmpty ? "Ofrenda sin nombre" : ofrenda.nombre,
                              systemImage: idSeleccionada == ofrenda.id ? "checkmark" : "person.crop.circle")
                    }
                }
            }
        } label: {
            Image(systemName: "rectangle.stack.badge.person.crop")
                .font(.title3)
                .padding(12)
                .background(.ultraThinMaterial, in: .circle)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .accessibilityLabel("Cambiar de ofrenda")
    }

    private func aplicarSeleccion() {
        let id = idSeleccionada ?? Self.didacticID
        elementosStore = ElementosOfrendaStore(idOfrenda: id)
        fotosMarcos = FotosMarcosStore(idOfrenda: id)
        
        if let id = idSeleccionada,
           let ofrenda = ofrendas.first(where: { $0.id == id }) {
            nombrePersona = ofrenda.nombre
        } else {
            nombrePersona = ""
        }
        
        Task { await elementosStore.cargar() }
    }
}
