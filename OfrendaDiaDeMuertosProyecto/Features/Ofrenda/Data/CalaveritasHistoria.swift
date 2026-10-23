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
            epoca: "Antecedente histórico",
            titulo: "Alfeñique y figuras de azúcar",
            descripcion: "Técnica confitera que dio forma a pequeñas calaveras decoradas con colores vegetales y nombres en la frente.",
            colorPunto: .yellow,
            fuentes: [
                FuenteDocumental(periodo: "Siglo XVIII", titulo: "Dulcería y alfeñique", detalle: "Tradición de figuras de pasta de azúcar en ferias como la de Toluca y Oaxaca.", referencia: "Museo del Alfeñique")
            ]
        ),
        HitoHistorico(
            epoca: "Siglo XIX",
            titulo: "Versos satíricos e impresos",
            descripcion: "Los periódicos y hojas volantes popularizaron las calaveritas literarias acompañadas de grabados de José Guadalupe Posada.",
            colorPunto: .orange,
            fuentes: [
                FuenteDocumental(periodo: "1849 - 1913", titulo: "Panteones literarios", detalle: "Primeros registros impresos en el periódico El Socialista y grabados populares.", referencia: "Hemeroteca Nacional de México")
            ]
        ),
        HitoHistorico(
            epoca: "Tradición actual",
            titulo: "Dulzura e ingenio para recordar",
            descripcion: "Tanto en dulce como en rima, las calaveritas celebran la vida de nuestros seres queridos con una sonrisa.",
            colorPunto: .purple,
            fuentes: [
                FuenteDocumental(periodo: "Actualidad", titulo: "Calaveritas en la ofrenda", detalle: "Concursos literarios y ferias del alfeñique en todo México.", referencia: "Acervo de Tradiciones Mexicanas")
            ]
        )
    ]

}
