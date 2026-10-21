//
//  CalaveritasView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct CalaveritasView: View {
    var textoBotonCerrar = "Volver a la ofrenda"
    @Environment(\.dismiss) private var dismiss
    @State private var seccionActiva = 0
    @State private var mostrarFuentes = false
    private let colorTarjeta = AppTheme.surface
    private let colorAcento = AppTheme.accent
    private let colorTextoSecundario = AppTheme.secondaryText
    private let hitos = OfrendaCatalog.historiaCalaveritas

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ElementSheetHeader(icono: "💀", subtitulo: "Versos y dulces", titulo: "Calaveritas")
            SheetSectionPicker(secciones: ["Literaria", "De azúcar", "Historia", "Indagar"], seleccion: $seccionActiva)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
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
                                TarjetaHitoTimeline(hito: hito) {
                                    mostrarFuentes = true
                                }
                            }
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
            VistaFuentesElemento(nombreElemento: "Calaveritas", hitos: hitos)
                .ofrendaSheet()
        }
    }
}
