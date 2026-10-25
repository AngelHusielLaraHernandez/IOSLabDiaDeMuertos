//
//  CalaveritasHistoria.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

extension OfrendaCatalog {
    static let historiaCalaveritas: [HitoHistorico] = [
        HitoHistorico(
            epoca: "Tradición confitera", titulo: "Figuras de azúcar",
            descripcion: "La técnica del alfeñique permite modelar y decorar figuras de azúcar. Las calaveritas de dulce forman parte de la ofrenda.",
            colorPunto: .yellow,
            fuentes: [FuenteDocumental(periodo: "Antecedentes", titulo: "Calaverita de azúcar, dulce sabor de la muerte",
                detalle: "La Secretaría de Agricultura describe la técnica confitera y su incorporación a la celebración.",
                referencia: "Secretaría de Agricultura",
                url: URL(string: "https://www.gob.mx/agricultura/articulos/calaverita-de-azucar-dulce-sabor-de-la-muerte"))]
        ),
        HitoHistorico(
            epoca: "Tradición actual", titulo: "Artesanía que se comparte",
            descripcion: "Las ofrendas y las ferias del alfeñique conservan esta expresión artesanal. Hay figuras de azúcar, chocolate y amaranto.",
            colorPunto: .orange,
            fuentes: [FuenteDocumental(periodo: "Actualidad", titulo: "Calaveritas dulces: tradición mexicana",
                detalle: "Presenta las variedades de dulce y la feria de Toluca como parte de esta tradición.",
                referencia: "Secretaría de Agricultura",
                url: URL(string: "https://www.gob.mx/agricultura/articulos/139127"))]
        )
    ]

    static let historiaCalaveritasLiterarias: [HitoHistorico] = [
        HitoHistorico(
            epoca: "Siglo XIX", titulo: "La sátira en verso",
            descripcion: "Las calaveritas literarias se difundieron como una forma de sátira y crítica social. Son una expresión distinta de las figuras de azúcar.",
            colorPunto: .orange,
            fuentes: [FuenteDocumental(periodo: "Siglo XIX y actualidad", titulo: "Calaveritas literarias",
                detalle: "La Secretaría de Cultura de la Ciudad de México explica su carácter satírico y su relación con el Día de Muertos.",
                referencia: "Secretaría de Cultura de la Ciudad de México",
                url: URL(string: "https://www.cultura.cdmx.gob.mx/storage/app/media/calaveritas-literariasdocx-1.pdf"))]
        ),
        HitoHistorico(
            epoca: "Gráfica popular", titulo: "La calavera en los impresos",
            descripcion: "Los impresos mexicanos emplearon la figura de la calavera para comentar la vida social. Destacan los trabajos de Manuel Manilla y José Guadalupe Posada.",
            colorPunto: .purple,
            fuentes: [FuenteDocumental(periodo: "Siglo XIX", titulo: "La resignificación de la imagen de la calavera en México",
                detalle: "El Archivo General de la Nación documenta el uso de la calavera en la prensa y la gráfica popular.",
                referencia: "Archivo General de la Nación",
                url: URL(string: "https://www.gob.mx/agn/articulos/la-resignificacion-de-la-imagen-de-la-calavera-en-mexico"))]
        )
    ]
}
