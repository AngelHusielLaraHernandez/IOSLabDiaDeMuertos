//
//  Comida.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//

import SwiftUI

struct ComidaView: View {
    var textoBotonCerrar: String = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: "🍲",
            subtituloCabecera: "En el altar",
            nombreElemento: "Comida",
            tituloHistoria: "Su platillo favorito",
            parrafoHistoria1: "La ofrenda guarda el sazón de casa: los tamales recién hechos, el mole, la fruta de temporada o el café de olla que tanto disfrutaba.",
            parrafoHistoria2: "Cocinar lo que le gustaba a nuestro ser querido convierte la preparación del altar en un acto de memoria viva.",
            preguntaReflexion: "¿Qué platillo no podría faltar para recordar a los tuyos?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Tiene el propósito de deleitar a las ánimas que nos visitan con los aromas y sabores que formaron parte de su historia.",
            subtituloSignificado2: "Nutrir con el recuerdo",
            parrafoSignificado2: "Según la tradición popular, las ánimas disfrutan la esencia y el aroma de los alimentos dispuestos con cariño sobre la mesa.",
            notaSignificado: "Incluye desde guisos tradicionales hasta dulces, bebidas y frutas como mandarinas, tejocotes y cañas.",
            hitos: [
                HitoHistorico(
                    epoca: "Raíz mesoamericana",
                    titulo: "El maíz y los frutos de la tierra",
                    descripcion: "Los tamales, el cacao y las cosechas de otoño se ofrecían en agradecimiento y memoria de los antepasados.",
                    colorPunto: .yellow,
                    fuentes: [
                        FuenteDocumental(periodo: "Prehispánico", titulo: "Alimentos ceremoniales", detalle: "Ofrendas de maíz, calabaza y cacao en los ciclos rituales de otoño.", referencia: "Códices mesoamericanos")
                    ]
                ),
                HitoHistorico(
                    epoca: "Tradición mestiza",
                    titulo: "El banquete del altar",
                    descripcion: "Los moles, arroces, dulces cristalizados y bebidas calientes enriquecieron las mesas de ofrenda.",
                    colorPunto: .orange,
                    fuentes: [
                        FuenteDocumental(periodo: "Siglo XIX", titulo: "Cocina de Día de Muertos", detalle: "Recetarios familiares para las festividades de noviembre.", referencia: "Patrimonio Gastronómico de México")
                    ]
                ),
                HitoHistorico(
                    epoca: "Identidad familiar",
                    titulo: "Los gustos que cuentan su historia",
                    descripcion: "Cada familia personaliza el altar con el platillo exacto que hacía sonreír a su ser querido.",
                    colorPunto: .purple,
                    fuentes: [
                        FuenteDocumental(periodo: "Actualidad", titulo: "Cocina y memoria", detalle: "La gastronomía mexicana en las celebraciones del Día de Muertos.", referencia: "UNESCO / Patrimonio Inmaterial")
                    ]
                )
            ],
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
