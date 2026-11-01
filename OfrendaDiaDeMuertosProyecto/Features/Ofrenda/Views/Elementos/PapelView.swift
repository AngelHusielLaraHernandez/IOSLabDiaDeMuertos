//
//  Papel.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//


import SwiftUI

struct PapelView: View {
    var textoBotonCerrar: String = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: .papel,
            subtituloCabecera: "En el altar",
            nombreElemento: "Papel picado",
            tituloHistoria: "El aire entre los colores",
            parrafoHistoria1: "El papel picado se realiza calando dibujos sobre papel. Los artesanos preparan diseños y utilizan herramientas como cinceles; las piezas pueden reunir motivos de flores, esqueletos y escenas festivas.",
            parrafoHistoria2: "San Salvador Huixcolotla, Puebla, es una referencia artesanal documentada. El papel ritual antiguo y los banderines actuales no son idénticos: cambiaron materiales, técnicas y usos a lo largo del tiempo.",
            preguntaReflexion: "¿Qué recuerdo o escena de fiesta dibujarías en un papel picado?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Una interpretación frecuente relaciona su movimiento con el aire. Las perforaciones dejan pasar la luz y dan un carácter festivo al altar. Es una forma de acompañar la memoria con el trabajo de los artesanos.",
            subtituloSignificado2: "Colores que cambian con la comunidad",
            parrafoSignificado2: "El INAH explica que los colores se han adaptado con el tiempo. En algunos altares, morado y blanco se relacionan con el duelo y la pureza; no hay un código de colores único que todas las comunidades deban seguir.",
            notaSignificado: "Huixcolotla es un centro del oficio. La historia de todo recorte de papel no empieza ni termina en una sola localidad.",
            hitos: HistoriasDocumentadas.hitos(para: "Papel picado"),
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
