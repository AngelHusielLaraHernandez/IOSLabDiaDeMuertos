//
//  Retrato.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//

import SwiftUI

struct RetratoView: View {
    var textoBotonCerrar: String = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: .retrato,
            subtituloCabecera: "En el altar",
            nombreElemento: "Retrato",
            tituloHistoria: "Una sonrisa conocida",
            parrafoHistoria1: "En lo alto de la ofrenda, la fotografía nos devuelve un gesto familiar: una tarde de domingo, una fiesta o una mirada serena.",
            parrafoHistoria2: "Poner su retrato en el nivel principal le da nombre y rostro a todas las historias que compartimos alrededor del altar.",
            preguntaReflexion: "Una imagen que mantiene cerca a quienes viven en nuestra memoria.",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Dedica formalmente la ofrenda a la persona o personas que recordamos y preside el nivel superior del altar.",
            subtituloSignificado2: "Presencia e identidad",
            parrafoSignificado2: "En algunas tradiciones familiares el retrato se coloca frente a un espejo o ligeramente oculto antes del día principal, simbolizando que el ser querido está presente en el recuerdo.",
            notaSignificado: "Antes de la fotografía se utilizaban objetos personales o prendas para representar al difunto.",
            hitos: [
                HitoHistorico(
                    epoca: "Antecedente tradicional",
                    titulo: "Objetos y prendas de identidad",
                    descripcion: "Se colocaban herramientas de trabajo, sombreros o prendas que representaban a la persona recordada.",
                    colorPunto: .yellow,
                    fuentes: [
                        FuenteDocumental(periodo: "Tradicional", titulo: "Símbolos personales", detalle: "Representación del difunto mediante sus pertenencias más preciadas.", referencia: "Etnografía de altares tradicionales")
                    ]
                ),
                HitoHistorico(
                    epoca: "Siglos XIX y XX",
                    titulo: "La fotografía en México",
                    descripcion: "Con la llegada del retrato fotográfico, los marcos familiares pasaron a ocupar la cima de la ofrenda.",
                    colorPunto: .orange,
                    fuentes: [
                        FuenteDocumental(periodo: "Siglo XIX", titulo: "Fotografía y memoria", detalle: "Incorporación de retratos impresos en los altares domésticos.", referencia: "Fototeca Nacional INAH")
                    ]
                ),
                HitoHistorico(
                    epoca: "Actualidad",
                    titulo: "El corazón de la ofrenda personal",
                    descripcion: "Hoy combinamos fotografías impresas y álbumes digitales para honrar su vida e historia.",
                    colorPunto: .purple,
                    fuentes: [
                        FuenteDocumental(periodo: "Siglo XXI", titulo: "Retratos familiares", detalle: "Prácticas contemporáneas de personalización en los altares de Día de Muertos.", referencia: "Estudios de cultura visual")
                    ]
                )
            ],
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
