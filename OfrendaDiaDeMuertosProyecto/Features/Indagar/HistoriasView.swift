//
//  HistoriasView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//

import SwiftUI

struct HistoriasView: View {
    let elementos: [ElementoOfrenda]
    @Binding var elementosVisitados: Set<String>
    @Binding var elementoSeleccionado: ElementoOfrenda?

    let colorTarjeta = Color(red: 0.21, green: 0.13, blue: 0.30)
    let colorAcento = Color(red: 0.96, green: 0.65, blue: 0.25)
    let colorTextoSecundario = Color(red: 0.78, green: 0.75, blue: 0.84)

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                // Encabezado de la sección Historias (según Figma)
                VStack(alignment: .leading, spacing: 6) {
                    Text("APRENDER CON CONTEXTO")
                        .font(.caption.weight(.bold))
                        .tracking(0.8)
                        .foregroundColor(colorAcento)

                    Text("Historias de la ofrenda.")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)

                    Text("Explora el origen, el significado y la línea del tiempo documentada de cada elemento del altar.")
                        .font(.subheadline)
                        .foregroundColor(colorTextoSecundario)
                        .lineSpacing(2)
                }
                .padding(.top, 6)

                // Lista de tarjetas de los 8 elementos
                VStack(spacing: 12) {
                    ForEach(elementos) { elemento in
                        Button {
                            elementosVisitados.insert(elemento.nombre)
                            elementoSeleccionado = elemento
                        } label: {
                            HStack(spacing: 14) {
                                Text(elemento.icono)
                                    .font(.title2)
                                    .frame(width: 48, height: 48)
                                    .background(
                                        Circle()
                                            .fill(Color.black.opacity(0.25))
                                    )

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 6) {
                                        Text(elemento.nombre)
                                            .font(.headline.weight(.bold))
                                            .foregroundColor(.white)

                                        if elementosVisitados.contains(elemento.nombre) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.caption)
                                                .foregroundColor(colorAcento)
                                        }
                                    }

                                    Text(elemento.tituloHistoria)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(colorAcento)

                                    Text(elemento.descripcionHistoria)
                                        .font(.caption)
                                        .foregroundColor(colorTextoSecundario)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.subheadline.weight(.bold))
                                    .foregroundColor(colorAcento)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(colorTarjeta.opacity(0.82))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .stroke(
                                                elementosVisitados.contains(elemento.nombre) ? colorAcento.opacity(0.45) : Color.white.opacity(0.08),
                                                lineWidth: 1
                                            )
                                    )
                            )
                        }
                    }
                }
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 24)
        }
    }
}
