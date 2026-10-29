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
    let renderSession: OfrendaRenderSession
    let fotosMarcos: FotosMarcosStore
    let elementosStore: ElementosOfrendaStore
    var isActive = true
    let onSalir: () -> Void
    var onGuardar: (() -> Void)? = nil
    

    @Environment(\.dismiss) private var dismiss
    
    @State private var paso: PasoPersonalizacion = .retrato
    @State private var regresoDeFoto: PasoPersonalizacion = .retrato
    @State private var fotoEnAjuste: UIImage?
    @State private var pickerItem: PhotosPickerItem?
    @State private var pickerAbierto = false
    @State private var marcoDelAjuste: MarcoOfrenda = .izquierdo
    @State private var guardandoFoto = false
    @State private var fotosPendientes: [MarcoOfrenda: UIImage] = [:]
    @State private var nombresOriginales: [MarcoOfrenda: String] = [:]
    @State private var identidadCargada = false

    var body: some View {
        ZStack {
            switch paso {
            case .retrato:
                PersonalizarRetratoView(
                    personalizacion: $personalizacion,
                    fotosMarcos: fotosMarcos,
                    onElegirFoto: abrirPicker,
                    onContinuar: { paso = .gustos },
                    nombresOriginales: nombresOriginales
                )
            case .ajusteFoto:
                if let imagen = fotoEnAjuste {
                    AjusteFotoView(
                        imagenOriginal: imagen,
                        onConfirmar: { ajustada in
                            fotosPendientes[marcoDelAjuste] = ajustada
                            fotosMarcos.previsualizar(ajustada, en: marcoDelAjuste)
                            fotoEnAjuste = nil
                            paso = regresoDeFoto
                        },
                        onCancelar: { fotoEnAjuste = nil; paso = regresoDeFoto },
                        aspectMarco: marcoDelAjuste.relacionAspecto,
                        subtitulo: marcoDelAjuste.titulo.uppercased()
                    )
                    .disabled(guardandoFoto)
                }
            case .gustos:
                GustosRecuerdosView(
                    personalizacion: $personalizacion,
                    elementosStore: elementosStore,
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
            case .elementos:
                GustosRecuerdosView(
                    personalizacion: $personalizacion,
                    elementosStore: elementosStore,
                    onContinuar: { paso = .resultado },
                    onVolver: { paso = .gustos },
                    onSalir: onSalir
                )
            case .resultado:
                MiOfrendaFinalView(
                    personalizacion: $personalizacion,
                    renderSession: renderSession,
                    fotosMarcos: fotosMarcos,
                    elementosStore: elementosStore,
                    isActive: isActive,
                    onEditarGustos: { paso = .gustos },
                    onCambiarFoto: { paso = .retrato },
                    onVolver: { paso = .sugerencias },
                    onTerminar: { 
                        dismiss()
                        (onGuardar ?? onSalir)()
                    },
                    nombresOriginales: nombresOriginales,
                    fotosPendientes: fotosPendientes
                )
            }
        }
        .navigationBarBackButtonHidden(paso != .retrato)
        .navigationBarTitleDisplayMode(.inline)
        .background(AppTheme.background.ignoresSafeArea())
        .ilustracionesOfrenda(activa: isActive && !pickerAbierto && paso != .ajusteFoto)
        .animation(paso == .elementos || paso == .resultado ? nil : .easeInOut(duration: 0.2), value: paso)
        .task {
            await fotosMarcos.cargar()
            if !identidadCargada {
                let configuracion = personalizacion.configuracionInicial(desde: fotosMarcos.configuracion)
                personalizacion.aplicarRetratos(configuracion)
                nombresOriginales = Dictionary(uniqueKeysWithValues: MarcoOfrenda.allCases.map { ($0, configuracion.persona(en: $0).nombre) })
                identidadCargada = true
            }
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
        let configuracion = personalizacion.retratos ?? fotosMarcos.configuracion
        if !configuracion.visibles.contains(personalizacion.marcoRetrato) {
            personalizacion.marcoRetrato = configuracion.principal
        }
    }

    private func abrirPicker() {
        let marco = personalizacion.marcoRetrato
        guard IdentidadRetrato.permiteReemplazar(nombreAnterior: nombresOriginales[marco] ?? "",
            nombreNuevo: personalizacion.retratos?.persona(en: marco).nombre ?? personalizacion.nombre,
            esPredeterminada: fotosMarcos.esPredeterminadaGuardada(marco)) else { paso = .retrato; return }
        marcoDelAjuste = personalizacion.marcoRetrato
        regresoDeFoto = paso
        pickerAbierto = true
    }
}
