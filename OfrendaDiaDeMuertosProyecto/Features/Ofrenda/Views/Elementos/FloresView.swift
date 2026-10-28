//
//  Flores.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//

import SwiftUI

struct FloresView: View {
    var textoBotonCerrar: String = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: .flores,
            subtituloCabecera: "En el altar",

            nombreElemento: "Cempasúchil",
            tituloHistoria: "Un camino de pétalos",
            parrafoHistoria1: "El cempasúchil es una flor nativa de México, de intenso aroma y tonos amarillos o naranjas. En muchas comunidades acompaña la conmemoración de los difuntos; su cultivo y sus usos tienen una historia más amplia que una sola localidad.",
            parrafoHistoria2: "Las familias lo colocan en ramos, arcos o caminos de pétalos. La disposición depende de la región: el recorrido hacia el altar expresa una bienvenida simbólica, de acuerdo con la creencia del regreso de las ánimas.",
            preguntaReflexion: "¿Qué aroma elegirías para dar la bienvenida?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "El aroma y el color se interpretan como señales para orientar a las ánimas. También adornan el espacio y expresan el cariño de quienes preparan la ofrenda. Esta explicación pertenece a la tradición y a sus creencias.",
            subtituloSignificado2: "Veinte flores, muchas formas de ofrendar",
            parrafoSignificado2: "Su nombre náhuatl suele traducirse como «veinte flores»; también se encuentra «flor de veinte pétalos». Xochimilco destaca por su producción, pero la flor se cultiva en varias regiones. No es el lugar de origen exclusivo de su uso ritual.",
            notaSignificado: "Las flores elegidas y la forma de colocarlas varían entre comunidades y familias.",
            hitos: HistoriasDocumentadas.hitos(para: "Cempasúchil"),
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
