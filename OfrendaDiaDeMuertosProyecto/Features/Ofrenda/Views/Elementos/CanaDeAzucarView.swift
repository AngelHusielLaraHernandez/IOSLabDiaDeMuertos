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
            parrafoHistoria1: "En muchas casas, los trozos de caña acompañan las frutas del altar y los alimentos que se preparan para compartir.",
            parrafoHistoria2: "Su presencia reúne una historia agrícola y una costumbre familiar: ofrecer algo conocido a quienes recordamos.",
            preguntaReflexion: "¿Qué alimento dulce te recuerda una reunión en casa?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "En la ofrenda puede recordar el gusto del difunto y la generosidad de la mesa compartida.",
            subtituloSignificado2: "Una planta con su propia historia",
            parrafoSignificado2: "La caña se expandió en México durante el periodo colonial. Su cultivo no comenzó con los altares prehispánicos.",
            notaSignificado: "Las formas de colocarla varían entre familias y regiones.",
            hitos: [
                HitoHistorico(
                    epoca: "Periodo colonial", titulo: "Un cultivo que se expande",
                    descripcion: "Los ingenios y las zonas de cultivo incorporaron la caña a la vida alimentaria de México.", colorPunto: .yellow,
                    fuentes: [FuenteDocumental(
                        periodo: "Periodo colonial", titulo: "Cultivo e industria",
                        detalle: "Contexto agrícola; no fecha el inicio de su uso en altares.", referencia: "Secretaría de Agricultura · Caña de azúcar, un valioso alimento",
                        url: URL(string: "https://www.gob.mx/agricultura/articulos/cana-de-azucar-un-valioso-alimento")
                    )]
                ),
                HitoHistorico(
                    epoca: "Registro de 2011", titulo: "La caña en la ofrenda",
                    descripcion: "Conaculta la incluye entre los alimentos de los altares de muertos.", colorPunto: .orange,
                    fuentes: [FuenteDocumental(
                        periodo: "Registro de 2011", titulo: "Elementos del altar",
                        detalle: "Registro de una práctica; no establece un origen único.", referencia: "Secretaría de Cultura · El culto a los muertos",
                        url: URL(string: "https://www.cultura.gob.mx/noticias/patrimonio-cultural-arquitectura-y-turismo/16767-el-culto-a-los-muertos-costumbre-que-se-remonta-a-la-epoca-prehispanica.html")
                    )]
                ),
                HitoHistorico(
                    epoca: "Tradición actual", titulo: "Compartir y recordar",
                    descripcion: "Cada familia decide qué alimentos conservan un recuerdo especial.", colorPunto: .purple,
                    fuentes: [FuenteDocumental(
                        periodo: "Tradición actual", titulo: "Memoria familiar",
                        detalle: "La ofrenda se relaciona con los gustos de la persona recordada.", referencia: "Gobierno de la CDMX · Ofrendas de Día de Muertos",
                        url: URL(string: "https://mexicocity.cdmx.gob.mx/day-of-the-dead-ofrendas/")
                    )]
                )
            ],
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
