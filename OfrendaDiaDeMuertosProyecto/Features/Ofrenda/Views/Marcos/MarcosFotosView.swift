//
//  MarcosFotosView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 17/10/26.
//

import SwiftUI
import PhotosUI


struct MarcosFotosView: View {
    @Environment(\.dismiss) private var dismiss
    let store: FotosMarcosStore
    var marcoInicial: MarcoOfrenda?
    var perfilInicial: PersonalizacionOfrenda? = nil
    var onGuardarIdentidad: ((ConfiguracionMarcos) -> Bool)? = nil
    @State private var borrador = ConfiguracionMarcos()
    @State private var nombresOriginales: [MarcoOfrenda: String] = [:]
    @State private var fotosPendientes: [MarcoOfrenda: UIImage] = [:]
    @State private var cargado = false
    @State private var marcoElegido: MarcoOfrenda = .izquierdo
    @State private var pickerAbierto = false
    @State private var pickerItem: PhotosPickerItem?
    @State private var ajuste: AjusteMarco?
    @State private var procesando = false
    @State private var confirmando = false
    @State private var errorSeleccion: String?

    private var ocupado: Bool { !cargado || confirmando || procesando || store.cargando || store.guardandoConfiguracion || pickerAbierto || ajuste != nil }
    private var errorPresentado: Binding<Bool> {
        Binding(
            get: { errorSeleccion != nil || store.mensajeError != nil },
            set: { if !$0 { errorSeleccion = nil; store.mensajeError = nil } }
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            ElementSheetHeader(icono: .retrato, subtitulo: "RECUERDOS EN TU ALTAR", titulo: "Tus fotografías.",
                               onGuardar: guardarYCerrar, guardarDeshabilitado: ocupado || (store.requiereIdentidad && borrador.errorIdentidad != nil))
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 8)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ConfiguracionMarcosView(store: store, marcoElegido: $marcoElegido, bloqueado: ocupado,
                                            borrador: $borrador, fotosProvisionales: fotosPendientes)
                    if store.requiereIdentidad { DatosRetratosView(configuracion: $borrador, marcoSeleccionado: marcoElegido, mostrarErrorGlobal: true).disabled(ocupado) }
                    tarjeta(marcoElegido)
                    Label("Las fotos se guardan en este teléfono.", systemImage: "iphone")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.secondaryText)
                    if ocupado {
                        ProgressView(confirmando ? "Guardando cambios…" : "Preparando fotografía…")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(24)
            }.recortaIlustraciones()
        }
        .background(AppTheme.background.ignoresSafeArea())
        .guiaContextual(store.requiereIdentidad ? .marcos : .marcosGeneral)
        .ilustracionesOfrenda(activa: ajuste == nil && !pickerAbierto)
        .interactiveDismissDisabled(ocupado)
        .photosPicker(isPresented: $pickerAbierto, selection: $pickerItem, matching: .images)
        .task {
            await store.cargar()
            guard !cargado else { return }
            borrador = store.configuracion.personas.isEmpty ? (perfilInicial?.configuracionInicial(desde: store.configuracion) ?? store.configuracion) : store.configuracion
            // El manifiesto del almacén es la autoridad para las imágenes publicadas.
            borrador.archivosFotos = store.configuracion.archivosFotos
            nombresOriginales = Dictionary(uniqueKeysWithValues: MarcoOfrenda.allCases.map { ($0, borrador.persona(en: $0).nombre) })
            if let marcoInicial, borrador.visibles.contains(marcoInicial) { marcoElegido = marcoInicial }
            else { marcoElegido = borrador.principal }
            cargado = true
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
                    fotosPendientes[seleccion.marco] = imagen
                    ajuste = nil
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

    private func guardarYCerrar() {
        guard !ocupado else { return }
        confirmando = true
        Task { @MainActor in
            defer { confirmando = false }
            guard !store.requiereIdentidad || borrador.errorIdentidad == nil else { errorSeleccion = borrador.errorIdentidad; return }
            guard fotosPendientes.keys.allSatisfy({ permiteReemplazar($0) }) else {
                errorSeleccion = "Para reemplazar la fotografía también debes cambiar el nombre de esa persona."
                return
            }
            if await store.guardarCambios(borrador, imagenes: fotosPendientes, nombresAnteriores: nombresOriginales) {
                guard onGuardarIdentidad?(store.configuracion) ?? true else {
                    errorSeleccion = "Las fotos están guardadas. Vuelve a pulsar Guardar para actualizar los datos de la ofrenda."
                    return
                }
                dismiss()
            }
        }
    }

    private func tarjeta(_ marco: MarcoOfrenda) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(marco.numero) · \(marco.titulo)")
                .font(.headline).accessibilityAddTraits(.isHeader)
            Text(store.fotos[marco]?.esPredeterminada == true ? (store.requiereIdentidad ? "Esta es la foto de ejemplo. Escribe un nombre para elegir su fotografía." : "Esta es la foto de ejemplo. Puedes elegir otra fotografía o ajustar su encuadre.") : "Esta fotografía se muestra en la ofrenda y en su vista previa.")
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
            .objetivoGuiaContextual("marcos.fotografia")
            .disabled(!permiteReemplazar(marco))
            if !permiteReemplazar(marco) {
                Text("Para reemplazar esta fotografía, cambia también el nombre de la persona en este marco.")
                    .font(.footnote).foregroundStyle(AppTheme.accent)
            }
            if let imagen = fotosPendientes[marco] ?? store.fotos[marco]?.imagen {
                Button("Ajustar encuadre") {
                    ajuste = AjusteMarco(marco: marco, imagen: imagen)
                }
                .ofrendaSecondaryAction()
                .disabled(!permiteReemplazar(marco))
            }
        }
        .padding(18)
        .ofrendaSurface()
        .disabled(ocupado)
    }

    private func permiteReemplazar(_ marco: MarcoOfrenda) -> Bool {
        !store.requiereIdentidad || IdentidadRetrato.permiteReemplazar(nombreAnterior: nombresOriginales[marco] ?? "",
            nombreNuevo: borrador.persona(en: marco).nombre,
            esPredeterminada: store.fotos[marco]?.esPredeterminada != false)
    }

    private struct AjusteMarco: Identifiable {
        let id = UUID()
        let marco: MarcoOfrenda
        let imagen: UIImage
    }
}
