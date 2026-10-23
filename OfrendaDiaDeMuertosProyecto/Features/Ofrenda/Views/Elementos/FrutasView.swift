//
//  FrutasView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct FrutasView: View {
    var textoBotonCerrar = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: .frutas, subtituloCabecera: "En el altar",
            nombreElemento: "Frutas",
            tituloHistoria: "Los frutos de la temporada",
            parrafoHistoria1: "Naranjas, mandarinas, guayabas y tejocotes acercan al altar los colores y aromas del campo.",
            parrafoHistoria2: "La selección cambia según el lugar y la familia. También puede incluir el fruto que más disfrutaba la persona recordada.",
            preguntaReflexion: "¿Qué fruta elegirías para contar un recuerdo de tu familia?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Los frutos de temporada evocan la cosecha y la abundancia que se comparte con los seres queridos.",
            subtituloSignificado2: "Una mesa con identidad",
            parrafoSignificado2: "El alimento elegido puede contar algo personal: una visita al mercado, una merienda o un árbol del patio.",
            notaSignificado: "No hay una lista de frutas obligatoria para todas las ofrendas.",
            hitos: [
                HitoHistorico(
                    epoca: "Registro de 2011", titulo: "Fruta para compartir",
                    descripcion: "Conaculta documenta cañas, naranjas, mandarinas y guayabas como parte de la ofrenda.", colorPunto: .yellow,
                    fuentes: [FuenteDocumental(
                        periodo: "Registro de 2011", titulo: "Frutos en el altar",
                        detalle: "La fuente también menciona el reparto de fruta al pedir calaverita.", referencia: "Secretaría de Cultura · El culto a los muertos",
                        url: URL(string: "https://www.cultura.gob.mx/noticias/patrimonio-cultural-arquitectura-y-turismo/16767-el-culto-a-los-muertos-costumbre-que-se-remonta-a-la-epoca-prehispanica.html")
                    )]
                ),
                HitoHistorico(
                    epoca: "Ciclo agrícola", titulo: "Lo que ofrece la temporada",
                    descripcion: "Los productos disponibles conectan la celebración con los frutos de la tierra.", colorPunto: .orange,
                    fuentes: [FuenteDocumental(
                        periodo: "Ciclo agrícola", titulo: "Alimentos de temporada",
                        detalle: "La cosecha y la memoria familiar se reúnen en la mesa.", referencia: "Alimentación para el Bienestar · Las ofrendas",
                        url: URL(string: "https://www.gob.mx/alimentacionparaelbienestar/es/articulos/las-ofrendas-tradicion-que-perdura-en-el-recuerdo?idiom=es")
                    )]
                ),
                HitoHistorico(
                    epoca: "Tradición familiar", titulo: "Una elección personal",
                    descripcion: "Los gustos y los recuerdos dan sentido a la selección de alimentos.", colorPunto: .purple,
                    fuentes: [FuenteDocumental(
                        periodo: "Tradición familiar", titulo: "Ofrenda y memoria",
                        detalle: "La composición cambia entre hogares.", referencia: "Gobierno de la CDMX · Ofrendas de Día de Muertos",
                        url: URL(string: "https://mexicocity.cdmx.gob.mx/day-of-the-dead-ofrendas/")
                    )]
                )
            ],
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
