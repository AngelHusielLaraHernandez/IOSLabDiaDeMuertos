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
            parrafoHistoria1: "Basta una ligera corriente de aire para que las banderitas de papel de China cobren movimiento sobre el altar.",
            parrafoHistoria2: "Sus figuras caladas a cincel dejan pasar la luz de las velas y visten de fiesta cada nivel de la ofrenda.",
            preguntaReflexion: "Cuando el papel se mueve, la tradición dice que las ánimas ya están pasando.",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Representa el elemento aire —uno de los cuatro elementos de la naturaleza presentes en la ofrenda— y aporta el carácter festivo a la celebración.",
            subtituloSignificado2: "El significado de sus colores",
            parrafoSignificado2: "El morado alude al luto tradicional, el naranja a la luz del cempasúchil, el blanco a la pureza y los tonos vivos a la alegría de recordar.",
            notaSignificado: "San Salvador Huixcolotla, Puebla, es cuna artesanal de esta técnica con cinceles y martillo.",
            hitos: [
                HitoHistorico(
                    epoca: "Antecedente mesoamericano",
                    titulo: "El papel amate ritual",
                    descripcion: "Los pueblos antiguos elaboraban papel de corteza de árbol (ámatl) para banderas y ornamentos ceremoniales.",
                    colorPunto: .yellow,
                    fuentes: [
                        FuenteDocumental(periodo: "Prehispánico", titulo: "Uso ritual del amate", detalle: "Banderas y recortes de papel amate empleados en ofrendas y fiestas.", referencia: "Museo Nacional de Antropología")
                    ]
                ),
                HitoHistorico(
                    epoca: "Siglo XIX",
                    titulo: "Papel de China y cincelado",
                    descripcion: "La llegada del papel de seda permitió a los artesanos cincelar decenas de pliegos con figuras de calaveras y flores.",
                    colorPunto: .orange,
                    fuentes: [
                        FuenteDocumental(periodo: "Mediados del s. XIX", titulo: "Arte en papel picado", detalle: "Consolidación de talleres artesanales en el estado de Puebla.", referencia: "Patrimonio Cultural de Puebla")
                    ]
                ),
                HitoHistorico(
                    epoca: "Tradición viva",
                    titulo: "Color y movimiento en el altar",
                    descripcion: "Símbolo visual inconfundible que une el viento, el arte popular y la memoria festiva.",
                    colorPunto: .purple,
                    fuentes: [
                        FuenteDocumental(periodo: "Actualidad", titulo: "Artesanía tradicional", detalle: "Declaratoria de patrimonio cultural del arte del papel picado.", referencia: "FONART / Arte Popular Mexicano")
                    ]
                )
            ],
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
