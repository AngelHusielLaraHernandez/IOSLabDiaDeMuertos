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
            ElementSheetHeader(icono: .calaveritas, subtitulo: "Dulce tradición", titulo: "Calaveritas de azúcar")
            SheetSectionPicker(secciones: ["Significado", "Elaboración", "Historia", "Mapa", "Conocer más"], seleccion: $seccionActiva)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if seccionActiva == 0 {
                        // SIGNIFICADO Y SIMBOLISMO
                        Text("Dulzura con nombre propio")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text("Elaboradas tradicionalmente con azúcar, amaranto o chocolate, las calaveritas decoradas con alfeñique de colores nos invitan a mirar la muerte con cercanía, ironía y dulzura.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                        Text("Un detalle lleno de cariño")
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .padding(.top, 4)

                        Text("Suelen llevar escrito un nombre en la frente en papel metalizado. Se colocan en el altar para honrar a los difuntos o se regalan a personas queridas en vida como un recordatorio de nuestra propia mortalidad.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                    } else if seccionActiva == 1 {
                        // ELABORACIÓN Y TIPOS
                        Text("Arte del Alfeñique")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text("La técnica del alfeñique llegó con los españoles. Con una pasta moldeable de azúcar se forman pequeñas figuras que después se decoran. La elaboración y los detalles cambian según la región y el taller.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                        Text("Variedades populares")
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .padding(.top, 4)

                        Text("Además del azúcar, también se encuentran calaveritas de chocolate y amaranto. Sus colores y decoraciones son parte del trabajo de cada artesano.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                    } else if seccionActiva == 2 {
                        // HISTORIA
                        Text("Raíces e Historia")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text("Las calaveritas de dulce forman parte de las adaptaciones entre las tradiciones de los antiguos mexicanos y la celebración católica de los Fieles Difuntos. Hoy aparecen en ofrendas y ferias del alfeñique, como la de Toluca.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                    } else if seccionActiva == 3 {
                        MapaElementoView(nombreElemento: "Calaveritas")
                    } else {
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
                        Button("Ver fuentes documentales") { mostrarFuentes = true }
                            .ofrendaSecondaryAction()
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
            VistaFuentesElemento(nombreElemento: "Calaveritas de azúcar", hitos: hitos)
                .ofrendaSheet()
        }
    }
}
