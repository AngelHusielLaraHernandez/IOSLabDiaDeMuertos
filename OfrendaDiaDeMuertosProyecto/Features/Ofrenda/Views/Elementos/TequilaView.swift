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
            icono: .tequila, subtituloCabecera: "En el altar",
            nombreElemento: "Vaso de tequila",
            tituloHistoria: "Un brindis en la memoria",
            parrafoHistoria1: "En ciertas ofrendas de adultos se coloca una bebida que gustaba al difunto. El vaso puede evocar una reunión; su elección depende de la memoria familiar.",
            parrafoHistoria2: "El paisaje agavero de Jalisco muestra la relación entre el cultivo de agave azul y la elaboración del tequila. La UNESCO distingue los destilados de los usos más antiguos del agave para bebidas fermentadas y fibras.",
            preguntaReflexion: "¿Qué reunión o celebración te recuerda esa persona?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Puede expresar atención y hospitalidad hacia una persona adulta. Su valor es personal y no implica que deba aparecer en todas las ofrendas.",
            subtituloSignificado2: "Una bebida con historia propia",
            parrafoSignificado2: "El mapa lleva a Tequila para explicar la historia regional de la bebida. La región incluye también Amatitán y El Arenal; esto no prueba que la costumbre de poner un vaso en el altar haya nacido en ese punto.",
            notaSignificado: "Su inclusión es opcional. La antigüedad del agave no debe confundirse con la del tequila destilado.",
            hitos: HistoriasDocumentadas.hitos(para: "Vaso de tequila"),
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
