//
//  PlantillaTarjetaElementoView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct PlantillaTarjetaElementoView: View {
    let icono: IlustracionOfrenda
    let subtituloCabecera: String
    let nombreElemento: String

    // Pestaña 1: Historia
    let tituloHistoria: String
    let parrafoHistoria1: String
    let parrafoHistoria2: String
    let preguntaReflexion: String

    // Pestaña 2: Significado
    let tituloSignificado: String
    let parrafoSignificado1: String
    let subtituloSignificado2: String
    let parrafoSignificado2: String
    let notaSignificado: String

    // Pestaña 3: Indagar (Línea del tiempo y fuentes)
    let hitos: [HitoHistorico]
    var textoBotonCerrar: String = "Volver a la ofrenda"

    @Environment(\.dismiss) private var dismiss
    @State private var seccionActiva = 0
    @State private var mostrarFuentes = false
    private let colorAcento = AppTheme.accent
    private let colorTextoSecundario = AppTheme.secondaryText

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ElementSheetHeader(icono: icono, subtitulo: subtituloCabecera, titulo: nombreElemento)
            SheetSectionPicker(secciones: ["Historia", "Significado", "Indagar"], seleccion: $seccionActiva)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if seccionActiva == 0 {
                        // HISTORIA
                        Text(tituloHistoria)
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text(parrafoHistoria1)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                        Text(parrafoHistoria2)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                        Divider().background(Color.white.opacity(0.12)).padding(.vertical, 4)

                        Text(preguntaReflexion)
                            .font(.footnote.weight(.medium))
                            .foregroundColor(colorAcento)

                    } else if seccionActiva == 1 {
                        // SIGNIFICADO
                        Text(tituloSignificado)
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text(parrafoSignificado1)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                        Text(subtituloSignificado2)
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .padding(.top, 4)

                        Text(parrafoSignificado2)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                        Divider().background(Color.white.opacity(0.12)).padding(.vertical, 4)

                        Text(notaSignificado)
                            .font(.footnote)
                            .foregroundColor(colorTextoSecundario)

                    } else {
                        // INDAGAR (Línea del tiempo)
                        Text("Su camino hasta el altar")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        VStack(spacing: 12) {
                            ForEach(hitos) { hito in
                                TarjetaHitoTimeline(hito: hito) {
                                    mostrarFuentes = true
                                }
                            }
                        }

                        Button {
                            mostrarFuentes = true
                        } label: {
                            HStack {
                                Text("Ver fuentes documentales")
                                    .font(.footnote.weight(.bold))
                                Image(systemName: "arrow.right")
                                    .font(.caption.weight(.bold))
                            }
                            .foregroundColor(colorAcento)
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(.glass)

                        if let vinculo = TradicionesCatalog.vinculo(para: nombreElemento) {
                            TarjetaLugarView(lugar: vinculo.lugar, contexto: vinculo.contexto)
                            Text(vinculo.lugar.avisoVisita)
                                .font(.footnote).foregroundStyle(AppTheme.secondaryText)
                        }
                    }

                }
                .padding(.top, 4)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Button { dismiss() } label: {
                Text(textoBotonCerrar)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .ofrendaPrimaryAction()
        }
        .padding(24)
        .sheet(isPresented: $mostrarFuentes) {
            VistaFuentesElemento(nombreElemento: nombreElemento, hitos: hitos)
                .ofrendaSheet()
        }
    }
}
