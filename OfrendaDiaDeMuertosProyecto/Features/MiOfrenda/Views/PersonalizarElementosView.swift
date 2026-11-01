//
//  PersonalizarElementosView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI


struct PersonalizarElementosView: View {
    let renderSession: OfrendaRenderSession
    let store: ElementosOfrendaStore
    let fotosMarcos: FotosMarcosStore
    var isActive = true
    let onVolver: () -> Void
    let onContinuar: () -> Void
    @State private var loadState: ModelLoadState = .loading
    @State private var resetToken = 0
    @State private var errorFoto: String?
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        Group {
            if verticalSizeClass == .compact || dynamicTypeSize.isAccessibilitySize {
                ScrollView { VStack(spacing: 16) { cabecera; vistaPrevia; resumen; opciones; continuar } }.recortaIlustraciones()
            } else {
                VStack(spacing: 12) {
                    cabecera
                    vistaPrevia
                    resumen
                    ScrollView { opciones }.recortaIlustraciones()
                    continuar
                }
            }
        }
        .foregroundStyle(.white)
        .background(AppTheme.background.ignoresSafeArea())
        .task { await store.cargar(); await fotosMarcos.cargar() }
        .onChange(of: isActive) { _, active in if !active { loadState = .loading } }
        .alert("No se pudo mostrar la fotografía", isPresented: Binding(
            get: { errorFoto != nil }, set: { if !$0 { errorFoto = nil } }
        )) { Button("Entendido", role: .cancel) { errorFoto = nil } }
        message: { Text(errorFoto ?? "") }
    }

    private var cabecera: some View {
        VStack(alignment: .leading, spacing: 10) {
            FlowNavigationBar(onVolver: onVolver)
            VStack(alignment: .leading, spacing: 6) {
                Text("TU OFRENDA, A TU MANERA")
                    .font(.caption.bold()).tracking(0.8).foregroundStyle(AppTheme.accent)
                Text("Elige qué poner.").font(.title.bold()).accessibilityAddTraits(.isHeader)
                Text("Activa o retira elementos y mira cómo cambia el modelo. Tus cambios también aparecen en la pantalla principal.")
                    .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
            }.padding(.horizontal, 24)
        }
    }
    private var vistaPrevia: some View {
        ZStack {
            if isActive {
                OfrendaModelView(
                    renderSession: renderSession,
                    resetToken: resetToken, fotosMarcos: fotosMarcos.fotos,
                    configuracionMarcos: fotosMarcos.configuracion,
                    seleccionElementos: store.configuracion,
                    onLoad: { loadState = $0 }, onSeleccionarMarco: { _ in },
                    onErrorFoto: { errorFoto = $0 }, mostrarControlesFotos: false
                )
            }
            if loadState == .loading || store.cargando {
                ProgressView("Cargando modelo 3D…").padding(16).ofrendaSurface()
            } else if case .failed(let mensaje) = loadState {
                Text(mensaje).font(.footnote).multilineTextAlignment(.center).padding()
            }
            VStack {
                HStack {
                    Spacer()
                    GlassIconButton(systemImage: "arrow.counterclockwise", label: "Restablecer cámara de la ofrenda") { resetToken += 1 }
                }
                Spacer()
            }.padding(12)
        }
        .frame(height: verticalSizeClass == .compact ? 180 : 220)
        .background(AppTheme.surface.opacity(0.45), in: .rect(cornerRadius: 22))
        .clipShape(.rect(cornerRadius: 22))
        .padding(.horizontal, 24)
    }
    private var resumen: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(store.configuracion.visibles.count) de \(GrupoElementoOfrenda.allCases.count) tipos de elementos visibles")
                    .font(.caption.weight(.semibold))
                Text(store.configuracion.visibles.isEmpty ? "Solo permanece la estructura del altar." : "Arrastra para girar · Pellizca para acercar")
                    .font(.caption2).foregroundStyle(AppTheme.secondaryText)
            }
            Spacer(minLength: 8)
            Button("Mostrar todos") { store.mostrarTodos() }
                .font(.caption.weight(.semibold)).ofrendaSecondaryAction()
                .disabled(store.cargando || store.configuracion == ConfiguracionElementosOfrenda())
        }.padding(.horizontal, 24)
    }
    private var opciones: some View {
        LazyVStack(spacing: 10) {
            ForEach(GrupoElementoOfrenda.allCases) { grupo in
                Toggle(isOn: Binding(
                    get: { store.configuracion.muestra(grupo) },
                    set: { store.establecer(grupo, visible: $0) }
                )) {
                    HStack(alignment: .top, spacing: 12) {
                        IlustracionOfrendaView(tipo: grupo.icono, tamano: 40)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(grupo.nombre).font(.headline)
                            Text(grupo.detalle).font(.caption).foregroundStyle(AppTheme.secondaryText)
                        }
                    }
                }
                .tint(AppTheme.accent)
                .padding(16)
                .glassEffect(.regular, in: .rect(cornerRadius: 20))
                .accessibilityLabel("Mostrar \(grupo.nombre)")
                .accessibilityHint(grupo.detalle)
                .disabled(store.cargando)
            }
            Text("Se guardan en este teléfono. Ocultar los retratos conserva sus fotos y la disposición de uno o dos marcos. La mesa y sus niveles permanecen como base.")
                .font(.footnote).foregroundStyle(AppTheme.secondaryText).padding(.vertical, 8)
        }.padding(.horizontal, 24).padding(.vertical, 4)
    }
    private var continuar: some View {
        Button(action: onContinuar) {
            Text(store.guardando ? "Guardando selección…" : "Listo")
                .frame(maxWidth: .infinity).padding(.vertical, 8)
        }
        .ofrendaPrimaryAction()
        .disabled(store.cargando || store.guardando)
        .padding(.horizontal, 24).padding(.bottom, 12)
    }
}
