//
//  CalaveritaLiterariaView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Victor Flores on 23/10/26.
//

import SwiftUI

struct CalaveritaLiterariaView: View {
    var textoBotonCerrar = "Volver a la ofrenda"
    @Environment(\.dismiss) private var dismiss
    @State private var seccionActiva = 0
    @State private var mostrarFuentes = false
    private let colorTarjeta = AppTheme.surface
    private let colorAcento = AppTheme.accent
    private let colorTextoSecundario = AppTheme.secondaryText
    private let hitos = OfrendaCatalog.historiaCalaveritasLiterarias

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ElementSheetHeader(icono: .calaveritaLiteraria, subtitulo: "Poesía y sátira", titulo: "Calaveritas literarias")
            SheetSectionPicker(secciones: ["Ejemplo", "Origen", "Estructura", "Conocer más"], seleccion: $seccionActiva)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if seccionActiva == 0 {
                        // EJEMPLO / POEMA
                        Text("La Calaca jardinera")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        CalaveritaTextoView(texto: "La Calaca fue al **jardín**\ncon su lista y su sombrero;\ndijo: «Aquí vengo por fin,\npero riego lo primero».")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(5)
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 14).fill(colorTarjeta.opacity(0.6)))

                        CalaveritaTextoView(texto: "Entre **flores** y alegría,\nse olvidó de su misión;\ny al llegar el nuevo día,\nse marchó con un botón.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(5)
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 14).fill(colorTarjeta.opacity(0.6)))

                        Text("Las calaveritas literarias recuerdan con humor, rima y afecto las aficiones y personalidades de quienes queremos.")
                            .font(.footnote)
                            .foregroundColor(colorTextoSecundario)

                    } else if seccionActiva == 1 {
                        // ORIGEN E HISTORIA
                        Text("Sátira y crítica social")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text("Durante el siglo XIX, las calaveritas literarias se difundieron como una forma de sátira y crítica social. Sus versos combinan humor e imaginación para hablar de personas y de la muerte.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                        Text("El legado de Posada")
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .padding(.top, 4)

                        Text("La gráfica popular también empleó calaveras para comentar la vida social. Entre sus artistas destacan Manuel Manilla y José Guadalupe Posada. Las figuras de dulce y los versos comparten la celebración, pero son expresiones distintas.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                    } else if seccionActiva == 2 {
                        // ESTRUCTURA Y CÓMO ESCRIBIRLAS
                        Text("¿Cómo se componen?")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text("• **Estrofas:** Generalmente se escriben en cuartetas (estrofas de 4 versos).\n• **Rima:** Rima consonante o asonante, habitualmente en esquema ABAB o ABCB.\n• **Tema:** Se redactan como si la persona (viva) estuviera en una situación cómica o inesperada con «La Catrina» o «La Huesuda».\n• **Tono:** Festivo, irónico y afectuoso, con respeto hacia la persona.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(6)
                    } else {
                        Text("Versos a través del tiempo").font(.title3.bold())
                        ForEach(hitos) { hito in
                            TarjetaHitoTimeline(hito: hito) { mostrarFuentes = true }
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
            VistaFuentesElemento(nombreElemento: "Calaveritas Literarias", hitos: hitos)
                .ofrendaSheet()
        }
    }
}
