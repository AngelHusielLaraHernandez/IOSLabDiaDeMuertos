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
            icono: .velas,
            subtituloCabecera: "En el altar",
            nombreElemento: "Velas",
            tituloHistoria: "Una luz para volver",
            parrafoHistoria1: "Las velas acompañan las visitas al altar y las velaciones en el panteón. La luz permite reconocer el espacio durante la noche y participa del sentido religioso de la conmemoración.",
            parrafoHistoria2: "En Janitzio, la preparación familiar de alimentos y veladoras está documentada como parte de la Noche de Muertos. Es un ejemplo de tradición purépecha viva, no el sitio donde se inventaron las velas.",
            preguntaReflexion: "¿A quién dedicarías la primera luz de tu ofrenda?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Según distintas tradiciones, la flama representa orientación, fe y esperanza para el regreso de las ánimas. Encenderla también puede acompañar una oración o la dedicación del altar a un ser querido.",
            subtituloSignificado2: "Orientación en la noche",
            parrafoSignificado2: "Algunas familias dedican una luz a cada difunto; otras disponen cuatro en relación con los puntos cardinales. Son variantes descritas por el INPI, no una cantidad obligatoria para todas las ofrendas.",
            notaSignificado: "El conocimiento de miel y cera ya existía en culturas como la maya; no se atribuye toda la cera a una introducción europea.",
            hitos: HistoriasDocumentadas.hitos(para: "Velas"),
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
