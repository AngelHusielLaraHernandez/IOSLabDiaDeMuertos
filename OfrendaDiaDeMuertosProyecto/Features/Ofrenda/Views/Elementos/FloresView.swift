//
//  Flores.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//

import SwiftUI

struct FloresView: View {
    var textoBotonCerrar: String = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: .flores,
            subtituloCabecera: "En el altar",
            nombreElemento: "Cempasúchil",
            tituloHistoria: "Un camino de pétalos",
            parrafoHistoria1: "En muchas ofrendas, los pétalos y racimos de cempasúchil trazan un sendero de bienvenida desde la entrada hasta el altar.",
            parrafoHistoria2: "Cada pétalo brilla como una chispa de sol que acompaña a quienes vuelven a casa.",
            preguntaReflexion: "¿Qué aroma elegirías para dar la bienvenida?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "En muchas tradiciones mexicanas, el aroma y el color del cempasúchil ayudan a guiar a las ánimas hacia el altar.",
            subtituloSignificado2: "Una flor que marca el camino",
            parrafoSignificado2: "Su nombre proviene del náhuatl Cempōhualxōchitl, que significa «flor de veinte pétalos». En los altares se coloca en arcos, floreros y caminos de pétalos.",
            notaSignificado: "Su uso y significado pueden variar entre regiones y familias.",
            hitos: [
                HitoHistorico(
                    epoca: "Antecedente mesoamericano",
                    titulo: "Cultivo y usos rituales",
                    descripcion: "Empleada desde tiempos prehispánicos en ceremonias dedicadas a la memoria y a los ciclos agrícolas.",
                    colorPunto: .yellow,
                    fuentes: [
                        FuenteDocumental(periodo: "Siglo XVI", titulo: "Historia de la flor", detalle: "Registros sobre el uso ceremonial y medicinal de la Cempōhualxōchitl en el centro de México.", referencia: "Códice Florentino, Libro XI")
                    ]
                ),
                HitoHistorico(
                    epoca: "Periodo virreinal",
                    titulo: "Senderos de bienvenida",
                    descripcion: "La flor se integró a los altares domésticos y cementerios durante las festividades de Todos los Santos.",
                    colorPunto: .orange,
                    fuentes: [
                        FuenteDocumental(periodo: "Siglos XVII-XIX", titulo: "Uso en la ofrenda", detalle: "Integración de arcos florales y caminos de pétalos en altares familiares.", referencia: "Crónicas de festividades novohispanas")
                    ]
                ),
                HitoHistorico(
                    epoca: "Tradición contemporánea",
                    titulo: "Una tradición viva",
                    descripcion: "Símbolo principal del Día de Muertos en hogares, plazas públicas y panteones de todo el país.",
                    colorPunto: .purple,
                    fuentes: [
                        FuenteDocumental(periodo: "Actualidad", titulo: "Patrimonio vivo", detalle: "Cultivo tradicional en Xochimilco, Puebla, Michoacán y Oaxaca para las festividades de noviembre.", referencia: "INAH / Patrimonio Cultural")
                    ]
                )
            ],
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
