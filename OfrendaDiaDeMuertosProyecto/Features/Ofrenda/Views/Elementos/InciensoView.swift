//
//  InciensoView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct InciensoView: View {
    var textoBotonCerrar = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: .incienso, subtituloCabecera: "En el altar",
            nombreElemento: "Incienso y copal",
            tituloHistoria: "Un aroma de bienvenida",
            parrafoHistoria1: "El humo perfuma el espacio de la ofrenda y acompaña los momentos de recuerdo y oración.",
            parrafoHistoria2: "El copal es una resina con una larga historia ritual en México. En los altares también encontramos otros inciensos.",
            preguntaReflexion: "¿Qué aroma relacionas con una celebración familiar?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "En distintas tradiciones, el humo se interpreta como purificación del espacio y vínculo con lo sagrado.",
            subtituloSignificado2: "El copal no es solo un perfume",
            parrafoSignificado2: "Su aroma acompaña la bienvenida simbólica a las ánimas. El significado depende del contexto religioso y comunitario.",
            notaSignificado: "El uso antiguo del copal es un antecedente, no prueba que los altares actuales fueran idénticos.",
            hitos: [
                HitoHistorico(
                    epoca: "Antecedente prehispánico", titulo: "Una resina ritual",
                    descripcion: "Se han estudiado restos de copal en ofrendas del Templo Mayor de Tenochtitlan.", colorPunto: .yellow,
                    fuentes: [FuenteDocumental(
                        periodo: "Antecedente prehispánico", titulo: "Arqueología del copal",
                        detalle: "Evidencia de su uso ritual anterior a los altares actuales.", referencia: "INAH · Identidad y simbolismo del copal prehispánico y reciente",
                        url: URL(string: "https://revistas.inah.gob.mx/index.php/arqueologia/article/view/6278")
                    )]
                ),
                HitoHistorico(
                    epoca: "Continuidad de usos", titulo: "Del árbol al sahumerio",
                    descripcion: "La extracción y el aprovechamiento ritual de la resina han mantenido prácticas a través del tiempo.", colorPunto: .orange,
                    fuentes: [FuenteDocumental(
                        periodo: "Continuidad de usos", titulo: "Obtención de resina",
                        detalle: "La investigación relaciona evidencias antiguas y aprovechamientos recientes.", referencia: "INAH · Revista Arqueología, núm. 33",
                        url: URL(string: "https://revistas.inah.gob.mx/index.php/arqueologia/article/view/6278")
                    )]
                ),
                HitoHistorico(
                    epoca: "En la ofrenda actual", titulo: "Un aroma para recibir",
                    descripcion: "El copal y el incienso acompañan la bienvenida y la oración.", colorPunto: .purple,
                    fuentes: [FuenteDocumental(
                        periodo: "En la ofrenda actual", titulo: "Aroma y reverencia",
                        detalle: "Su lectura simbólica varía según la tradición.", referencia: "Gobierno de la CDMX · Ofrendas de Día de Muertos",
                        url: URL(string: "https://mexicocity.cdmx.gob.mx/day-of-the-dead-ofrendas/")
                    )]
                )
            ],
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
