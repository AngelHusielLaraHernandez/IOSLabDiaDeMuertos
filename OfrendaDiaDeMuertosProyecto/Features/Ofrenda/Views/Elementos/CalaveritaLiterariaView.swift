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
<<<<<<< HEAD
    private let hitos = OfrendaCatalog.historiaCalaveritas // Puedes usar tu catálogo adaptado si lo deseas

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ElementSheetHeader(icono: .calaveritaLiteraria, subtitulo: "Poesía y sátira", titulo: "Calaveritas Literarias")
            SheetSectionPicker(secciones: ["Ejemplo", "Origen", "Estructura"], seleccion: $seccionActiva)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if seccionActiva == 0 {
                        // EJEMPLO / POEMA
                        Text("La Calaca jardinera")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text("La Calaca fue al jardín\ncon su lista y su sombrero;\ndijo: «Aquí vengo por fin,\npero riego lo primero».")
=======
    private let hitos = OfrendaCatalog.historiaCalaveritasLiterarias


    private enum Contenido {
        static let ejemplo = [
            "La Calaca jardinera",
            "La Calaca fue al **jardín**\ncon su lista y su sombrero;\ndijo: «Aquí vengo por fin,\npero riego lo primero».",
            "Entre **flores** y alegría,\nse olvidó de su misión;\ny al llegar el nuevo día,\nse marchó con un botón.",
            "Las calaveritas literarias recuerdan con humor, rima y afecto las aficiones y personalidades de quienes queremos.",
        ]
        static let origen = [
            "Sátira y crítica social",
            "En el siglo XIX circularon versos satíricos que imaginaban a personas frente a la Muerte. La UAM menciona una publicación antigua de 1849 en El Socialista de Guadalajara. Es un registro del género, no un certificado de un lugar único de invención.",
            "El legado de Posada",
            "Manuel Manilla y José Guadalupe Posada popularizaron calaveras en la gráfica de los impresos. Su trabajo ayudó a darles presencia pública; no significa que Posada inventara el género literario. Los versos y las figuras de azúcar comparten la fiesta, pero tienen historias propias.",
        ]
        static let estructura = [
            "¿Cómo se componen?",
            "• **Personaje:** Elige una persona, un oficio o una situación y algún rasgo que la identifique.\n• **Encuentro:** Imagina qué pasaría al encontrarse con la Muerte.\n• **Versos:** Las cuartetas y la rima son recursos frecuentes, no reglas obligatorias de un único esquema.\n• **Remate:** Termina con un giro ingenioso. Puede ser satírico o afectuoso. El ejemplo de esta app es una composición didáctica, no un poema histórico.",
        ]
    }

    private var textoLectura: String {
        switch seccionActiva {
        case 0: TextoLecturaOfrenda.unir(Contenido.ejemplo)
        case 1: TextoLecturaOfrenda.unir(Contenido.origen)
        case 2: TextoLecturaOfrenda.unir(Contenido.estructura)
        default: TextoLecturaOfrenda.cronologia("Versos a través del tiempo", hitos: hitos)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ElementSheetHeader(icono: .calaveritaLiteraria, subtitulo: "Poesía y sátira", titulo: "Calaveritas literarias")
            SheetSectionPicker(secciones: ["Ejemplo", "Origen", "Estructura", "Conocer más"], seleccion: $seccionActiva)
                .objetivoGuiaContextual("ficha.secciones")

            ControlLecturaView(texto: textoLectura, suspendida: mostrarFuentes)
                .objetivoGuiaContextual("ficha.voz")
            SheetReadingContent {
                VStack(alignment: .leading, spacing: 16) {
                    if seccionActiva == 0 {
                        // EJEMPLO / POEMA
                        Text(Contenido.ejemplo[0])
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        CalaveritaTextoView(texto: Contenido.ejemplo[1])
>>>>>>> main
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(5)
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 14).fill(colorTarjeta.opacity(0.6)))

<<<<<<< HEAD
                        Text("Entre flores y alegría,\nse olvidó de su misión;\ny al llegar el nuevo día,\nse marchó con un botón.")
=======
                        CalaveritaTextoView(texto: Contenido.ejemplo[2])
>>>>>>> main
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(5)
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 14).fill(colorTarjeta.opacity(0.6)))

<<<<<<< HEAD
                        Text("Las calaveritas literarias recuerdan con humor, rima y afecto las aficiones y personalidades de quienes queremos.")
=======
                        Text(Contenido.ejemplo[3])
>>>>>>> main
                            .font(.footnote)
                            .foregroundColor(colorTextoSecundario)

                    } else if seccionActiva == 1 {
                        // ORIGEN E HISTORIA
<<<<<<< HEAD
                        Text("Sátira y crítica social")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text("Nacieron en el siglo XIX como expresión de rebeldía social y crítica política en periódicos de la época. Eran censuradas por las autoridades porque satirizaban a las clases altas y gobernantes.")
=======
                        Text(Contenido.origen[0])
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text(Contenido.origen[1])
>>>>>>> main
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

<<<<<<< HEAD
                        Text("El legado de Posada")
=======
                        Text(Contenido.origen[2])
>>>>>>> main
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .padding(.top, 4)

<<<<<<< HEAD
                        Text("Solían ir acompañadas de grabados en madera o metal, inmortalizados más tarde por artistas como José Guadalupe Posada con su famosa «Catrina».")
=======
                        Text(Contenido.origen[3])
>>>>>>> main
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

<<<<<<< HEAD
                    } else {
                        // ESTRUCTURA Y CÓMO ESCRIBIRLAS
                        Text("¿Cómo se componen?")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text("• **Estrofas:** Generalmente se escriben en cuartetas (estrofas de 4 versos).\n• **Rima:** Rima consonante o asonante, habitualmente en esquema ABAB o ABCB.\n• **Tema:** Se redactan como si la persona (viva) estuviera en una situación cómica o inesperada con «La Catrina» o «La Huesuda».\n• **Tono:** Festivo, irónico y afectuoso, jamás solemne.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(6)
=======
                    } else if seccionActiva == 2 {
                        // ESTRUCTURA Y CÓMO ESCRIBIRLAS
                        Text(Contenido.estructura[0])
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text(LocalizedStringKey(Contenido.estructura[1]))
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
>>>>>>> main
                    }
                }
                .padding(.top, 4)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
<<<<<<< HEAD
            
            Button { dismiss() } label: {
                Text(textoBotonCerrar)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .ofrendaPrimaryAction()
=======

            Button { dismiss() } label: {
                Text(textoBotonCerrar)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .ofrendaPrimaryAction().objetivoGuiaContextual("hoja.cerrar")
>>>>>>> main
        }
        .padding(24)
        .sheet(isPresented: $mostrarFuentes) {
            VistaFuentesElemento(nombreElemento: "Calaveritas Literarias", hitos: hitos)
                .ofrendaSheet()
        }
    }
}
