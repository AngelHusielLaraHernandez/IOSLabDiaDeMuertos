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


    private enum Contenido {
        static let significado = [
            "Dulzura con nombre propio",
            "Las calaveritas de azúcar son figuras comestibles que acercan la imagen de la muerte a la vida cotidiana. Pueden colocarse en una ofrenda o regalarse: el sentido depende del contexto y de la relación entre las personas.",
            "Un detalle que identifica",
            "Algunas llevan un nombre en la frente y decoraciones de colores. No representan una amenaza ni exigen que el nombre sea de alguien fallecido; también pueden dedicarse con humor a una persona viva.",
        ]
        static let elaboracion = [
            "El oficio del alfeñique",
            "El alfeñique es una técnica confitera de tradición hispánica que utiliza azúcar de caña. Los talleres moldean, vacían o trabajan pastas y decoraciones según su receta; no todas las figuras llamadas calaveritas se elaboran de la misma manera.",
            "Materiales y variantes",
            "Existen además figuras de amaranto o chocolate, que no deben confundirse con la misma técnica del azúcar. Toluca es una referencia de este oficio, pero también hay producción en otras regiones de México.",
        ]
        static let historia = [
            "Intercambios que transforman la tradición",
            "La calaverita dulce forma parte de la adaptación de la confitería y de las celebraciones de difuntos. La imagen del cráneo tiene antecedentes diversos, pero no basta para afirmar que una pieza de azúcar actual sea idéntica a una ofrenda antigua. Su historia es distinta de la calaverita literaria, que se escribe en versos.",
        ]
    }

    private var textoLectura: String {
        switch seccionActiva {
        case 0: TextoLecturaOfrenda.unir(Contenido.significado + Contenido.elaboracion)
        case 1: TextoLecturaOfrenda.unir(Contenido.historia)
        case 2: TextoLecturaOfrenda.mapa(para: "Calaveritas")
        default: TextoLecturaOfrenda.cronologia("Su camino hasta el altar", hitos: hitos)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
<<<<<<< HEAD
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
=======
            ElementSheetHeader(icono: .calaveritas, subtitulo: "Dulce tradición", titulo: "Calaveritas de azúcar")
            SheetSectionPicker(secciones: ["Significado", "Historia", "Mapa", "Conocer más"], seleccion: $seccionActiva)
                .objetivoGuiaContextual("ficha.secciones")

            ControlLecturaView(texto: textoLectura, suspendida: mostrarFuentes)
                .objetivoGuiaContextual("ficha.voz")
            SheetReadingContent {
                VStack(alignment: .leading, spacing: 16) {
                    if seccionActiva == 0 {
                        // SIGNIFICADO Y SIMBOLISMO
                        Text(Contenido.significado[0])
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text(Contenido.significado[1])
>>>>>>> main
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                        Text(Contenido.significado[2])
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .padding(.top, 4)

<<<<<<< HEAD
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
=======
                        Text(Contenido.significado[3])
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                        Divider().padding(.vertical, 4)
                  
                        Text(Contenido.elaboracion[0])
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text(Contenido.elaboracion[1])
>>>>>>> main
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

<<<<<<< HEAD
                        Text("Variedades populares")
=======
                        Text(Contenido.elaboracion[2])
>>>>>>> main
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .padding(.top, 4)

<<<<<<< HEAD
                        Text("• **Chocolate:** Muy populares entre niños y jóvenes.\n• **Amaranto:** Endulzadas con miel de agave o piloncillo, de origen prehispánico.\n• **Gomita y Gelatina:** Variantes modernas integradas al altar actual.")
=======
                        Text(Contenido.elaboracion[3])
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                    } else if seccionActiva == 1 {
                 
                        Text(Contenido.historia[0])
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text(Contenido.historia[1])
>>>>>>> main
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

                    } else if seccionActiva == 2 {
<<<<<<< HEAD
                        // HISTORIA
                        Text("Raíces e Historia")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text("Su antecedente prehispánico es el *Tzompantli*, un altar de cráneos reales dedicado a los dioses. Durante la época colonial, las autoridades prohibieron el uso de huesos y la tradición se transformó en figuras modeladas de azúcar.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.88))
                            .lineSpacing(4)

=======
                        MapaElementoView(nombreElemento: "Calaveritas")
>>>>>>> main
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
<<<<<<< HEAD
            
=======

>>>>>>> main
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
<<<<<<< HEAD
            VistaFuentesElemento(nombreElemento: "Calaveritas de Azúcar", hitos: hitos)
=======
            VistaFuentesElemento(nombreElemento: "Calaveritas de azúcar", hitos: hitos)
>>>>>>> main
                .ofrendaSheet()
        }
    }
}
