//
//  Calaveritas.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//

import SwiftUI

struct CalaveritasView: View {
    var textoBotonCerrar: String = "Volver a la ofrenda"

    @Environment(\.dismiss) private var dismiss
    @State private var seccionActiva: Int = 0
    @State private var mostrarFuentes: Bool = false

    // En Figma, Calaveritas tiene 4 pestañas: Literaria, De azúcar, Historia e Indagar
    let secciones = ["Literaria", "De azúcar", "Historia", "Indagar"]
    let colorFondo = Color(red: 0.11, green: 0.05, blue: 0.18)
    let colorTarjeta = Color(red: 0.21, green: 0.13, blue: 0.30)
    let colorAcento = Color(red: 0.96, green: 0.65, blue: 0.25)
    let colorTextoSecundario = Color(red: 0.78, green: 0.75, blue: 0.84)

    let hitos: [HitoHistorico] = [
        HitoHistorico(
            epoca: "Antecedente histórico",
            titulo: "Alfeñique y figuras de azúcar",
            descripcion: "Técnica confitera que dio forma a pequeñas calaveras decoradas con colores vegetales y nombres en la frente.",
            colorPunto: .yellow,
            fuentes: [
                FuenteDocumental(periodo: "Siglo XVIII", titulo: "Dulcería y alfeñique", detalle: "Tradición de figuras de pasta de azúcar en ferias como la de Toluca y Oaxaca.", referencia: "Museo del Alfeñique")
            ]
        ),
        HitoHistorico(
            epoca: "Siglo XIX",
            titulo: "Versos satíricos e impresos",
            descripcion: "Los periódicos y hojas volantes popularizaron las calaveritas literarias acompañadas de grabados de José Guadalupe Posada.",
            colorPunto: .orange,
            fuentes: [
                FuenteDocumental(periodo: "1849 - 1913", titulo: "Panteones literarios", detalle: "Primeros registros impresos en el periódico El Socialista y grabados populares.", referencia: "Hemeroteca Nacional de México")
            ]
        ),
        HitoHistorico(
            epoca: "Tradición actual",
            titulo: "Dulzura e ingenio para recordar",
            descripcion: "Tanto en dulce como en rima, las calaveritas celebran la vida de nuestros seres queridos con una sonrisa.",
            colorPunto: .purple,
            fuentes: [
                FuenteDocumental(periodo: "Actualidad", titulo: "Calaveritas en la ofrenda", detalle: "Concursos literarios y ferias del alfeñique en todo México.", referencia: "Acervo de Tradiciones Mexicanas")
            ]
        )
    ]

    var body: some View {
        ZStack {
            colorFondo.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                // Cabecera
                HStack(spacing: 12) {
                    Text("💀")
                        .font(.title2)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(colorTarjeta))

                    VStack(alignment: .leading, spacing: 2) {
                        Text("VERSOS Y DULCES")
                            .font(.system(size: 10, weight: .bold))
                            .tracking(0.6)
                            .foregroundColor(colorAcento)
                        Text("Calaveritas")
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

                // Selector de las 4 pestañas de Calaveritas
                HStack(spacing: 6) {
                    ForEach(0..<secciones.count, id: \.self) { idx in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                seccionActiva = idx
                            }
                        } label: {
                            Text(secciones[idx])
                                .font(.caption.weight(.semibold))
                                .foregroundColor(seccionActiva == idx ? .black : .white.opacity(0.85))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule().fill(seccionActiva == idx ? colorAcento : colorTarjeta)
                                )
                        }
                    }
                }

                // Contenido según pestaña
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 14) {
                        if seccionActiva == 0 {
                            // LITERARIA (Texto exacto de tu captura de Figma)
                            Text("La Calaca jardinera")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white)

                            Text("La Calaca fue al jardín\ncon su lista y su sombrero;\ndijo: «Aquí vengo por fin,\npero riego lo primero».")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(5)
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(RoundedRectangle(cornerRadius: 14).fill(colorTarjeta.opacity(0.6)))

                            Text("Entre flores y alegría,\nse olvidó de su misión;\ny al llegar el nuevo día,\nse marchó con un botón.")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(5)
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(RoundedRectangle(cornerRadius: 14).fill(colorTarjeta.opacity(0.6)))

                            Text("Las calaveritas literarias recuerdan con humor, rima y afecto las aficiones de quienes queremos.")
                                .font(.footnote)
                                .foregroundColor(colorTextoSecundario)

                        } else if seccionActiva == 1 {
                            // DE AZÚCAR
                            Text("Dulzura con nombre propio")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white)

                            Text("Elaboradas con azúcar, amaranto o chocolate, las calaveritas decoradas con alfeñique de colores nos invitan a mirar la muerte con cercanía y dulzura.")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.88))
                                .lineSpacing(4)

                            Text("Un detalle lleno de cariño")
                                .font(.headline.weight(.bold))
                                .foregroundColor(.white)
                                .padding(.top, 4)

                            Text("Llevan escrito un nombre en la frente y se colocan en el altar o se regalan entre familiares y amigos como símbolo de afecto y memoria.")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.88))
                                .lineSpacing(4)

                        } else if seccionActiva == 2 {
                            // HISTORIA
                            Text("¿De dónde vienen?")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white)

                            Text("Recordar con una sonrisa es parte esencial del Día de Muertos. Desde el periodo virreinal hasta los impresos del siglo XIX, el arte popular transformó la figura de la calavera en verso y dulce.")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.88))
                                .lineSpacing(4)

                            Text("Así, las familias mexicanas entrelazan el alfeñique artesanal con los versos rimados que celebran las anécdotas de cada persona.")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.88))
                                .lineSpacing(4)

                        } else {
                            // INDAGAR
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
                        }
                    }
                    .padding(.top, 4)
                }

                Button { dismiss() } label: {
                    Text(textoBotonCerrar)
                        .font(.headline.weight(.bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(RoundedRectangle(cornerRadius: 16).fill(colorAcento))
                }
            }
            .padding(24)
        }
        .sheet(isPresented: $mostrarFuentes) {
            VistaFuentesElemento(
                nombreElemento: "Calaveritas",
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
