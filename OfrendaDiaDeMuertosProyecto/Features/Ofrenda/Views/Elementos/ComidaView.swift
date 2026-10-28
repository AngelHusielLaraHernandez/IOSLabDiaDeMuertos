//
//  Comida.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//

import SwiftUI

struct ComidaView: View {
    var textoBotonCerrar: String = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: .comida,
            subtituloCabecera: "En el altar",
            nombreElemento: "Comida",
            tituloHistoria: "Su platillo favorito",
            parrafoHistoria1: "La comida convierte el altar en una mesa dedicada a alguien. Cocinar un platillo permite conversar sobre los sabores, los oficios y las reuniones que formaron parte de su vida.",
            parrafoHistoria2: "Los alimentos cambian por región: pueden incluir tamales, mole, atoles o guisos familiares. En el Hanal Pixán de comunidades mayas destaca el pib o mucbipollo, un tamal que se cocina en un horno bajo tierra.",
            preguntaReflexion: "¿Qué platillo no podría faltar para recordar a los tuyos?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Según la creencia del regreso de las ánimas, los alimentos se ofrecen para agasajarlas. Prepararlos también reúne a la familia y transmite recetas y recuerdos entre generaciones.",
            subtituloSignificado2: "Nutrir con el recuerdo",
            parrafoSignificado2: "La tradición dice que las ánimas disfrutan la esencia de lo ofrecido. Elegir un platillo significativo cuenta más sobre la persona que repetir un menú fijo: el contexto, las posibilidades de la familia y sus costumbres dan forma al altar.",
            notaSignificado: "La gastronomía de ofrenda es diversa. El menú de Mixquic es una expresión local, no el punto de origen de todos los alimentos rituales.",
            hitos: HistoriasDocumentadas.hitos(para: "Comida"),
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
