//
//  AguaYSal.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//

import SwiftUI

struct AguaYSalView: View {
    var textoBotonCerrar: String = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: .agua,
            subtituloCabecera: "En el altar",
            nombreElemento: "Agua y sal",
            tituloHistoria: "Después del viaje",
            parrafoHistoria1: "Ofrecer agua es un gesto de bienvenida. En la explicación tradicional, las ánimas llegan después de un recorrido y el vaso dispuesto en la ofrenda les permite saciar la sed.",
            parrafoHistoria2: "La sal suele aparecer en un recipiente o en una figura sobre el altar. Las formas de colocar ambos elementos cambian según las creencias y la composición elegida por cada familia.",
            preguntaReflexion: "Un gesto sencillo que dice: «Bienvenido a casa».",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "El agua representa hospitalidad y, en algunas regiones, pureza y vida. La idea de beber tras el viaje pertenece al relato ritual de la celebración.",
            subtituloSignificado2: "Cuidado y purificación",
            parrafoSignificado2: "La sal se interpreta como purificación y preservación simbólica durante el recorrido del ánima. Agua y sal expresan cuidado; la ficha describe creencias culturales, sin atribuirles un efecto físico sobre los difuntos.",
            notaSignificado: "No se ha establecido aquí un pueblo de origen exclusivo. El mapa muestra una comunidad donde se elaboran altares; no una fecha de invención.",
            hitos: HistoriasDocumentadas.hitos(para: "Agua y sal"),
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
