//
//  OfrendaPersonalizadaFlowView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Victor Flores on 16/10/26.
//

import SwiftUI
import PhotosUI

struct OfrendaPersonalizadaFlowView: View {
    @Binding var personalizacion: PersonalizacionOfrenda
    let onSalir: () -> Void   // volver a la ofrenda principal

    @State private var paso: PasoPersonalizacion = .retrato
    @State private var fotoEnAjuste: UIImage?
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        ZStack {
            switch paso {
            case .retrato:
                PersonalizarRetratoView(
                    personalizacion: $personalizacion,
                    onElegirFoto: { abrirPicker() },
                    onContinuar:  { paso = .gustos },
                    onVolver:     { onSalir() }
                )
                .transition(.opacity)

            case .ajusteFoto:
                if let imagen = fotoEnAjuste {
                    AjusteFotoView(
                        imagenOriginal: imagen,
                        onConfirmar: { ajustada in
                            personalizacion.foto = ajustada
                            fotoEnAjuste = nil
                            paso = .retrato
                        },
                        onCancelar: {
                            fotoEnAjuste = nil
                            paso = .retrato
                        }
                    )
                    .transition(.opacity)
                }

            case .gustos:
                GustosRecuerdosView(
                    personalizacion: $personalizacion,
                    onContinuar: { paso = .sugerencias },
                    onVolver:    { paso = .retrato }
                )
                .transition(.opacity)

            case .sugerencias:
                SugerenciasOfrendaView(
                    personalizacion: personalizacion,
                    onContinuar: { paso = .resultado },
                    onVolver:    { paso = .gustos }
                )
                .transition(.opacity)

            case .resultado:
                MiOfrendaFinalView(
                    personalizacion: $personalizacion,
                    onEditarGustos: { paso = .gustos },
                    onCambiarFoto:  { abrirPicker() },
                    onVolver:       { paso = .sugerencias }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: paso)
        .photosPicker(isPresented: .constant(false), selection: $pickerItem) // no-op, usamos la del sistema directa
        .onChange(of: pickerItem) { _, nuevo in
            Task {
                guard let data = try? await nuevo?.loadTransferable(type: Data.self),
                      let img = UIImage(data: data) else { return }
                await MainActor.run {
                    fotoEnAjuste = img
                    paso = .ajusteFoto
                }
            }
        }
        .background(pickerAnfitrion)
    }

    // Truco: usamos un PhotosPicker invisible como anfitrión para disparar el sistema.
    @State private var pickerAbierto = false
    private var pickerAnfitrion: some View {
        PhotosPicker(selection: $pickerItem, matching: .images, photoLibrary: .shared()) {
            EmptyView()
        }
        .opacity(0)
        .allowsHitTesting(false)
        .frame(width: 0, height: 0)
        .photosPicker(isPresented: $pickerAbierto, selection: $pickerItem, matching: .images)
    }

    private func abrirPicker() { pickerAbierto = true }
}
