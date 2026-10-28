//
//  CanaDeAzucarView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct CanaDeAzucarView: View {
    var textoBotonCerrar = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: .cana, subtituloCabecera: "En el altar",
            nombreElemento: "Caña de azúcar",
            tituloHistoria: "Dulzura para compartir",
            parrafoHistoria1: "La caña aporta dulzor a la mesa y puede acompañar los frutos de temporada. Su presencia depende de los alimentos disponibles y de las preferencias que la familia quiera recordar.",
            parrafoHistoria2: "Su cultivo se expandió en México durante la época colonial, junto con los ingenios azucareros. Esa historia agrícola es distinta de la fecha, no establecida, en que comenzó a colocarse en cada comunidad.",
            preguntaReflexion: "¿Qué alimento dulce te recuerda una reunión en casa?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Puede expresar abundancia compartida o recordar un gusto personal. En el registro de Mixquic se menciona entre los productos de la ofrenda, sin asignarle un significado único para todo México.",
            subtituloSignificado2: "Una planta con su propia historia",
            parrafoSignificado2: "Conviene distinguir la planta, el azúcar que se obtiene de ella y los dulces elaborados con azúcar. La caña no nació en Mixquic ni fue un cultivo de los altares mesoamericanos anteriores a la llegada europea.",
            notaSignificado: "La referencia del mapa documenta su uso en la ofrenda. No identifica el origen botánico de la planta.",
            hitos: HistoriasDocumentadas.hitos(para: "Caña de azúcar"),
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
