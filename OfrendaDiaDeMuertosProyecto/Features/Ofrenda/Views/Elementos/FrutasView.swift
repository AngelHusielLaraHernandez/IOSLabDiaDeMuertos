//
//  FrutasView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct FrutasView: View {
    var textoBotonCerrar = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: .frutas, subtituloCabecera: "En el altar",
            nombreElemento: "Frutas",
            tituloHistoria: "Los frutos de la temporada",
            parrafoHistoria1: "Las frutas acercan al altar aromas, sabores y colores de la temporada. Naranjas, tejocotes, guayabas o manzanas son ejemplos posibles, no una lista que deba completarse.",
            parrafoHistoria2: "El clima, las cosechas y los mercados de cada región influyen en lo que se ofrece. La elección también puede ser íntima: el fruto de un árbol familiar o el que alguien disfrutaba comer.",
            preguntaReflexion: "¿Qué fruta elegirías para contar un recuerdo de tu familia?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Expresan la abundancia que se comparte y el vínculo de la celebración con los productos del campo. Su presencia puede funcionar como una invitación simbólica a la mesa.",
            subtituloSignificado2: "Una mesa con identidad",
            parrafoSignificado2: "La fruta elegida puede hablar de un gusto y de una historia. Las ofrendas incorporan productos de distintas procedencias; no todas las frutas del altar son originarias de México ni llegaron al mismo tiempo.",
            notaSignificado: "No hay una sola localidad de origen para ofrecer frutas. El mapa permite conocer una práctica regional documentada.",
            hitos: HistoriasDocumentadas.hitos(para: "Frutas"),
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
