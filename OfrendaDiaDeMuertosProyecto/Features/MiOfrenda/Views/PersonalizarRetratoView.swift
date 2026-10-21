//
//  PersonalizarRetratoView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct PersonalizarRetratoView: View {
    @Binding var personalizacion: PersonalizacionOfrenda
    let fotosMarcos: FotosMarcosStore
    let onElegirFoto: () -> Void
    let onEditarElementos: () -> Void
    let onContinuar: () -> Void
    let onVolver: () -> Void
    private var fotoActual: UIImage? { fotosMarcos.fotos[personalizacion.marcoRetrato]?.imagen }
    private var tieneFoto: Bool { fotoActual != nil }
    private var tieneNombre: Bool { !personalizacion.nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                FlowNavigationBar(onVolver: onVolver)
                VStack(alignment: .leading, spacing: 6) {
                    Text(tieneFoto && tieneNombre ? "UN RECUERDO CON NOMBRE" : "TU PROPIA OFRENDA")
                        .font(.caption.bold()).tracking(0.8)
                        .foregroundStyle(AppTheme.accent)
                    Text(tieneFoto && tieneNombre ? "Recordemos a \(personalizacion.nombre)." : "¿A quién quieres recordar?")
                        .font(.largeTitle.bold())
                }
                .padding(.horizontal, 24)
                Button(action: onEditarElementos) {
                    Label("Elegir elementos del modelo 3D", systemImage: "cube.transparent")
                        .frame(maxWidth: .infinity).padding(.vertical, 8)
                }
                .ofrendaSecondaryAction()
                .padding(.horizontal, 24)
                ConfiguracionMarcosView(store: fotosMarcos, marcoSugerido: personalizacion.marcoRetrato)
                    .padding(.horizontal, 24)
                Picker("Marco para su retrato", selection: $personalizacion.marcoRetrato) {
                    ForEach(fotosMarcos.configuracion.visibles) { marco in
                        Text(marco.titulo).tag(marco)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 24)
                Button(action: onElegirFoto) {
                    VStack(spacing: 14) {
                        if let foto = fotoActual {
                            Image(uiImage: foto)
                                .resizable().scaledToFill()
                                .frame(width: 144, height: 144 / personalizacion.marcoRetrato.relacionAspecto)
                                .clipShape(.rect(cornerRadius: 16))
                        } else {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 44, weight: .light))
                                .foregroundStyle(AppTheme.accent)
                        }
                        Text("Elegir foto para este marco")
                            .font(.headline)
                        if !tieneFoto {
                            Text("Su retrato será el centro de tu ofrenda.")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.secondaryText)
                        }
                    }
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .contentShape(.rect(cornerRadius: 24))
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 24))
                .padding(.horizontal, 24)
                VStack(alignment: .leading, spacing: 8) {
                    Text("SU NOMBRE")
                        .font(.caption.bold()).tracking(0.6)
                        .foregroundStyle(AppTheme.accent)
                    TextField("Escribe cómo le llamabas", text: $personalizacion.nombre)
                        .font(.title3)
                        .textInputAutocapitalization(.words)
                        .submitLabel(.done)
                }
                .padding(16)
                .ofrendaSurface(cornerRadius: 16)
                .padding(.horizontal, 24)
                Text("Este retrato se comparte con la pantalla principal y la vista previa. Puedes conservar la foto de ejemplo o elegir la tuya.")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
                    .padding(.horizontal, 24)
                Button {
                    if tieneFoto { onContinuar() } else { onElegirFoto() }
                } label: {
                    Text(tieneFoto ? "Añadir gustos y recuerdos" : "Añadir una fotografía")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .ofrendaPrimaryAction()
                .disabled(tieneFoto && !tieneNombre)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .background(AppTheme.background.ignoresSafeArea())
    }
}
