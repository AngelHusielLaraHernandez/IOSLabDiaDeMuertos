//
//  TequilaView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct TequilaView: View {
    var textoBotonCerrar = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: "🥃", subtituloCabecera: "En el altar",
            nombreElemento: "Vaso de tequila",
            tituloHistoria: "Un brindis en la memoria",
            parrafoHistoria1: "En algunas ofrendas de adultos se sirve la bebida que disfrutaba la persona recordada. Puede ser tequila, mezcal u otra elección familiar.",
            parrafoHistoria2: "El vaso evoca una reunión, un brindis o un momento compartido. Su presencia es una atención personal.",
            preguntaReflexion: "¿Qué reunión o celebración te recuerda esa persona?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "El tequila puede expresar hospitalidad y cariño hacia el difunto, según los gustos que tuvo en vida.",
            subtituloSignificado2: "Una bebida con historia propia",
            parrafoSignificado2: "El tequila se relaciona con el cultivo del agave y la destilación desarrollada durante el periodo virreinal. No equivale a las bebidas fermentadas más antiguas.",
            notaSignificado: "Su inclusión es opcional y corresponde a ciertas ofrendas de adultos.",
            hitos: [
                HitoHistorico(
                    epoca: "Periodo virreinal", titulo: "Agave y destilación",
                    descripcion: "La combinación de prácticas de cultivo y técnicas de destilación forma parte de la historia del tequila.", colorPunto: .yellow,
                    fuentes: [FuenteDocumental(
                        periodo: "Periodo virreinal", titulo: "Paisaje agavero",
                        detalle: "Este es el contexto de la bebida, no una fecha de incorporación al altar.", referencia: "UNESCO · Paisaje de agaves e instalaciones de Tequila",
                        url: URL(string: "https://whc.unesco.org/en/list/1209/")
                    )]
                ),
                HitoHistorico(
                    epoca: "Registro de 1993", titulo: "La bebida preferida",
                    descripcion: "El folleto de Mixquic citado por la CDMX menciona tequila y mezcal entre los gustos del difunto.", colorPunto: .orange,
                    fuentes: [FuenteDocumental(
                        periodo: "Registro de 1993", titulo: "Gustos personales",
                        detalle: "Registro de una práctica local, sin regla común para todas las familias.", referencia: "Gobierno de la CDMX · Ofrendas de Día de Muertos",
                        url: URL(string: "https://mexicocity.cdmx.gob.mx/day-of-the-dead-ofrendas/")
                    )]
                ),
                HitoHistorico(
                    epoca: "Registro de 2011", titulo: "Ofrendas para adultos",
                    descripcion: "Conaculta distingue las bebidas alcohólicas como parte de ofrendas de personas adultas.", colorPunto: .purple,
                    fuentes: [FuenteDocumental(
                        periodo: "Registro de 2011", titulo: "Contexto de la ofrenda",
                        detalle: "La bebida elegida depende de la persona homenajeada.", referencia: "Secretaría de Cultura · El culto a los muertos",
                        url: URL(string: "https://www.cultura.gob.mx/noticias/patrimonio-cultural-arquitectura-y-turismo/16767-el-culto-a-los-muertos-costumbre-que-se-remonta-a-la-epoca-prehispanica.html")
                    )]
                )
            ],
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
