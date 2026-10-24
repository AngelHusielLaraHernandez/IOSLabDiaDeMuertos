//
//  OfrendaView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct OfrendaView: View {
    let elementos: [ElementoOfrenda]
    let renderSession: OfrendaRenderSession
    let fotosMarcos: FotosMarcosStore
    var seleccionElementos = ConfiguracionElementosOfrenda()
    var nombrePersona = ""
    var isActive = true
    @Binding var elementosVisitados: Set<String>
    @Binding var elementoSeleccionado: ElementoOfrenda?
    let onPersonalizar: () -> Void
    @State private var mostrarRecorrido = false
    @State private var mostrarFechas = false
    @State private var pendienteDelRecorrido: ElementoOfrenda?
    @State private var loadState: ModelLoadState = .loading
    @State private var viewport = OfrendaViewportState()
    @State private var focusRequest: OfrendaFocusRequest?
    @State private var editorMarcos: EditorMarcos?
    @State private var errorFoto: String?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var elementosVisibles: [ElementoOfrenda] {
        elementos.filter { seleccionElementos.muestra(elemento: $0.nombre) }
    }
    private var visitasVisibles: Int { elementosVisibles.filter { elementosVisitados.contains($0.nombre) }.count }

    var body: some View {
        Group {
            if verticalSizeClass == .compact || dynamicTypeSize.isAccessibilitySize {
                ScrollView { contenido }
            } else {
                contenido
            }
        }
        .foregroundStyle(.white)
        .background(AppTheme.background.ignoresSafeArea())
        .onChange(of: isActive) { _, active in
            if !active && elementoSeleccionado == nil {
                focusRequest = nil
                viewport = OfrendaViewportState()
                loadState = .loading
            }
        }
        .onChange(of: elementoSeleccionado?.id) { _, selectedID in
            if selectedID == nil { focusRequest = nil }
        }
        .onChange(of: seleccionElementos) { _, seleccion in
            if let focusRequest, !seleccion.muestra(elemento: focusRequest.elementID) {
                self.focusRequest = nil
            }
        }
        .task { await fotosMarcos.cargar() }
        .ilustracionesOfrenda(activa: isActive && !mostrarRecorrido && !mostrarFechas && editorMarcos == nil && elementoSeleccionado == nil)
        .sheet(isPresented: $mostrarRecorrido, onDismiss: {
            guard let elemento = pendienteDelRecorrido else { return }
            pendienteDelRecorrido = nil
            guard isActive, seleccionElementos.muestra(elemento: elemento.nombre) else { return }
            focusRequest = OfrendaFocusRequest(elementID: elemento.id)
        }) {
            RecorridoOfrendaView(elementos: elementosVisibles, visitados: elementosVisitados,
                                ocultos: elementos.count - elementosVisibles.count, puedeAbrir: loadState == .ready) { elemento in
                pendienteDelRecorrido = elemento
                mostrarRecorrido = false
            }
            .ofrendaSheet(detents: [.medium, .large])
        }
        .sheet(item: $editorMarcos) { editor in
            MarcosFotosView(store: fotosMarcos, marcoInicial: editor.marco)
                .ofrendaSheet(detents: [.large])
        }
        .alert("No se pudo mostrar la foto", isPresented: Binding(
            get: { errorFoto != nil }, set: { if !$0 { errorFoto = nil } }
        )) {
            Button("Entendido", role: .cancel) { errorFoto = nil }
        } message: {
            Text(errorFoto ?? "")
        }
    }

    private var contenido: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 12) {
                    Text(nombrePersona.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "OFRENDA GENERAL" : "LA OFRENDA DE \(nombrePersona.uppercased())")
                        .font(.caption.weight(.bold))
                        .tracking(0.8)
                        .foregroundStyle(AppTheme.accent)
                    Spacer(minLength: 4)
                    Button {
                        editorMarcos = EditorMarcos(marco: nil)
                    } label: {
                        Label("Fotos", systemImage: "photo.on.rectangle")
                            .frame(minHeight: 32)
                    }
                    .ofrendaSecondaryAction()
                    .accessibilityLabel("Agregar fotos a los marcos")
                    .disabled(loadState != .ready || focusRequest != nil)
                }
                Text("Cada objeto, una historia.")
                    .font(.largeTitle.bold())
                    .fixedSize(horizontal: false, vertical: true)
                Button { mostrarRecorrido = true } label: {
                    VStack(alignment: .leading, spacing: 7) {
                        HStack(spacing: 10) {
                            Text(elementosVisibles.isEmpty ? "Sin elementos visibles · Personaliza tu altar" : "\(visitasVisibles) de \(elementosVisibles.count) elementos · Explora a tu ritmo")
                                .font(.caption.weight(.medium))
                            Spacer(minLength: 4)
                            Image(systemName: "chevron.down").font(.caption.bold()).foregroundStyle(AppTheme.accent)
                        }
                        ProgressView(value: Double(visitasVisibles), total: Double(max(1, elementosVisibles.count)))
                            .tint(AppTheme.accent)
                    }
                    .foregroundStyle(AppTheme.secondaryText)
                    .frame(minHeight: 44).contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Ver lista del recorrido")
                .accessibilityValue("\(visitasVisibles) de \(elementosVisibles.count) elementos visitados")
                .accessibilityHint("Muestra los elementos pendientes y completados")
                .disabled(focusRequest != nil)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)

            CalendarioOfrendaView(activo: isActive, mostrarFechas: $mostrarFechas)
                .padding(.horizontal, 24)

            GeometryReader { geometry in
                let paused = elementoSeleccionado != nil || editorMarcos != nil || mostrarRecorrido || mostrarFechas || !isActive
                let projections = paused ? [:] : viewport.positions
                let photoControls = MarcoPhotoControls.placements(paused ? [:] : viewport.frameProjections, in: geometry.size)
                let pins = OfrendaPinLayout.place(
                    elementosVisibles.compactMap { elemento in
                        guard let point = projections[elemento.nombre] else { return nil }
                        return OfrendaPinLayout.Pin(
                            id: elemento.nombre,
                            anchor: point,
                            width: min(150, max(84, CGFloat(elemento.nombre.count) * 6.4 + 38)),
                            zoomMaximo: elemento.zoomMaximoEtiqueta
                        )
                    },
                    in: geometry.size,
                    zoomFactor: viewport.zoomFactor,
                    selectedID: focusRequest?.elementID,
                    reservedRects: MarcoPhotoControls.reservedRects(photoControls)
                )
                ZStack {
                    if isActive || elementoSeleccionado != nil {
                        OfrendaInteractive3DView(
                            elementos: elementos,
                            resetToken: 0,
                            viewport: $viewport,
                            focusRequest: focusRequest,
                            reduceMotion: reduceMotion,
                            onFocusCompleted: { requestID in
                                guard let request = focusRequest, request.id == requestID,
                                      let elemento = elementos.first(where: { $0.id == request.elementID }),
                                      seleccionElementos.muestra(elemento: elemento.nombre) else { return }
                                elementosVisitados.insert(elemento.nombre)
                                elementoSeleccionado = elemento
                            },
                            onLoad: { loadState = $0 },
                            fotosMarcos: fotosMarcos.fotos,
                            onSeleccionarMarco: { marco in
                                guard loadState == .ready, focusRequest == nil else { return }
                                editorMarcos = EditorMarcos(marco: marco)
                            },
                            onErrorFoto: { mensaje in
                                if editorMarcos != nil { fotosMarcos.mensajeError = mensaje }
                                else { errorFoto = mensaje }
                            },
                            configuracionMarcos: fotosMarcos.configuracion,
                            seleccionElementos: seleccionElementos,
                            isObscured: elementoSeleccionado != nil || editorMarcos != nil || mostrarRecorrido || mostrarFechas || !isActive,
                            renderSession: renderSession
                        )
                    }
                    GlassEffectContainer(spacing: 4) {
                        ZStack {
                            ForEach(elementosVisibles) { elemento in
                                if let pin = pins[elemento.nombre] {
                                    if let anchor = projections[elemento.nombre],
                                       abs(anchor.y - pin.center.y) + abs(anchor.x - pin.center.x) > 12 {
                                        Path { path in
                                            path.move(to: anchor)
                                            path.addLine(to: pin.center)
                                        }
                                        .stroke(.white.opacity(0.22), style: StrokeStyle(lineWidth: 1, dash: [3, 4]))
                                        .allowsHitTesting(false)
                                    }
                                    Button {
                                        focusRequest = OfrendaFocusRequest(elementID: elemento.id)
                                    } label: {
                                        HStack(spacing: 4) {
                                            if elementosVisitados.contains(elemento.nombre) {
                                                Image(systemName: "checkmark")
                                                    .font(.caption2.bold())
                                            }
                                            Text(elemento.nombre)
                                                .font(.caption.weight(.semibold))
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.85)
                                        }
                                        .padding(.horizontal, 8)
                                        .frame(width: pin.width, height: 44)
                                        .contentShape(.capsule)
                                    }
                                    .buttonStyle(.plain)
                                    .glassEffect(.regular.interactive(), in: .capsule)
                                    .position(pin.center)
                                    .accessibilityLabel("\(elemento.nombre): ver historia y significado")
                                    .accessibilityHint("Acerca el elemento y abre su historia")
                                    .disabled(loadState != .ready || (focusRequest != nil && elementoSeleccionado == nil))
                                }
                            }
                        }
                    }
                    MarcoPhotoControls(
                        placements: photoControls,
                        isEnabled: !paused && loadState == .ready && focusRequest == nil
                    ) { marco in
                        editorMarcos = EditorMarcos(marco: marco)
                    }
                    if case .loading = loadState {
                        ProgressView("Cargando modelo 3D…")
                            .padding(20)
                            .ofrendaSurface()
                    }
                    if case .failed(let message) = loadState {
                        ContentUnavailableView("No se pudo abrir el modelo", systemImage: "cube", description: Text(message))
                            .ofrendaSurface()
                    }
                }
                .clipped()
            }
            .frame(minHeight: 210)

            Text("Toca un marco: fotos · 1 dedo: girar · 2 dedos: mover · Pellizca: acercar")
                .font(.caption2)
                .foregroundStyle(AppTheme.secondaryText)
                .frame(maxWidth: .infinity)
                .allowsHitTesting(false)
            Button(action: onPersonalizar) {
                HStack(spacing: 12) {
                    Image(systemName: "heart")
                        .font(.title3)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Personaliza tu ofrenda")
                            .font(.subheadline.bold())
                        Text("Fotos, recuerdos y elementos en 3D")
                            .font(.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .contentShape(.rect(cornerRadius: 24))
            }
            .buttonStyle(.plain)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 24))
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .foregroundStyle(.white)
        .background(AppTheme.background.ignoresSafeArea())
    }
}
