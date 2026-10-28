//
//  InciensoView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct InciensoView: View {
    var textoBotonCerrar = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: .incienso, subtituloCabecera: "En el altar",
            nombreElemento: "Incienso y copal",
            tituloHistoria: "Un aroma de bienvenida",
            parrafoHistoria1: "El copal es una resina aromática obtenida de distintos árboles. La investigación del INAH ha identificado copal en ofrendas antiguas del Templo Mayor, evidencia de su uso ceremonial anterior a la festividad actual.",
            parrafoHistoria2: "En el altar, el sahumerio contiene el material que se quema y permite dispersar el aroma. «Incienso» puede referirse de forma general a sustancias aromáticas: no todas son copal ni tienen la misma composición.",
            preguntaReflexion: "¿Qué aroma relacionas con una celebración familiar?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "En diversas tradiciones, el humo acompaña la oración, la reverencia y la purificación simbólica del espacio. Ese sentido pertenece a las creencias de quienes ofrendan.",
            subtituloSignificado2: "Una resina y muchos contextos",
            parrafoSignificado2: "Los restos arqueológicos y las técnicas de extracción ayudan a conocer el aprovechamiento del copal. No demuestran que todos los altares actuales existieran igual ni que una única localidad originara su uso.",
            notaSignificado: "Mixquic es un lugar donde se documenta su uso. El Templo Mayor es un sitio de evidencia arqueológica, no el origen exclusivo del copal.",
            hitos: HistoriasDocumentadas.hitos(para: "Incienso y copal"),
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
