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
            parrafoHistoria1: "Tras un largo recorrido, el primer gesto de hospitalidad en la mesa es ofrecer un vaso de agua clara.",
            parrafoHistoria2: "Junto al vaso, un pequeño plato con sal acompaña el altar como símbolo de cuidado y resguardo.",
            preguntaReflexion: "Un gesto sencillo que dice: «Bienvenido a casa».",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "El agua fresca mitiga la sed de las ánimas después de su travesía y simboliza la pureza y la fuente de la vida.",
            subtituloSignificado2: "Cuidado y purificación",
            parrafoSignificado2: "La sal se coloca como elemento de purificación y preservación, para que el espíritu transite en paz en su viaje de ida y vuelta.",
            notaSignificado: "Ambos elementos suelen ubicarse en los niveles principales del altar.",
            hitos: [
                HitoHistorico(
                    epoca: "Antecedente histórico",
                    titulo: "Agua para el viaje",
                    descripcion: "En las cosmovisiones antiguas, el agua era indispensable para el tránsito de los difuntos.",
                    colorPunto: .yellow,
                    fuentes: [
                        FuenteDocumental(periodo: "Mesoamérica", titulo: "Tradiciones funerarias", detalle: "Vasijas con agua depositadas como ofrenda para el trayecto del espíritu.", referencia: "Arqueología Mexicana")
                    ]
                ),
                HitoHistorico(
                    epoca: "Sincretismo cultural",
                    titulo: "Recibir y purificar",
                    descripcion: "El simbolismo de la sal como resguardo espiritual se unió a la hospitalidad del altar doméstico.",
                    colorPunto: .orange,
                    fuentes: [
                        FuenteDocumental(periodo: "Siglo XVII", titulo: "Agua y sal en el altar", detalle: "Costumbres de purificación y bienvenida en las mesas de ofrenda.", referencia: "Estudios de religión popular")
                    ]
                ),
                HitoHistorico(
                    epoca: "Uso contemporáneo",
                    titulo: "Hospitalidad esencial",
                    descripcion: "Un vaso de agua limpia y un puñado de sal permanecen como elementos infaltables en cada hogar.",
                    colorPunto: .purple,
                    fuentes: [
                        FuenteDocumental(periodo: "Actualidad", titulo: "Elementos de la ofrenda", detalle: "Presencia constante del agua y la sal en altares urbanos y rurales.", referencia: "Guía de tradiciones del Día de Muertos")
                    ]
                )
            ],
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
