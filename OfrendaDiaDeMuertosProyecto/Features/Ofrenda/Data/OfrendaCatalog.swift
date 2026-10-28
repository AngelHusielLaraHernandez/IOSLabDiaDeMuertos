//
//  OfrendaCatalog.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import simd

/// Elementos y anclajes del altar existente.
enum OfrendaCatalog {
    static let elementos: [ElementoOfrenda] = [
        ElementoOfrenda(
            nombre: "Flores", icono: .flores,
            tituloHistoria: "Un camino de pétalos",
            descripcionHistoria: "En muchas ofrendas, los pétalos y arcos de cempasúchil trazan un sendero de bienvenida hasta el altar.",
            significado: "Su color intenso y su aroma ayudan a guiar a las ánimas hacia la ofrenda.",
            anclaNormalizada: SIMD3<Float>(-0.28, 0.52, 0.05)
        ),
        ElementoOfrenda(
            nombre: "Retrato", icono: .retrato,
            tituloHistoria: "Una sonrisa conocida",
            descripcionHistoria: "El retrato dedica la ofrenda a la persona que recordamos; su posición cambia según la tradición.",
            significado: "Mantiene presente su rostro e identidad en la memoria familiar.",
            anclaNormalizada: SIMD3<Float>(0.06, 0.56, 0.0)
        ),
        ElementoOfrenda(
            nombre: "Velas", icono: .velas,
            tituloHistoria: "Una luz para volver",
            descripcionHistoria: "La flama ilumina el camino de regreso a casa durante la noche.",
            significado: "Simboliza la luz, la fe y la esperanza para guiar a los seres queridos.",
            anclaNormalizada: SIMD3<Float>(-0.22, 0.38, 0.12)
        ),
        ElementoOfrenda(
            nombre: "Papel", icono: .papel,
            tituloHistoria: "El aire entre los colores",
            descripcionHistoria: "El papel picado viste de color el altar; su movimiento se asocia simbólicamente con el aire.",
            significado: "Representa el elemento aire y la alegría festiva de la tradición.",
            anclaNormalizada: SIMD3<Float>(0.25, 0.78, 0.0)
        ),
        ElementoOfrenda(
            nombre: "Agua y sal", icono: .agua,
            tituloHistoria: "Después del viaje",
            descripcionHistoria: "Un vaso de agua fresca espera a las ánimas tras su largo recorrido.",
            significado: "El agua mitiga la sed del camino y la sal actúa como elemento de purificación.",
            anclaNormalizada: SIMD3<Float>(-0.32, 0.24, 0.22)
        ),
        ElementoOfrenda(
            nombre: "Calaveritas", icono: .calaveritas,
            tituloHistoria: "Recordar con una sonrisa",
            descripcionHistoria: "Las figuras de azúcar recuerdan con dulzura a quienes queremos.",
            significado: "Nos invitan a mirar la muerte con humor, afecto y cercanía.",
            anclaNormalizada: SIMD3<Float>(0.24, 0.38, 0.15)
        ),
        ElementoOfrenda(
            nombre: "Calaveritas literarias",
            icono: .calaveritaLiteraria,
            tituloHistoria: "Calaveritas literarias",
            descripcionHistoria: "Versos con humor y afecto para recordar.",
            significado: "La sátira y la rima como homenaje.",
            anclaNormalizada: SIMD3<Float>(x: 0.30, y: 0.30, z: 0.20),
            entidadesAncla: [],
            esElementoDelAltar: false
        ),
        ElementoOfrenda(
            nombre: "Pan", icono: .pan,
            tituloHistoria: "El aroma de la cocina",
            descripcionHistoria: "El pan de muerto se comparte como símbolo de fraternidad y cariño.",
            significado: "En la variante redonda, el círculo suele evocar el ciclo vital y las canillas, huesos o lágrimas.",
            anclaNormalizada: SIMD3<Float>(0.0, 0.22, 0.28)
        ),
        ElementoOfrenda(
            nombre: "Comida", icono: .comida,
            tituloHistoria: "Su platillo favorito",
            descripcionHistoria: "Los guisos, tamales o frutas que más disfrutaba en vida llenan la mesa.",
            significado: "Agasaja a nuestros seres queridos con los aromas de casa.",
            anclaNormalizada: SIMD3<Float>(-0.18, 0.20, 0.28)
        ),
        ElementoOfrenda(
            nombre: "Caña de azúcar", icono: .cana,
            tituloHistoria: "Dulzura para compartir",
            descripcionHistoria: "Los trozos de caña acompañan los alimentos de muchas ofrendas.",
            significado: "Recuerda los alimentos compartidos y los productos del campo.",
            anclaNormalizada: SIMD3<Float>(-0.34, 0.22, 0.35),
            entidadesAncla: ["comida__012", "comida__013"],
            zoomMaximoEtiqueta: 0.9
        ),
        ElementoOfrenda(
            nombre: "Frutas", icono: .frutas,
            tituloHistoria: "Los frutos de la temporada",
            descripcionHistoria: "Naranjas, mandarinas y otros frutos aportan aromas y colores a la mesa.",
            significado: "Evocan la cosecha y los gustos de la persona recordada.",
            anclaNormalizada: SIMD3<Float>(-0.14, 0.2, 0.23),
            entidadesAncla: ["comida__003", "comida__004", "comida__010", "comida__011"],
            zoomMaximoEtiqueta: 0.9
        ),
        ElementoOfrenda(
            nombre: "Incienso", icono: .incienso,
            tituloHistoria: "Un aroma de bienvenida",
            descripcionHistoria: "El copal y el incienso acompañan el encuentro entre la familia y sus recuerdos.",
            significado: "En distintas tradiciones, el humo purifica y acompaña la oración.",
            anclaNormalizada: SIMD3<Float>(-0.13, 0.3, 0.18),
            entidadesAncla: ["copal__002", "copal__004"],
            zoomMaximoEtiqueta: 0.9
        ),
        ElementoOfrenda(
            nombre: "Cigarro", icono: .cigarro,
            tituloHistoria: "Un recuerdo personal",
            descripcionHistoria: "Algunas ofrendas de adultos incluyen objetos relacionados con sus costumbres.",
            significado: "Recuerda un gusto particular de quien se homenajea; es opcional.",
            anclaNormalizada: SIMD3<Float>(-0.32, 0.22, 0.37),
            entidadesAncla: ["recuerdos__001", "recuerdos__002"],
            zoomMaximoEtiqueta: 0.9
        ),
        ElementoOfrenda(
            nombre: "Tequila", icono: .tequila,
            tituloHistoria: "Un brindis en la memoria",
            descripcionHistoria: "Un vaso puede recordar las reuniones y los gustos de una persona adulta.",
            significado: "Es una atención personal al difunto, según la tradición de cada familia.",
            anclaNormalizada: SIMD3<Float>(0.38, 0.21, 0.36),
            entidadesAncla: ["bebidas__006"],
            zoomMaximoEtiqueta: 0.9
        )
    ]

    /// Solo los 13 grupos que tienen representación en la ofrenda tridimensional.
    static let elementosDelAltar = elementos.filter(\.esElementoDelAltar)

}
