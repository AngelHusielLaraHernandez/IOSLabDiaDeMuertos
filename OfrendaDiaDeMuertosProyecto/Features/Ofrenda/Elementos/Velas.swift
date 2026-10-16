//
//  Velas.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//

import SwiftUI

struct VelasView: View {
    var textoBotonCerrar: String = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: "🕯️",
            subtituloCabecera: "En el altar",
            nombreElemento: "Velas",
            tituloHistoria: "Una luz para volver",
            parrafoHistoria1: "Cuando cae la tarde, encender una vela transforma el altar en un punto de encuentro cálido y sereno.",
            parrafoHistoria2: "En muchas comunidades, cada flama lleva el nombre de un ser querido para que nunca le falte luz en su recorrido.",
            preguntaReflexion: "¿A quién dedicarías la primera luz de tu ofrenda?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "La flama simboliza la luz, la fe y la esperanza que iluminan el camino de regreso de las ánimas hacia su hogar.",
            subtituloSignificado2: "Orientación en la noche",
            parrafoSignificado2: "En diversas regiones se colocan cuatro velas en cruz para señalar los puntos cardinales y orientar al viajero.",
            notaSignificado: "Se emplean veladoras, cirios o ceras escamadas según la región.",
            hitos: [
                HitoHistorico(
                    epoca: "Antecedente mesoamericano",
                    titulo: "El fuego ceremonial",
                    descripcion: "El uso de teas de ocote y resinas aromáticas acompañaba los ritos funerarios como guía espiritual.",
                    colorPunto: .yellow,
                    fuentes: [
                        FuenteDocumental(periodo: "Prehispánico", titulo: "Rituales de luz", detalle: "El fuego como elemento guía en las ceremonias de paso.", referencia: "Estudios arqueológicos de Mesoamérica")
                    ]
                ),
                HitoHistorico(
                    epoca: "Periodo virreinal",
                    titulo: "Cirios y cerería tradicional",
                    descripcion: "La introducción de la cera de abeja dio origen a cirios y velas artesanales para los altares.",
                    colorPunto: .orange,
                    fuentes: [
                        FuenteDocumental(periodo: "Siglo XVIII", titulo: "Oficios de cerería", detalle: "Elaboración de velas y ceras escamadas para celebraciones de noviembre.", referencia: "Archivos de artes y oficios de México")
                    ]
                ),
                HitoHistorico(
                    epoca: "Tradición actual",
                    titulo: "Luz para recordar",
                    descripcion: "Las veladoras encendidas acompañan tanto los altares familiares como las veladas en los panteones.",
                    colorPunto: .purple,
                    fuentes: [
                        FuenteDocumental(periodo: "Actualidad", titulo: "Alumbradas en panteones", detalle: "Velación nocturna en comunidades como Mixquic, Pátzcuaro y Oaxaca.", referencia: "Acervo de Culturas Populares")
                    ]
                )
            ],
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
