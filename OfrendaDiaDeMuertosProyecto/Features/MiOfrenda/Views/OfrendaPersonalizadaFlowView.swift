//
//  OfrendaPersonalizadaFlowView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI
import PhotosUI

struct OfrendaPersonalizadaFlowView: View {
    @Binding var personalizacion: PersonalizacionOfrenda
    let fotosMarcos: FotosMarcosStore
    var isActive = true
    let onSalir: () -> Void
    @State private var paso: PasoPersonalizacion = .retrato
    @State private var regresoDeFoto: PasoPersonalizacion = .retrato
    @State private var fotoEnAjuste: UIImage?
    @State private var pickerItem: PhotosPickerItem?
    @State private var pickerAbierto = false
    @State private var marcoDelAjuste: MarcoOfrenda = .izquierdo
    @State private var guardandoFoto = false

    var body: some View {
        ZStack {
            switch paso {
            case .retrato:
                PersonalizarRetratoView(
                    personalizacion: $personalizacion,
                    fotosMarcos: fotosMarcos,
                    onElegirFoto: abrirPicker,
                    onContinuar: { paso = .gustos },
                    onVolver: onSalir
                )
            case .ajusteFoto:
                if let imagen = fotoEnAjuste {
                    AjusteFotoView(
                        imagenOriginal: imagen,
                        onConfirmar: { ajustada in
                            guardandoFoto = true
                            Task { @MainActor in
                                if await fotosMarcos.guardar(ajustada, en: marcoDelAjuste) {
                                    personalizacion.foto = ajustada
                                    fotoEnAjuste = nil
                                    paso = regresoDeFoto
                                }
                                guardandoFoto = false
                            }
                        },
                        onCancelar: {
                            fotoEnAjuste = nil
                            paso = regresoDeFoto
                        },
                        aspectMarco: marcoDelAjuste.relacionAspecto,
                        subtitulo: marcoDelAjuste.titulo.uppercased()
                    )
                    .disabled(guardandoFoto)
                }
            case .gustos:
                GustosRecuerdosView(
                    personalizacion: $personalizacion,
                    onContinuar: { paso = .sugerencias },
                    onVolver: { paso = .retrato },
                    onSalir: onSalir
                )
            case .sugerencias:
                SugerenciasOfrendaView(
                    personalizacion: personalizacion,
                    onContinuar: { paso = .resultado },
                    onVolver: { paso = .gustos },
                    onSalir: onSalir
                )
            case .resultado:
                MiOfrendaFinalView(
                    personalizacion: $personalizacion,
                    fotosMarcos: fotosMarcos,
                    isActive: isActive,
                    onEditarGustos: { paso = .gustos },
                    onCambiarFoto: abrirPicker,
                    onVolver: { paso = .sugerencias }
                )
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.2), value: paso)
        .task {
            await fotosMarcos.cargar()
            sincronizarRetrato()
        }
        .onChange(of: fotosMarcos.configuracion) { _, _ in sincronizarRetrato() }
        .onChange(of: personalizacion.marcoRetrato) { _, _ in sincronizarRetrato() }
        .onChange(of: fotosMarcos.fotos[personalizacion.marcoRetrato]?.id) { _, _ in sincronizarRetrato() }
        .alert("No se pudo guardar el cambio", isPresented: Binding(
            get: { guardandoFoto == false && fotosMarcos.mensajeError != nil },
            set: { if !$0 { fotosMarcos.mensajeError = nil } }
        )) {
            Button("Entendido", role: .cancel) { fotosMarcos.mensajeError = nil }
        } message: { Text(fotosMarcos.mensajeError ?? "") }
        .photosPicker(isPresented: $pickerAbierto, selection: $pickerItem, matching: .images)
        .task(id: pickerItem) {
            guard let item = pickerItem,
                  let data = try? await item.loadTransferable(type: Data.self),
                  !Task.isCancelled else { return }
            let thumbnail = await Task.detached(priority: .userInitiated) {
                PhotoProcessor.thumbnail(from: data)
            }.value
            guard !Task.isCancelled, let thumbnail else { return }
            fotoEnAjuste = UIImage(cgImage: thumbnail, scale: 1, orientation: .up)
            paso = .ajusteFoto
            pickerItem = nil
        }
    }

    private func sincronizarRetrato() {
        if !fotosMarcos.configuracion.visibles.contains(personalizacion.marcoRetrato) {
            personalizacion.marcoRetrato = fotosMarcos.configuracion.principal
        }
        personalizacion.foto = fotosMarcos.fotos[personalizacion.marcoRetrato]?.imagen
    }

    private func abrirPicker() {
        marcoDelAjuste = personalizacion.marcoRetrato
        regresoDeFoto = paso
        pickerAbierto = true
    }
}
