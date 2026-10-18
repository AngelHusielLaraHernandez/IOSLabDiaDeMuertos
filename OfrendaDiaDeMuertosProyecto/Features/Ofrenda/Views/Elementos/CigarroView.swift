//
//  CigarroView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct CigarroView: View {
    var textoBotonCerrar = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: "🚬", subtituloCabecera: "En el altar",
            nombreElemento: "Cigarro",
            tituloHistoria: "Un recuerdo personal",
            parrafoHistoria1: "Algunas familias colocan un cigarro porque formaba parte de las costumbres de la persona adulta a quien dedican el altar.",
            parrafoHistoria2: "Su sentido es biográfico: recuerda un hábito particular, una conversación o una escena cotidiana.",
            preguntaReflexion: "¿Qué objeto cotidiano contarías para recordar a esa persona?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Representa una atención personal al difunto. No es un elemento indispensable ni tiene un significado universal.",
            subtituloSignificado2: "Un altar que cuenta una vida",
            parrafoSignificado2: "En este contexto aparece junto con otros objetos que la persona apreciaba. Cada familia decide si incluirlo.",
            notaSignificado: "Esta tarjeta explica su presencia cultural en algunas ofrendas de adultos.",
            hitos: [
                HitoHistorico(
                    epoca: "Registro de 1993", titulo: "Los gustos en el altar",
                    descripcion: "Un folleto sobre Mixquic reúne los cigarros con los objetos del gusto de los difuntos.", colorPunto: .yellow,
                    fuentes: [FuenteDocumental(
                        periodo: "Registro de 1993", titulo: "Culto a los fieles difuntos",
                        detalle: "La página de la CDMX retoma este folleto de 1993; no fecha el comienzo de la práctica.", referencia: "Gobierno de la CDMX · Ofrendas de Día de Muertos",
                        url: URL(string: "https://mexicocity.cdmx.gob.mx/day-of-the-dead-ofrendas/")
                    )]
                ),
                HitoHistorico(
                    epoca: "Registro de 2011", titulo: "Una distinción entre ofrendas",
                    descripcion: "Conaculta menciona los cigarros en las ofrendas dedicadas a personas adultas.", colorPunto: .orange,
                    fuentes: [FuenteDocumental(
                        periodo: "Registro de 2011", titulo: "Ofrendas de adultos",
                        detalle: "Referencia cultural, sin atribuirle un origen prehispánico al cigarro actual.", referencia: "Secretaría de Cultura · El culto a los muertos",
                        url: URL(string: "https://www.cultura.gob.mx/noticias/patrimonio-cultural-arquitectura-y-turismo/16767-el-culto-a-los-muertos-costumbre-que-se-remonta-a-la-epoca-prehispanica.html")
                    )]
                ),
                HitoHistorico(
                    epoca: "Lectura personal", titulo: "Recordar una costumbre",
                    descripcion: "Su presencia depende de la historia del difunto y de la elección familiar.", colorPunto: .purple,
                    fuentes: [FuenteDocumental(
                        periodo: "Lectura personal", titulo: "Memoria individual",
                        detalle: "Los objetos personales complementan el homenaje.", referencia: "Gobierno de la CDMX · Ofrendas de Día de Muertos",
                        url: URL(string: "https://mexicocity.cdmx.gob.mx/day-of-the-dead-ofrendas/")
                    )]
                )
            ],
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
