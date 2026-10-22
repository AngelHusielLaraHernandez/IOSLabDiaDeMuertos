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
    
    @EnvironmentObject var ofrendasManager: OfrendasManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var loadState: ModelLoadState = .loading
    @State private var calaverita: String?
    @State private var mostrarCalaverita = false
    @State private var editorMarcos: EditorMarcos?
    @State private var errorFoto: String?
    @State private var mostrarPetalos = false
    
    private let colorFondo = AppTheme.background
    private let colorTarjeta = AppTheme.surface
    private let colorAcento = AppTheme.accent
    private let colorTextoSec = AppTheme.secondaryText

    private var descripcionSubtitulo: String {
        var partes: [String] = []
        if !personalizacion.comidaFavorita.isEmpty {
            partes.append(personalizacion.comidaFavorita.lowercased())
        }
        if !personalizacion.musicaFavorita.isEmpty {
            partes.append(personalizacion.musicaFavorita.lowercased())
        }

        let inicio = elementosStore.configuracion.muestra(.flores) ? "Sus flores" : "Sus recuerdos"
        if partes.isEmpty {
            return "Sus gustos y recuerdos."
        } else if partes.count == 1 {
            return "\(inicio) y \(partes[0])."
        } else {
            return "\(inicio), \(partes[0]) y \(partes[1])."
        }
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
                    
                    // Propuesta con el modelo 3D y marco
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
                                Text(descripcionSubtitulo)
                                    .font(.subheadline).foregroundStyle(colorTextoSec)
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
                    
                    // Cuadrícula con las mini tarjetas
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        MiniTarjeta(
                            titulo: "COMIDA",
                            valor: personalizacion.comidaFavorita.isEmpty ? "—" : personalizacion.comidaFavorita,
                            icono: .comida,
                            colorTarjeta: colorTarjeta, colorAcento: colorAcento
                        )
                        
                        MiniTarjeta(
                            titulo: "MÚSICA",
                            valor: personalizacion.musicaFavorita.isEmpty ? "—" : personalizacion.musicaFavorita,
                            icono: .musica,
                            colorTarjeta: colorTarjeta, colorAcento: colorAcento
                        )
                        
                        MiniTarjeta(
                            titulo: "AFICIÓN",
                            valor: personalizacion.aficiones.sorted().first ?? "—",
                            icono: personalizacion.aficiones.sorted().first.map { n in
                                Aficion.todas.first { $0.nombre == n }?.icono ?? .recuerdo
                            } ?? .recuerdo,
                            colorTarjeta: colorTarjeta, colorAcento: colorAcento
                        )
                        
                        MiniTarjeta(
                            titulo: "RECUERDO",
                            valor: personalizacion.recuerdoCompartido.isEmpty ? "—" : personalizacion.recuerdoCompartido,
                            icono: .recuerdo,
                            colorTarjeta: colorTarjeta, colorAcento: colorAcento
                        )
                    }
                    .padding(.horizontal, 24)
                    
                    // Calaverita Literaria Interactiva
                    VStack(alignment: .leading, spacing: 14) {
                        Text("SUS RECUERDOS, HECHOS VERSOS")
                            .font(.caption.weight(.bold)).tracking(0.6)
                            .foregroundColor(colorAcento)
                        
                        if mostrarCalaverita, let calaverita {
                            Text(calaverita.formatearCalaverita(colorAcento: colorAcento))
                                .font(.body).italic()
                                .foregroundColor(.white)
                                .lineSpacing(5)
                                .transition(.opacity)
                                .environment(\.openURL, OpenURLAction { url in
                                    if url.scheme == "cempasuchil" {
                                        withAnimation {
                                            mostrarPetalos = true
                                        }
                                        return .handled
                                    }
                                    return .systemAction
                                })
                        } else {
                            Text("Un poema humorístico y tradicional escrito especialmente con sus gustos y recuerdos.")
                                .font(.subheadline).foregroundColor(colorTextoSec)
                        }
                        
                        VStack(spacing: 10) {
                            Button {
                                withAnimation(.easeInOut) {
                                    calaverita = CalaveritaGenerator.generar(para: personalizacion)
                                    mostrarCalaverita = true
                                }
                            } label: {
                                Text(mostrarCalaverita ? "Generar otra calaverita" : "Generar calaverita literaria")
                                    .font(.headline).foregroundColor(.black)
                                    .frame(maxWidth: .infinity).padding(.vertical, 8)
                            }
                            .ofrendaPrimaryAction()
                            
                            if mostrarCalaverita {
                                Button {
                                    onEditarGustos()
                                } label: {
                                    Text("Editar gustos")
                                        .font(.subheadline.weight(.semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 4)
                                }
                                .ofrendaSecondaryAction()
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding(20)
                    .background(RoundedRectangle(cornerRadius: 20).fill(colorTarjeta.opacity(0.75)))
                    .padding(.horizontal, 24).padding(.bottom, 16)
                    
                    //Boton para cerrar y guardar la ofrenda en la lissta
                    Button {
                        // Si la ofrenda ya está guardada en la lista la actualiza, si no, la agrega como nueva
                        if ofrendasManager.ofrendas.contains(where: { $0.id == personalizacion.id }) {
                            ofrendasManager.actualizarOfrenda(personalizacion)
                        } else {
                            ofrendasManager.agregarOfrenda(personalizacion)
                        }
                        
                        dismiss() // Cierra la pantalla y regresa a la lista
                    } label: {
                        Text("Terminar")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .ofrendaPrimaryAction()
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }.recortaIlustraciones()

            // Capa de animación para la caída de pétalos
            if mostrarPetalos {
                PetalosCempasuchilView {
                    mostrarPetalos = false
                }
                .ignoresSafeArea()
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

// MARK: - Animación de Pétalos de Cempasúchil
private struct PetalosCempasuchilView: View {
    let onTerminar: () -> Void
    @State private var animar = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var petalos = (0..<20).map { _ in
        PetaloData(
            x: Double.random(in: 0.05...0.95),
            retraso: Double.random(in: 0...0.4),
            duracion: Double.random(in: 1.8...2.5),
            tamano: CGFloat.random(in: 18...30),
            rotacion: Double.random(in: -180...180)
        )
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(petalos) { p in
                    Capsule()
                        .fill(LinearGradient(colors: [AppTheme.accent, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: p.tamano * 0.55, height: p.tamano)
                        .rotationEffect(.degrees(animar && !reduceMotion ? p.rotacion + 360 : p.rotacion))
                        .position(
                            x: proxy.size.width * p.x,
                            y: reduceMotion ? proxy.size.height * 0.3 : (animar ? proxy.size.height + 50 : -50)
                        )
                        .opacity(animar ? 0.95 : 0)
                        .animation(
                            .easeOut(duration: reduceMotion ? 0.2 : p.duracion).delay(reduceMotion ? 0 : p.retraso),
                            value: animar
                        )
                }
            }
        }
        .allowsHitTesting(false)
        .task {
            animar = true
            let duracion = reduceMotion ? 0.4 : (petalos.map { $0.duracion + $0.retraso }.max() ?? 2.9) + 0.1
            do { try await Task.sleep(for: .seconds(duracion)) }
            catch { return }
            guard !Task.isCancelled else { return }
            onTerminar()
        }
    }
}

private struct PetaloData: Identifiable {
    let id = UUID()
    let x: Double
    let retraso: Double
    let duracion: Double
    let tamano: CGFloat
    let rotacion: Double
}

// MARK: - Formateador de Texto de Calaverita
private extension String {
    func formatearCalaverita(colorAcento: Color) -> AttributedString {
        var options = AttributedString.MarkdownParsingOptions()
        options.interpretedSyntax = .inlineOnlyPreservingWhitespace

        guard var attrString = try? AttributedString(markdown: self, options: options) else {
            return AttributedString(self)
        }

        for run in attrString.runs {
            if run.inlinePresentationIntent?.contains(.stronglyEmphasized) == true {
                attrString[run.range].foregroundColor = colorAcento
                attrString[run.range].font = Font.body.bold().italic()
                attrString[run.range].link = URL(string: "cempasuchil://flores")
            }
        }

        return attrString
    }
}
