//
//  PanDeMuerto.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//

import SwiftUI

struct PanDeMuertoView: View {
    var textoBotonCerrar: String = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: "🍞",
            subtituloCabecera: "En el altar",
            nombreElemento: "Pan de muerto",
            tituloHistoria: "El aroma de la cocina",
            parrafoHistoria1: "El perfume de azahar, naranja y mantequilla recién horneada anuncia que los días de recordar han llegado.",
            parrafoHistoria2: "Colocarlo en el altar y después compartirlo en familia une el recuerdo con la convivencia cotidiana.",
            preguntaReflexion: "¿Prefieres el pan espolvoreado con azúcar o con ajonjolí?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Representa el afecto y el gusto por compartir la mesa con quienes regresan a visitarnos.",
            subtituloSignificado2: "El ciclo de la vida en su forma",
            parrafoSignificado2: "Su forma circular evoca el ciclo de la vida y la muerte; la esfera central representa el cráneo y las cuatro canillas simbolizan los huesos y los rumbos del universo.",
            notaSignificado: "Cada región hornea variantes propias: de yema, antropomorfos, con ajonjolí o azúcar rosa.",
            hitos: [
                HitoHistorico(
                    epoca: "Antecedente mesoamericano",
                    titulo: "Ofrendas de amaranto",
                    descripcion: "Se elaboraban figuras rituales con semillas de amaranto tostado y miel conocidas como tzoalli.",
                    colorPunto: .yellow,
                    fuentes: [
                        FuenteDocumental(periodo: "Siglo XVI", titulo: "Panes rituales de amaranto", detalle: "Crónicas sobre la elaboración de figuras de amaranto para las festividades.", referencia: "Fray Bernardino de Sahagún")
                    ]
                ),
                HitoHistorico(
                    epoca: "Periodo virreinal",
                    titulo: "Trigo, azúcar y azahar",
                    descripcion: "Con la llegada del trigo y la panadería europea surgieron los panes de ánimas decorados en los hornos familiares.",
                    colorPunto: .orange,
                    fuentes: [
                        FuenteDocumental(periodo: "Siglo XVIII", titulo: "Panadería novohispana", detalle: "Adaptación de los panes de ofrenda con esencia de azahar y anís.", referencia: "Historia de la gastronomía mexicana")
                    ]
                ),
                HitoHistorico(
                    epoca: "Diversidad regional",
                    titulo: "Cientos de formas y sabores",
                    descripcion: "Desde las hojaldras del centro del país hasta el pan de yema oaxaqueño y los panes pintados de Michoacán.",
                    colorPunto: .purple,
                    fuentes: [
                        FuenteDocumental(periodo: "Actualidad", titulo: "Atlas del pan de muerto", detalle: "Registro de las variedades regionales de pan de ofrenda en México.", referencia: "CONACULTA / Cocina Tradicional")
                    ]
                )
            ],
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
