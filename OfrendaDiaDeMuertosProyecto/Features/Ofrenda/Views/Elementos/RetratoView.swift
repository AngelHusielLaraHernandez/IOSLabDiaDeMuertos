//
//  Retrato.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//

import SwiftUI

struct RetratoView: View {
    var textoBotonCerrar: String = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: .retrato,
            subtituloCabecera: "En el altar",
            nombreElemento: "Retrato",
            tituloHistoria: "Una sonrisa conocida",
            parrafoHistoria1: "La fotografía ayuda a reconocer a quién se dedica el altar. Al mirarla, la familia puede contar una anécdota, recordar una voz o explicar a las nuevas generaciones quién fue esa persona.",
            parrafoHistoria2: "La fotografía llegó a México en 1839, pero esa fecha no marca su primera incorporación a una ofrenda. En Huaquechula, una variante regional coloca el retrato con alimentos y objetos personales en el nivel que representa la vida terrenal.",
            preguntaReflexion: "Una imagen que mantiene cerca a quienes viven en nuestra memoria.",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Da rostro e identidad al homenaje. Puede recordar a una o varias personas; su posición depende del tipo de altar y no tiene que ocupar siempre la parte más alta.",
            subtituloSignificado2: "El retrato y el espejo",
            parrafoSignificado2: "Algunas descripciones tradicionales incluyen una imagen que se observa a través de un espejo. Esa disposición expresa simbólicamente la presencia de alguien que ya no está físicamente. Otras familias dejan la fotografía a la vista.",
            notaSignificado: "El espejo es una variante regional. La app permite un retrato visible sin exigir esa disposición.",
            hitos: HistoriasDocumentadas.hitos(para: "Retrato"),
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
