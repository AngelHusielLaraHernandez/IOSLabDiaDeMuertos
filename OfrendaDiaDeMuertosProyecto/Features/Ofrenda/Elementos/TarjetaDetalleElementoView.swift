//
//  TarjetaDetalleElementoView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//

import SwiftUI

// MARK: - Modelos de apoyo para la pestaña "Indagar" y "Fuentes"
struct HitoHistorico: Identifiable {
    let id = UUID()
    let epoca: String
    let titulo: String
    let descripcion: String
    let colorPunto: Color
    let fuentes: [FuenteDocumental]
}

struct FuenteDocumental: Identifiable {
    let id = UUID()
    let periodo: String
    let titulo: String
    let detalle: String
    let referencia: String
}

// MARK: - Router Principal (Se llama desde Ofrenda 3D y desde Historias)
struct TarjetaDetalleElementoView: View {
    let elemento: ElementoOfrenda
    let colorFondo: Color
    let colorTarjeta: Color
    let colorAcento: Color
    var textoBotonCerrar: String = "Volver a la ofrenda"

    var body: some View {
        switch elemento.nombre {
        case "Flores", "Cempasúchil":
            FloresView(textoBotonCerrar: textoBotonCerrar)
        case "Velas":
            VelasView(textoBotonCerrar: textoBotonCerrar)
        case "Agua y sal":
            AguaYSalView(textoBotonCerrar: textoBotonCerrar)
        case "Pan", "Pan de muerto":
            PanDeMuertoView(textoBotonCerrar: textoBotonCerrar)
        case "Comida":
            ComidaView(textoBotonCerrar: textoBotonCerrar)
        case "Retrato":
            RetratoView(textoBotonCerrar: textoBotonCerrar)
        case "Papel", "Papel picado":
            PapelView(textoBotonCerrar: textoBotonCerrar)
        case "Calaveritas":
            CalaveritasView(textoBotonCerrar: textoBotonCerrar)
        default:
            FloresView(textoBotonCerrar: textoBotonCerrar)
        }
    }
}

// MARK: - Plantilla Estándar para los Elementos (Historia | Significado | Indagar)
struct PlantillaTarjetaElementoView: View {
    let icono: String
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
    @State private var seccionActiva: Int = 0
    @State private var mostrarFuentes: Bool = false

    let secciones = ["Historia", "Significado", "Indagar"]
    let colorFondo = Color(red: 0.11, green: 0.05, blue: 0.18)
    let colorTarjeta = Color(red: 0.21, green: 0.13, blue: 0.30)
    let colorAcento = Color(red: 0.96, green: 0.65, blue: 0.25)
    let colorTextoSecundario = Color(red: 0.78, green: 0.75, blue: 0.84)

    var body: some View {
        ZStack {
            colorFondo.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                // Cabecera
                HStack(spacing: 12) {
                    Text(icono)
                        .font(.title2)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(colorTarjeta))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(subtituloCabecera.uppercased())
                            .font(.system(size: 10, weight: .bold))
                            .tracking(0.6)
                            .foregroundColor(colorAcento)
                        Text(nombreElemento)
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(.white.opacity(0.75))
                            .padding(9)
                            .background(Circle().fill(colorTarjeta))
                    }
                }

                // Selector de pestañas
                HStack(spacing: 8) {
                    ForEach(0..<secciones.count, id: \.self) { idx in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                seccionActiva = idx
                            }
                        } label: {
                            Text(secciones[idx])
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(seccionActiva == idx ? .black : .white.opacity(0.85))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule().fill(seccionActiva == idx ? colorAcento : colorTarjeta)
                                )
                        }
                    }
                }

                // Contenido desplazable según la pestaña activa
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 14) {
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
                                    TarjetaHitoTimeline(
                                        hito: hito,
                                        colorTarjeta: colorTarjeta,
                                        colorAcento: colorAcento
                                    ) {
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
                                .padding(.top, 4)
                            }
                        }
                    }
                    .padding(.top, 4)
                }

                // Botón inferior naranja
                Button { dismiss() } label: {
                    Text(textoBotonCerrar)
                        .font(.headline.weight(.bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(colorAcento)
                        )
                }
            }
            .padding(24)
        }
        .sheet(isPresented: $mostrarFuentes) {
            VistaFuentesElemento(
                nombreElemento: nombreElemento,
                hitos: hitos,
                colorFondo: colorFondo,
                colorTarjeta: colorTarjeta,
                colorAcento: colorAcento
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Subvista de cada Hito en la pestaña "Indagar"
struct TarjetaHitoTimeline: View {
    let hito: HitoHistorico
    let colorTarjeta: Color
    let colorAcento: Color
    let onVerFuentes: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(hito.colorPunto)
                .frame(width: 10, height: 10)
                .padding(.top, 6)

            VStack(alignment: .leading, spacing: 4) {
                Text(hito.epoca.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .tracking(0.5)
                    .foregroundColor(colorAcento)

                Text(hito.titulo)
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.white)

                Text(hito.descripcion)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.82))
                    .lineSpacing(2)

                Button(action: onVerFuentes) {
                    Text("Ver fuentes (\(hito.fuentes.count)) →")
                        .font(.caption2.weight(.bold))
                        .foregroundColor(colorAcento)
                        .padding(.top, 2)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(colorTarjeta.opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

// MARK: - Modal de Fuentes Consultables (Figma: "Fuentes para la línea de tiempo")
struct VistaFuentesElemento: View {
    let nombreElemento: String
    let hitos: [HitoHistorico]
    let colorFondo: Color
    let colorTarjeta: Color
    let colorAcento: Color

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            colorFondo.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Button { dismiss() } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Volver")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(colorAcento)
                }

                Text("FUENTES PARA LA LÍNEA DE TIEMPO")
                    .font(.caption.weight(.bold))
                    .tracking(0.8)
                    .foregroundColor(colorAcento)

                Text(nombreElemento)
                    .font(.title.weight(.bold))
                    .foregroundColor(.white)

                Text("Se diferencian antecedentes, contextos históricos, registros documentados y usos actuales. Las prácticas cambian entre regiones y familias.")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.75))

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(hitos.flatMap { $0.fuentes }) { fuente in
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(fuente.periodo) · \(fuente.titulo)")
                                    .font(.subheadline.weight(.bold))
                                    .foregroundColor(colorAcento)

                                Text(fuente.detalle)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.88))
                                    .lineSpacing(3)

                                Text("Referencia: \(fuente.referencia)")
                                    .font(.caption2.weight(.semibold))
                                    .foregroundColor(.white.opacity(0.6))
                                    .padding(.top, 2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(colorTarjeta)
                            )
                        }
                    }
                }

                Button { dismiss() } label: {
                    Text("Volver a la ofrenda")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(RoundedRectangle(cornerRadius: 16).fill(colorAcento))
                }
            }
            .padding(24)
        }
    }
}
