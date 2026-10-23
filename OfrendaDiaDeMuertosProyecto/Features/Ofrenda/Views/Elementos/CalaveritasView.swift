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
            ElementSheetHeader(icono: .calaveritas, subtitulo: "Dulce tradición", titulo: "Calaveritas de Azúcar")
            SheetSectionPicker(secciones: ["Significado", "Elaboración", "Historia", "Indagar"], seleccion: $seccionActiva)
            
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

                        Text("El alfeñique es una técnica de origen árabe introducida por los españoles, moldeada con clara de huevo, limón y azúcar canela. En lugares como Toluca o Puebla, esta artesanía se ha transmitido por generaciones.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                        Text("Variedades populares")
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .padding(.top, 4)

                        Text("• **Chocolate:** Muy populares entre niños y jóvenes.\n• **Amaranto:** Endulzadas con miel de agave o piloncillo, de origen prehispánico.\n• **Gomita y Gelatina:** Variantes modernas integradas al altar actual.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                    } else if seccionActiva == 2 {
                        // HISTORIA
                        Text("Raíces e Historia")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text("Su antecedente prehispánico es el *Tzompantli*, un altar de cráneos reales dedicado a los dioses. Durante la época colonial, las autoridades prohibieron el uso de huesos y la tradición se transformó en figuras modeladas de azúcar.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

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
                        if let vinculo = TradicionesCatalog.vinculo(para: "Calaveritas") {
                            TarjetaLugarView(lugar: vinculo.lugar, contexto: vinculo.contexto)
                            Text(vinculo.lugar.avisoVisita).font(.footnote).foregroundStyle(AppTheme.secondaryText)
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
            VistaFuentesElemento(nombreElemento: "Calaveritas de Azúcar", hitos: hitos)
                .ofrendaSheet()
        }
    }
}
