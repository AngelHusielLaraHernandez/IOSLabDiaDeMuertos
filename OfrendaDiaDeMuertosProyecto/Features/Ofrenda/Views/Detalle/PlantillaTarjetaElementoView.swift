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

    // Mapa precede a Conocer más, que reúne la línea del tiempo y las fuentes.
    let hitos: [HitoHistorico]
    var textoBotonCerrar: String = "Volver a la ofrenda"

    @Environment(\.dismiss) private var dismiss
    @State private var seccionActiva = 0
    @State private var mostrarFuentes = false
    private let colorAcento = AppTheme.accent
    private let colorTextoSecundario = AppTheme.secondaryText

    private var textoLectura: String {
        switch seccionActiva {
        case 0: TextoLecturaOfrenda.unir([nombreElemento, tituloHistoria, parrafoHistoria1, parrafoHistoria2, preguntaReflexion])
        case 1: TextoLecturaOfrenda.unir([nombreElemento, tituloSignificado, parrafoSignificado1, subtituloSignificado2, parrafoSignificado2, notaSignificado])
        case 2: TextoLecturaOfrenda.mapa(para: nombreElemento)
        default: TextoLecturaOfrenda.cronologia("Su camino hasta el altar", hitos: hitos)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ElementSheetHeader(icono: icono, subtitulo: subtituloCabecera, titulo: nombreElemento)
            SheetSectionPicker(secciones: ["Historia", "Significado", "Mapa", "Conocer más"], seleccion: $seccionActiva)
                .objetivoGuiaContextual("ficha.secciones")
            ControlLecturaView(texto: textoLectura, suspendida: mostrarFuentes)
                .objetivoGuiaContextual("ficha.voz")
            SheetReadingContent {
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

                    } else if seccionActiva == 2 {
                        MapaElementoView(nombreElemento: nombreElemento)
                    } else {
                        // CONOCER MÁS (Línea del tiempo)
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

                    }

                }
                .padding(.top, 4)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Button { dismiss() } label: {
                Text(textoBotonCerrar)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .ofrendaPrimaryAction().objetivoGuiaContextual("hoja.cerrar")
        }
        .padding(24)
        .sheet(isPresented: $mostrarFuentes) {
            VistaFuentesElemento(nombreElemento: nombreElemento, hitos: hitos)
                .ofrendaSheet()
        }
    }
}
