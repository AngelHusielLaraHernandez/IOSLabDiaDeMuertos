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
    var perfil: PersonalizacionOfrenda? = nil
    var onGuardarIdentidad: ((ConfiguracionMarcos) -> Bool)? = nil
    private var personalizada: Bool { fotosMarcos.idOfrenda != OfrendasManager.ofrendaGeneralID }
    private var nombres: String {
        let actuales = fotosMarcos.configuracion.nombresCortos
        return actuales.isEmpty ? (perfil?.nombresResumen ?? IdentidadRetrato.primerNombre(de: nombrePersona)) : actuales
    }
    private var etiquetasMarcos: [MarcoOfrenda: String] {
        guard personalizada else { return [:] }
        let configuracion = fotosMarcos.configuracion.personas.isEmpty ? (perfil?.configuracionInicial(desde: fotosMarcos.configuracion) ?? fotosMarcos.configuracion) : fotosMarcos.configuracion
        return Dictionary(uniqueKeysWithValues: configuracion.visibles.map { ($0, configuracion.persona(en: $0).primerNombre) })
    }
    var isActive = true
    @Binding var elementosVisitados: Set<String>
    @Binding var elementoSeleccionado: ElementoOfrenda?
    let onPersonalizar: () -> Void
    @State private var mostrarRecorrido = false
    @State private var mostrarFechas = false
    @State private var mostrarReferencias = true
    @State private var solicitudCaptura: UUID?
    @State private var capturaCompartida: CapturaOfrenda?
    @State private var errorCaptura: String?

    @State private var pendienteDelRecorrido: ElementoOfrenda?
    @State private var loadState: ModelLoadState = .loading
    @State private var viewport = OfrendaViewportState()
    @State private var focusRequest: OfrendaFocusRequest?
    @State private var editorMarcos: EditorMarcos?
    @State private var errorFoto: String?
    @EnvironmentObject private var guia: GuiaOfrendaStore
    @State private var referenciasAntesGuia: Bool?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var elementosVisibles: [ElementoOfrenda] {
        elementos.filter { seleccionElementos.muestra(elemento: $0.nombre) }
    }
    private var visitasVisibles: Int { elementosVisibles.filter { elementosVisitados.contains($0.nombre) }.count }

    var body: some View {
        ScrollViewReader { desplazamiento in
            Group {
                if verticalSizeClass == .compact || dynamicTypeSize.isAccessibilitySize {
                    ScrollView { contenido }
                } else { contenido }
            }
            .onChange(of: guia.paso) { _, paso in
                if verticalSizeClass == .compact || dynamicTypeSize.isAccessibilitySize, let paso {
                    desplazamiento.scrollTo(paso, anchor: paso == .personalizar ? .bottom : .top)
                }
            }
        }
        .foregroundStyle(.white)
        .background(AppTheme.background.ignoresSafeArea())
        .onAppear { guia.actualizarDisponibilidad(isActive && loadState == .ready) }
        .onChange(of: loadState) { _, estado in guia.actualizarDisponibilidad(isActive && estado == .ready) }
        .onChange(of: guia.activa) { _, activa in
            if activa {
                referenciasAntesGuia = mostrarReferencias
                mostrarReferencias = true
            } else if let referenciasAntesGuia {
                mostrarReferencias = referenciasAntesGuia
                self.referenciasAntesGuia = nil
            }
        }
        .onChange(of: isActive) { _, active in
            guia.actualizarDisponibilidad(active && loadState == .ready)
            if !active { solicitudCaptura = nil }
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
        .task(id: solicitudCaptura) {
            guard let solicitud = solicitudCaptura else { return }
            defer { if solicitudCaptura == solicitud { solicitudCaptura = nil } }
            do {
                let imagen = try await renderSession.capturarOfrenda()
                try Task.checkCancellation()
                let nombre = nombres
                capturaCompartida = CapturaOfrenda(imagen: imagen, titulo: nombre.isEmpty ? "Mi ofrenda" : "La ofrenda de \(nombre)")
            } catch is CancellationError { }
            catch { if !Task.isCancelled { errorCaptura = error.localizedDescription } }
        }
        .sheet(item: $capturaCompartida) { captura in
            CompartirOfrendaView(captura: captura)
        }
        .alert("No se pudo capturar la ofrenda", isPresented: Binding(
            get: { errorCaptura != nil }, set: { if !$0 { errorCaptura = nil } }
        )) {
            Button("Entendido", role: .cancel) { errorCaptura = nil }
        } message: {
            Text(errorCaptura ?? "")
        }

        .ilustracionesOfrenda(activa: isActive && !mostrarRecorrido && !mostrarFechas && editorMarcos == nil && elementoSeleccionado == nil && capturaCompartida == nil && solicitudCaptura == nil)
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
            .ofrendaSheet(detents: UserDefaults.standard.bool(forKey: GuiaContextualAmbito.recorrido.clave) ? [.medium, .large] : [.large])
        }
        .sheet(item: $editorMarcos) { editor in
            MarcosFotosView(store: fotosMarcos, marcoInicial: editor.marco, perfilInicial: perfil, onGuardarIdentidad: onGuardarIdentidad)
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
                    Group {
                        if personalizada {
                            Text("LA OFRENDA DE \(Text(nombres.uppercased()).bold().foregroundColor(AppTheme.accent))")
                                .foregroundStyle(AppTheme.secondaryText)
                        } else { Text("OFRENDA GENERAL").foregroundColor(AppTheme.accent) }
                    }
                    .font(.caption.weight(.medium)).tracking(0.8)
                    .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 4)
                    HStack(spacing: 8) {
                        GlassIconButton(systemImage: "photo.on.rectangle", label: "Agregar fotos a los marcos") {
                            editorMarcos = EditorMarcos(marco: nil)
                        }
                        .objetivoGuia(.fotografias).id(PasoGuiaOfrenda.fotografias)
                        GlassIconButton(
                            systemImage: mostrarReferencias ? "eye.slash" : "eye",
                            label: mostrarReferencias ? "Ocultar referencias" : "Mostrar referencias"
                        ) { mostrarReferencias.toggle() }
                        .objetivoGuia(.vistaLimpia).id(PasoGuiaOfrenda.vistaLimpia)
                        .accessibilityValue(mostrarReferencias ? "Referencias visibles" : "Referencias ocultas")
                        .accessibilityHint("Muestra u oculta las etiquetas y los botones sobre el altar")
                        Button { solicitudCaptura = UUID() } label: {
                            Group {
                                if solicitudCaptura != nil { ProgressView().tint(AppTheme.accent) }
                                else { Image(systemName: "square.and.arrow.up").font(.body.weight(.semibold)) }
                            }
                            .frame(width: 44, height: 44)
                            .contentShape(.circle)
                        }
                        .buttonStyle(.plain)
                        .glassEffect(.regular.interactive(), in: .circle)
                        .objetivoGuia(.compartir).id(PasoGuiaOfrenda.compartir)
                        .accessibilityLabel(solicitudCaptura == nil ? "Capturar y compartir ofrenda" : "Preparando captura")
                        .accessibilityHint("Encuadra toda la ofrenda y abre las opciones para compartir su imagen")
                    }
                    // Los símbolos caben en sus blancos de toque sin limitar el texto de la pantalla.
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                    .disabled(loadState != .ready || focusRequest != nil || solicitudCaptura != nil)
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
                .objetivoGuia(.recorrido).id(PasoGuiaOfrenda.recorrido)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)

            CalendarioOfrendaView(activo: isActive, mostrarFechas: $mostrarFechas)
                .padding(.horizontal, 24)

            GeometryReader { geometry in
                let paused = elementoSeleccionado != nil || editorMarcos != nil || mostrarRecorrido || mostrarFechas || capturaCompartida != nil || !isActive
                let projections = paused || !mostrarReferencias || solicitudCaptura != nil ? [:] : viewport.positions
                let photoControls = MarcoPhotoControls.placements(paused || !mostrarReferencias || solicitudCaptura != nil ? [:] : viewport.frameProjections, in: geometry.size, nombres: etiquetasMarcos)
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
                                guard mostrarReferencias, solicitudCaptura == nil, loadState == .ready, focusRequest == nil else { return }
                                editorMarcos = EditorMarcos(marco: marco)
                            },
                            onErrorFoto: { mensaje in
                                if editorMarcos != nil { fotosMarcos.mensajeError = mensaje }
                                else { errorFoto = mensaje }
                            },
                            configuracionMarcos: fotosMarcos.configuracion,
                            seleccionElementos: seleccionElementos,
                            isObscured: elementoSeleccionado != nil || editorMarcos != nil || mostrarRecorrido || mostrarFechas || capturaCompartida != nil || !isActive,
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
                                    .objetivoGuia(.historias, activo: elemento.nombre == pins.keys.sorted().first)
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
                        nombres: etiquetasMarcos,
                        isEnabled: !paused && loadState == .ready && focusRequest == nil,
                        requiereCambioDeNombre: personalizada
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
            .objetivoGuia(.explorar).id(PasoGuiaOfrenda.explorar)
            .id(PasoGuiaOfrenda.historias)

            Text(mostrarReferencias ? "Toca un marco: fotos · 1 dedo: girar · 2 dedos: mover · Pellizca: acercar" : "1 dedo: girar · 2 dedos: mover · Pellizca: acercar")
                .font(.caption2)
                .foregroundStyle(AppTheme.secondaryText)
                .frame(maxWidth: .infinity)
                .allowsHitTesting(false)
            if !personalizada {
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
            .objetivoGuia(.personalizar).id(PasoGuiaOfrenda.personalizar)
            }
        }
        .disabled(solicitudCaptura != nil)
        .foregroundStyle(.white)
        .background(AppTheme.background.ignoresSafeArea())
    }
}
