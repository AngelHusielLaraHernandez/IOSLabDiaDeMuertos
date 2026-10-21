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
    let onEditarElementos: () -> Void
    let onCambiarFoto: () -> Void
    let onVolver: () -> Void

    @State private var loadState: ModelLoadState = .loading
    @State private var calaverita: String?
    @State private var mostrarCalaverita = false
    @State private var editorMarcos: EditorMarcos?
    @State private var errorFoto: String?

    private let colorFondo = AppTheme.background
    private let colorTarjeta = AppTheme.surface
    private let colorAcento = AppTheme.accent
    private let colorTextoSec = AppTheme.secondaryText

    var body: some View {
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

                // La propuesta muestra el mismo altar y las mismas fotos de la pantalla principal.
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
                                onSeleccionarMarco: { marco in
                                    editorMarcos = EditorMarcos(marco: marco)
                                },
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
                            Text(elementosStore.configuracion.muestra(.retrato) ? "Su retrato: \(personalizacion.marcoRetrato.titulo.lowercased())." : "Retratos ocultos · tus fotos se conservan.")
                                .font(.caption)
                                .foregroundStyle(colorTextoSec)
                        }
                        Spacer(minLength: 4)
                        Button("Cambiar foto", action: onCambiarFoto)
                            .ofrendaSecondaryAction()
                    }
                }
                .padding(16)
                .ofrendaSurface()
                .padding(.horizontal, 24)


                Button(action: onEditarElementos) {
                    Label("Editar elementos de la ofrenda", systemImage: "cube.transparent")
                        .frame(maxWidth: .infinity).padding(.vertical, 8)
                }
                .ofrendaSecondaryAction()
                .padding(.horizontal, 24)

                // Lo que le gustaba
                HStack {
                    Text("LO QUE LE GUSTABA")
                        .font(.caption.weight(.bold)).tracking(0.6)
                        .foregroundColor(colorAcento)
                    Spacer()
                    Button("Editar gustos") { onEditarGustos() }
                        .ofrendaSecondaryAction()
                }
                .padding(.horizontal, 24)

                HStack(spacing: 12) {
                    MiniTarjeta(titulo: "COMIDA",
                                valor: personalizacion.comidaFavorita.isEmpty ? "—" : personalizacion.comidaFavorita,
                                icono: "🍲",
                                colorTarjeta: colorTarjeta, colorAcento: colorAcento)

                    MiniTarjeta(titulo: "AFICIÓN",
                                valor: personalizacion.aficiones.sorted().first ?? "—",
                                icono: personalizacion.aficiones.sorted().first.map { n in
                                    Aficion.todas.first { $0.nombre == n }?.icono ?? "✨"
                                } ?? "✨",
                                colorTarjeta: colorTarjeta, colorAcento: colorAcento)

                    MiniTarjeta(titulo: "RECUERDO",
                                valor: personalizacion.recuerdoCompartido.isEmpty ? "—" : personalizacion.recuerdoCompartido,
                                icono: "📸",
                                colorTarjeta: colorTarjeta, colorAcento: colorAcento)
                }
                .padding(.horizontal, 24)

                // Calaverita
                VStack(alignment: .leading, spacing: 12) {
                    Text("SUS RECUERDOS, HECHOS VERSOS")
                        .font(.caption.weight(.bold)).tracking(0.6)
                        .foregroundColor(colorAcento)

                    if mostrarCalaverita, let calaverita {
                        Text(calaverita)
                            .font(.body).italic()
                            .foregroundColor(.white)
                            .lineSpacing(4)
                            .transition(.opacity)
                    } else {
                        Text("Un poema con humor inspirado en sus gustos y momentos compartidos.")
                            .font(.subheadline).foregroundColor(colorTextoSec)
                    }

                    Button {
                        withAnimation(.easeInOut) {
                            calaverita = CalaveritaGenerator.generar(para: personalizacion)
                            mostrarCalaverita = true
                        }
                    } label: {
                        Text(mostrarCalaverita ? "Regenerar calaverita literaria" : "Generar calaverita literaria")
                            .font(.headline).foregroundColor(.black)
                            .frame(maxWidth: .infinity).padding(.vertical, 8)

                    }
                    .ofrendaPrimaryAction()
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 20).fill(colorTarjeta.opacity(0.75)))
                .padding(.horizontal, 24).padding(.bottom, 32)
            }
        }
        .background(colorFondo.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .onChange(of: isActive) { _, active in if !active { loadState = .loading } }
        .sheet(item: $editorMarcos) { editor in
            MarcosFotosView(store: fotosMarcos, marcoInicial: editor.marco)
                .ofrendaSheet(detents: [.large])
        }
        .alert("No se pudo mostrar la foto", isPresented: Binding(
            get: { errorFoto != nil }, set: { if !$0 { errorFoto = nil } }
        )) {
            Button("Entendido", role: .cancel) { errorFoto = nil }
        } message: { Text(errorFoto ?? "") }
    }


}

private struct MiniTarjeta: View {
    let titulo: String
    let valor: String
    let icono: String
    let colorTarjeta: Color
    let colorAcento: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.system(size: 10, weight: .bold)).tracking(0.5)
                .foregroundColor(colorAcento)
            Text(icono).font(.title2)
            Text(valor)
                .font(.subheadline.weight(.semibold)).foregroundColor(.white)
                .lineLimit(3).minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 16).fill(colorTarjeta.opacity(0.7)))
    }
}
