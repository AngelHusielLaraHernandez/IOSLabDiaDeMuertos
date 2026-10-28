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
            epoca: "Intercambio cultural", titulo: "La confitería del azúcar",
            descripcion: "Agricultura relaciona las figuras de azúcar con la técnica española del alfeñique y las adaptaciones de la celebración de difuntos. Una figura dulce no es un cráneo arqueológico transformado sin cambios.",
            colorPunto: .yellow,
            fuentes: [fuenteCalavera(ReferenciasOfrenda.azucar, periodo: "Contexto de elaboración")]
        ),
        HitoHistorico(
            epoca: "Oficio regional", titulo: "Toluca y sus talleres",
            descripcion: "La documentación municipal explica la trayectoria de la confitería toluqueña y su feria. Acredita un oficio local, sin fijar allí el nacimiento de todas las figuras de azúcar mexicanas.",
            colorPunto: .orange,
            fuentes: [fuenteCalavera(ReferenciasOfrenda.alfenique, periodo: "Tradición de Toluca")]
        ),
        HitoHistorico(
            epoca: "Expresiones actuales", titulo: "Dulce, gráfica y memoria",
            descripcion: "El Archivo General de la Nación distingue representaciones de calaveras en impresos, cartonería y dulces. Comparten una imagen, pero sus materiales y trayectorias son distintos.",
            colorPunto: .purple,
            fuentes: [fuenteCalavera(ReferenciasOfrenda.grabado, periodo: "Diversidad de expresiones")]
        )
    ]

    static let historiaCalaveritasLiterarias: [HitoHistorico] = [
        HitoHistorico(
            epoca: "Siglo XIX", titulo: "La crítica se escribe en verso",
            descripcion: "La UAM cita una de las publicaciones antiguas de calaveritas en El Socialista de Guadalajara, en 1849. Es una referencia de circulación impresa, no una prueba de que todo el género se inventara allí ese año.",
            colorPunto: .yellow,
            fuentes: [fuenteCalavera(ReferenciasOfrenda.literaria, periodo: "Publicación documentada")]
        ),
        HitoHistorico(
            epoca: "Gráfica popular", titulo: "Manilla, Posada y los impresos",
            descripcion: "Los grabadores Manuel Manilla y José Guadalupe Posada emplearon calaveras para comentar la vida pública. Sus ilustraciones acompañaron diversos textos; no se atribuye a Posada la invención de la calaverita literaria.",
            colorPunto: .orange,
            fuentes: [fuenteCalavera(ReferenciasOfrenda.grabado, periodo: "Siglos XIX y XX")]
        ),
        HitoHistorico(
            epoca: "Práctica literaria", titulo: "Ingenio, sátira y homenaje",
            descripcion: "Los versos imaginan un encuentro con la Muerte para hablar de rasgos personales y situaciones sociales. La crítica humorística y el homenaje afectuoso son posibilidades del género, no una receta única de rima.",
            colorPunto: .purple,
            fuentes: [fuenteCalavera(ReferenciasOfrenda.literaria, periodo: "Características del género")]
        )
    ]

    private static func fuenteCalavera(_ fuente: FuenteCultural, periodo: String) -> FuenteDocumental {
        FuenteDocumental(periodo: periodo, titulo: fuente.titulo,
                         detalle: "Publicación institucional. Consultada el 28 de octubre de 2026.",
                         referencia: fuente.titulo, url: fuente.url)
    }
}
