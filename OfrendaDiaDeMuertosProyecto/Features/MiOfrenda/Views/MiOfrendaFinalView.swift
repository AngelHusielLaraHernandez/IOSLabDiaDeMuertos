//
//  MiOfrendaFinalView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Victor Flores on 16/10/26.
//

import SwiftUI

struct MiOfrendaFinalView: View {
    @Binding var personalizacion: PersonalizacionOfrenda
    let renderSession: OfrendaRenderSession
    let fotosMarcos: FotosMarcosStore
    let elementosStore: ElementosOfrendaStore
    var isActive = true
    let onEditarGustos: () -> Void
    let onCambiarFoto: () -> Void
    let onVolver: () -> Void
    let onTerminar: () -> Void
    
    @EnvironmentObject var ofrendasManager: OfrendasManager
    
    @State private var loadState: ModelLoadState = .loading
    @State private var editorMarcos: EditorMarcos?
    @State private var errorFoto: String?
    
    private let colorFondo = AppTheme.background
    private let colorTarjeta = AppTheme.surface
    private let colorAcento = AppTheme.accent
    private let colorTextoSec = AppTheme.secondaryText

    private var descripcionSubtitulo: String {
        var partes: [String] = []
        if !personalizacion.comidaFavorita.isEmpty { partes.append(personalizacion.comidaFavorita.lowercased()) }
        if !personalizacion.musicaFavorita.isEmpty { partes.append(personalizacion.musicaFavorita.lowercased()) }
        let inicio = elementosStore.configuracion.muestra(.flores) ? "Sus flores" : "Sus recuerdos"
        if partes.isEmpty { return "Sus gustos y recuerdos." }
        else if partes.count == 1 { return "\(inicio) y \(partes[0])." }
        else { return "\(inicio), \(partes[0]) y \(partes[1])." }
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    FlowNavigationBar(onVolver: onVolver)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("SUS GUSTOS, SU HISTORIA")
                            .font(.caption.weight(.bold)).tracking(0.8)
                            .foregroundColor(colorAcento)
                        Text("Mi ofrenda para \(personalizacion.nombre.isEmpty ? "…" : personalizacion.nombre).")
                            .font(.system(size: 30, weight: .bold)).foregroundColor(.white)
                    }
                    .padding(.horizontal, 24)
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Group {
                            if isActive {
                                OfrendaModelView(
                                    renderSession: renderSession,
                                    resetToken: 0,
                                    fotosMarcos: fotosMarcos.fotos,
                                    configuracionMarcos: fotosMarcos.configuracion,
                                    seleccionElementos: elementosStore.configuracion,
                                    isObscured: editorMarcos != nil,
                                    onLoad: { loadState = $0 },
                                    onSeleccionarMarco: { marco in editorMarcos = EditorMarcos(marco: marco) },
                                    onErrorFoto: { errorFoto = $0 }
                                )
                                .frame(height: 300)
                                .clipShape(.rect(cornerRadius: 14))
                                .overlay {
                                    if loadState == .loading {
                                        ProgressView("Cargando modelo 3D…").padding(16).ofrendaSurface()
                                    } else if case .failed(let message) = loadState {
                                        Text(message).font(.footnote).padding()
                                    }
                                }
                            } else {
                                Color.clear.frame(height: 300)
                            }
                        }
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(personalizacion.nombre.uppercased())
                                    .font(.caption.weight(.bold)).tracking(0.8)
                                    .foregroundColor(colorAcento)
                                Text("\(elementosStore.configuracion.visibles.count) tipos de elementos en su ofrenda.")
                                    .font(.title3.weight(.bold))
                                Text(descripcionSubtitulo)
                                    .font(.subheadline).foregroundStyle(colorTextoSec)
                                Text(elementosStore.configuracion.muestra(.retrato) ? "Su retrato: \(personalizacion.marcoRetrato.titulo.lowercased())." : "Retratos ocultos · tus fotos se conservan.")
                                    .font(.caption).foregroundStyle(colorTextoSec)
                            }
                            Spacer(minLength: 4)
                            Button("Cambiar foto", action: onCambiarFoto)
                                .ofrendaSecondaryAction()
                        }
                    }
                    .padding(16)
                    .ofrendaSurface()
                    .padding(.horizontal, 24)
                    
                    HStack {
                        Text("LO QUE LE GUSTABA")
                            .font(.caption.weight(.bold)).tracking(0.6)
                            .foregroundColor(colorAcento)
                        Spacer()
                        Button("Editar gustos") { onEditarGustos() }
                            .ofrendaSecondaryAction()
                    }
                    .padding(.horizontal, 24)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        MiniTarjeta(titulo: "COMIDA", valor: personalizacion.comidaFavorita.isEmpty ? "—" : personalizacion.comidaFavorita, icono: .comida, colorTarjeta: colorTarjeta, colorAcento: colorAcento)
                        MiniTarjeta(titulo: "MÚSICA", valor: personalizacion.musicaFavorita.isEmpty ? "—" : personalizacion.musicaFavorita, icono: .musica, colorTarjeta: colorTarjeta, colorAcento: colorAcento)
                        MiniTarjeta(titulo: "AFICIÓN", valor: personalizacion.aficiones.sorted().first ?? "—", icono: personalizacion.aficiones.sorted().first.map { n in Aficion.todas.first { $0.nombre == n }?.icono ?? .recuerdo } ?? .recuerdo, colorTarjeta: colorTarjeta, colorAcento: colorAcento)
                        MiniTarjeta(titulo: "RECUERDO", valor: personalizacion.recuerdoCompartido.isEmpty ? "—" : personalizacion.recuerdoCompartido, icono: .recuerdo, colorTarjeta: colorTarjeta, colorAcento: colorAcento)
                    }
                    .padding(.horizontal, 24)
                    
                    Text("Al guardar, podrás crear y conservar sus versos en la pestaña Calaveritas.")
                        .font(.subheadline)
                        .foregroundStyle(colorTextoSec)
                        .padding(.horizontal, 24)

                    Button {
                        let guardada: Bool
                        if ofrendasManager.ofrendas.contains(where: { $0.id == personalizacion.id }) {
                            guardada = ofrendasManager.actualizarOfrenda(personalizacion)
                        } else {
                            guardada = ofrendasManager.agregarOfrenda(personalizacion)
                        }
                        if guardada { onTerminar() }
                    } label: {
                        Text("Guardar ofrenda")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .ofrendaPrimaryAction()
                    .disabled(!personalizacion.estaCompleta)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }.recortaIlustraciones()

        }
        .background(colorFondo.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .onChange(of: isActive) { _, active in if !active { loadState = .loading } }
        .sheet(item: $editorMarcos) { editor in
            MarcosFotosView(store: fotosMarcos, marcoInicial: editor.marco).ofrendaSheet(detents: [.large])
        }
        .alert("No se pudo guardar la ofrenda", isPresented: Binding(
            get: { ofrendasManager.mensajeError != nil },
            set: { if !$0 { ofrendasManager.mensajeError = nil } }
        )) {
            Button("Entendido", role: .cancel) { ofrendasManager.mensajeError = nil }
        } message: { Text(ofrendasManager.mensajeError ?? "") }
        .alert("No se pudo mostrar la foto", isPresented: Binding(
            get: { errorFoto != nil }, set: { if !$0 { errorFoto = nil } }
        )) {
            Button("Entendido", role: .cancel) { errorFoto = nil }
        } message: { Text(errorFoto ?? "") }
    }
}

// MARK: - Mini Tarjeta Component
private struct MiniTarjeta: View {
    let titulo: String
    let valor: String
    let icono: IlustracionOfrenda
    let colorTarjeta: Color
    let colorAcento: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.system(size: 10, weight: .bold)).tracking(0.5)
                .foregroundColor(colorAcento)
            IlustracionOfrendaView(tipo: icono, tamano: 40)
            Text(valor)
                .font(.subheadline.weight(.semibold)).foregroundColor(.white)
                .lineLimit(3).minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 16).fill(colorTarjeta.opacity(0.7)))
    }
}


