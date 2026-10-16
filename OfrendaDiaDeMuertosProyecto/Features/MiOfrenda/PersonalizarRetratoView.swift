//
//  ersonalizarRetratoView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Victor Flores on 16/10/26.
//

import SwiftUI
import PhotosUI

struct PersonalizarRetratoView: View {
    @Binding var personalizacion: PersonalizacionOfrenda
    let onElegirFoto: () -> Void
    let onContinuar: () -> Void
    let onVolver: () -> Void

    @FocusState private var nombreFocus: Bool

    private let colorFondo = Color(red: 0.11, green: 0.05, blue: 0.18)
    private let colorTarjeta = Color(red: 0.21, green: 0.13, blue: 0.30)
    private let colorAcento = Color(red: 0.96, green: 0.65, blue: 0.25)
    private let colorTextoSec = Color.white.opacity(0.7)

    private var tieneFoto: Bool { personalizacion.foto != nil }
    private var tieneNombre: Bool { !personalizacion.nombre.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button { onVolver() } label: {
                    Label("Volver", systemImage: "chevron.left")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(colorAcento)
                }
                Spacer()
                Button("Volver a la ofrenda") { onVolver() }
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(colorAcento)
            }
            .padding(.horizontal, 24).padding(.top, 12)

            // Encabezado dinámico
            VStack(alignment: .leading, spacing: 6) {
                Text(tieneFoto && tieneNombre ? "UN RECUERDO CON NOMBRE" : "TU PROPIA OFRENDA")
                    .font(.caption.weight(.bold)).tracking(0.8)
                    .foregroundColor(colorAcento)

                Text(tieneFoto && tieneNombre
                     ? "Recordemos a \(personalizacion.nombre)."
                     : "¿A quién quieres recordar?")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 24)

            // Tarjeta de foto
            Button {
                onElegirFoto()
            } label: {
                if let foto = personalizacion.foto {
                    VStack(spacing: 12) {
                        Image(uiImage: foto)
                            .resizable().scaledToFill()
                            .frame(width: 160, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1))
                        Text("Cambiar fotografía")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(colorAcento)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 20).fill(colorTarjeta.opacity(0.75))
                    )
                } else {
                    VStack(spacing: 14) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 52, weight: .light))
                            .foregroundColor(colorAcento)
                        Text("Elegir una fotografía")
                            .font(.headline).foregroundColor(colorAcento)
                        Text("Su retrato será el centro de tu ofrenda.")
                            .font(.subheadline).foregroundColor(colorTextoSec)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .background(
                        RoundedRectangle(cornerRadius: 20).fill(colorTarjeta.opacity(0.6))
                    )
                }
            }
            .padding(.horizontal, 24)

            // Campo de nombre
            VStack(alignment: .leading, spacing: 6) {
                Text("SU NOMBRE")
                    .font(.caption.weight(.bold)).tracking(0.6)
                    .foregroundColor(colorAcento)
                TextField("Escribe cómo le llamabas", text: $personalizacion.nombre)
                    .font(.title3).foregroundColor(.white)
                    .focused($nombreFocus)
                    .textInputAutocapitalization(.words)
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 16).fill(colorTarjeta.opacity(0.75)))
            .padding(.horizontal, 24)

            Text(tieneFoto
                 ? "Su foto acompañará la ofrenda. Ahora cuéntanos un poco sobre ella."
                 : "Empieza por su foto. Después podrás añadir los sabores y recuerdos que le gustaban.")
                .font(.subheadline).foregroundColor(colorTextoSec)
                .padding(.horizontal, 24)

            Spacer()

            Button {
                if tieneFoto && tieneNombre { onContinuar() }
                else { onElegirFoto() }
            } label: {
                Text(tieneFoto ? "Añadir gustos y recuerdos" : "Añadir una foto para continuar")
                    .font(.headline).foregroundColor(.black)
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(colorAcento, in: Capsule())
            }
            .disabled(!tieneFoto && !tieneNombre && false)   // siempre habilitado: abre picker
            .padding(.horizontal, 24).padding(.bottom, 24)
        }
        .background(colorFondo.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .onTapGesture { nombreFocus = false }
    }
}
