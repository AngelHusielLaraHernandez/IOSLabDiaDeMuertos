//
//  MarcosFotosView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 17/10/26.
//

import SwiftUI
import PhotosUI

/// Edita las fotos que comparten el altar y su propuesta personalizada.
struct MarcosFotosView: View {
    let store: FotosMarcosStore
    var marcoInicial: MarcoOfrenda?
    @State private var marcoElegido: MarcoOfrenda = .izquierdo
    @State private var pickerAbierto = false
    @State private var pickerItem: PhotosPickerItem?
    @State private var ajuste: AjusteMarco?
    @State private var procesando = false
    @State private var errorSeleccion: String?

    private var ocupado: Bool { procesando || store.cargando || store.guardandoConfiguracion || pickerAbierto || ajuste != nil }
    private var errorPresentado: Binding<Bool> {
        Binding(
            get: { errorSeleccion != nil || store.mensajeError != nil },
            set: { if !$0 { errorSeleccion = nil; store.mensajeError = nil } }
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            ElementSheetHeader(icono: .retrato, subtitulo: "RECUERDOS EN TU ALTAR", titulo: "Tus fotografías.")
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 8)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ConfiguracionMarcosView(store: store, marcoElegido: $marcoElegido, bloqueado: ocupado)
                    tarjeta(marcoElegido)
                    Label("Las fotos se guardan en este teléfono.", systemImage: "iphone")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.secondaryText)
                    if ocupado {
                        ProgressView("Preparando fotografía…")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(24)
            }.recortaIlustraciones()
        }
        .background(AppTheme.background.ignoresSafeArea())
        .ilustracionesOfrenda(activa: ajuste == nil && !pickerAbierto)
        .interactiveDismissDisabled(procesando)
        .photosPicker(isPresented: $pickerAbierto, selection: $pickerItem, matching: .images)
        .task {
            await store.cargar()
            if let marcoInicial, store.configuracion.visibles.contains(marcoInicial) { marcoElegido = marcoInicial }
            else { marcoElegido = store.configuracion.principal }
        }
        .task(id: pickerItem) {
            guard let item = pickerItem else { return }
            procesando = true
            let destino = marcoElegido
            defer { procesando = false; pickerItem = nil }
            do {
                guard let data = try await item.loadTransferable(type: Data.self) else {
                    errorSeleccion = "No se pudo abrir esa foto. Elige otra imagen."
                    return
                }
                let thumbnail = await Task.detached(priority: .userInitiated) {
                    PhotoProcessor.thumbnail(from: data)
                }.value
                try Task.checkCancellation()
                guard let thumbnail else {
                    errorSeleccion = "La imagen no se pudo leer. Intenta con otra fotografía."
                    return
                }
                ajuste = AjusteMarco(marco: destino, imagen: UIImage(cgImage: thumbnail))
            } catch is CancellationError { }
            catch {
                errorSeleccion = "No se pudo cargar la foto. Si está en iCloud, revisa tu conexión e intenta de nuevo."
            }
        }
        .sheet(item: $ajuste) { seleccion in
            AjusteFotoView(
                imagenOriginal: seleccion.imagen,
                onConfirmar: { imagen in
                    ajuste = nil
                    procesando = true
                    Task { @MainActor in
                        await store.guardar(imagen, en: seleccion.marco)
                        procesando = false
                    }
                },
                onCancelar: { ajuste = nil },
                aspectMarco: seleccion.marco.relacionAspecto,
                titulo: "Ajusta su foto.",
                subtitulo: "\(seleccion.marco.numero) · \(seleccion.marco.titulo)"
            )
            .ofrendaSheet(detents: [.large])
        }
        .alert("No se pudo completar", isPresented: errorPresentado) {
            Button("Entendido", role: .cancel) {
                errorSeleccion = nil
                store.mensajeError = nil
            }
        } message: {
            Text(errorSeleccion ?? store.mensajeError ?? "")
        }
    }

    private func tarjeta(_ marco: MarcoOfrenda) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(marco.numero) · \(marco.titulo)")
                .font(.headline).accessibilityAddTraits(.isHeader)
            Text(store.fotos[marco]?.esPredeterminada == true ? "Esta es la foto de ejemplo. Puedes cambiarla o ajustar su encuadre." : "Esta fotografía se muestra en la ofrenda y en su vista previa.")
                .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
            Button {
                marcoElegido = marco
                pickerAbierto = true
            } label: {
                Label("Elegir fotografía",
                      systemImage: "photo.on.rectangle")
                    .frame(maxWidth: .infinity)
            }
            .ofrendaPrimaryAction()
            .accessibilityLabel("Elegir foto del \(marco.titulo.lowercased())")
            if let foto = store.fotos[marco] {
                HStack {
                    Button("Ajustar encuadre") {
                        ajuste = AjusteMarco(marco: marco, imagen: foto.imagen)
                    }
                    .ofrendaSecondaryAction()
                    Spacer()
                    if !foto.esPredeterminada {
                        Button("Restablecer foto") {
                            procesando = true
                            Task { @MainActor in
                                await store.restablecer(marco)
                                procesando = false
                            }
                        }
                        .ofrendaSecondaryAction()
                    }
                }
            }
        }
        .padding(18)
        .ofrendaSurface()
        .disabled(ocupado)
    }

    private struct AjusteMarco: Identifiable {
        let id = UUID()
        let marco: MarcoOfrenda
        let imagen: UIImage
    }
}
