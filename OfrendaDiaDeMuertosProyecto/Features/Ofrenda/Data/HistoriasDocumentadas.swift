//
//  HistoriasDocumentadas.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

/// Publicaciones consultadas el 28/10/2026. Una fecha de registro no es una fecha de origen.

/// La cronología diferencia antecedentes, registros y prácticas actuales sin inventar eslabones.
enum HistoriasDocumentadas {
    static let revision = "28 de octubre de 2026"

    static func hitos(para elemento: String) -> [HitoHistorico] {
        switch elemento {
        case "Cempasúchil": return [
            hito("Una flor de México", "Nombre y territorio", "El nombre náhuatl alude a veinte flores. Su procedencia mexicana y sus usos no permiten atribuir su origen a un solo pueblo productor.", .yellow, fuentes: [ReferenciasOfrenda.flor]),
            hito("Tradición de ofrenda", "Guiar con aroma y color", "Los caminos de pétalos expresan la creencia de que las ánimas encuentran así la ofrenda. Su disposición cambia entre comunidades.", .orange, fuentes: [ReferenciasOfrenda.inpi]),
            hito("Cultivo actual", "Familias que conservan la flor", "Xochimilco es una de las zonas productoras, junto con otras de Puebla, Michoacán, Veracruz y el Estado de México.", .purple, fuentes: [ReferenciasOfrenda.florCultivo]),
        ]
        case "Retrato": return [
            hito("1839 · contexto tecnológico", "La fotografía llega a México", "El daguerrotipo llegó en 1839. Este dato explica la historia de la técnica; no fecha su primera colocación en una ofrenda.", .yellow, fuentes: [ReferenciasOfrenda.foto]),
            hito("Diversidad regional", "El rostro en el altar", "En los altares de Huaquechula, el retrato y los objetos personales se sitúan en el nivel relacionado con la vida terrenal. Es una composición local.", .orange, fuentes: [ReferenciasOfrenda.huaquechula]),
            hito("Prácticas familiares", "Retrato, recuerdo y espejo", "Algunas descripciones de ofrendas incluyen un retrato visible mediante un espejo. Es una variante simbólica, no una colocación obligatoria.", .purple, fuentes: [ReferenciasOfrenda.retrato]),
        ]
        case "Velas": return [
            hito("Antecedentes diversos", "La cera no tiene una sola historia", "La UADY documenta el conocimiento de miel y cera entre los mayas prehispánicos. Por ello, no se presenta toda la cera como una introducción europea.", .yellow, fuentes: [ReferenciasOfrenda.cera]),
            hito("Siglo XVII · registro histórico", "Candelas en las casas", "El INAH recoge testimonios coloniales de comida, bebida y candelas durante las conmemoraciones de difuntos. Son registros de prácticas concretas.", .orange, fuentes: [ReferenciasOfrenda.origen]),
            hito("Registro de 2024", "Velación en Janitzio", "La Secretaría de Cultura de Michoacán describe velas y alimentos preparados por una familia de Janitzio. Documenta una tradición viva, no el nacimiento de las velas.", .purple, fuentes: [ReferenciasOfrenda.janitzio]),
        ]
        case "Papel picado": return [
            hito("Antecedentes del papel ritual", "Distintos materiales y usos", "El papel empleado en ceremonias antiguas y el papel de China de los adornos actuales corresponden a materiales y contextos distintos. No son una pieza que permaneció sin cambios.", .yellow, fuentes: [ReferenciasOfrenda.papel]),
            hito("Oficio artesanal", "Huixcolotla y el trabajo del calado", "La Secretaría de Cultura documenta el oficio de los artesanos de San Salvador Huixcolotla. Su especialización explica el vínculo del mapa con esta localidad.", .orange, fuentes: [ReferenciasOfrenda.huixcolotla]),
            hito("Interpretación actual", "El aire que mueve el altar", "El cuadernillo del INAH explica la asociación del papel con el aire y la adaptación de sus colores a través del tiempo.", .purple, fuentes: [ReferenciasOfrenda.papel]),
        ]
        case "Agua y sal": return [
            hito("Tradición de bienvenida", "Agua para el camino", "El agua recibe a las ánimas tras su recorrido. CONAGUA describe además su relación simbólica con la pureza en algunas regiones.", .yellow, fuentes: [ReferenciasOfrenda.agua]),
            hito("Significado ritual", "La sal como purificación", "El Museo Nacional de las Intervenciones explica el agua y la sal como símbolos de pureza. Se trata de creencias rituales, no de efectos físicos sobre un espíritu.", .orange, fuentes: [ReferenciasOfrenda.altar]),
        ]
        case "Pan de muerto": return [
            hito("Antecedentes alimentarios", "Ofrendar antes del pan de trigo", "Ciencia UNAM distingue los alimentos rituales de amaranto y maíz de los panes posteriores. Un antecedente de ofrenda no equivale a la misma receta actual.", .yellow, fuentes: [ReferenciasOfrenda.panHistoria]),
            hito("Periodo colonial", "Trigo y pan de ánimas", "La investigación divulgada por la UNAM relaciona la panadería europea con las prácticas de ofrenda mexicanas. No establece un pueblo único como lugar de invención.", .orange, fuentes: [ReferenciasOfrenda.panHistoria]),
            hito("Diversidad regional", "Más de una forma de recordar", "Los panes redondos con canillas conviven con figuras humanas, rosquillas y panes de yema. Mixquic tiene variantes locales; no originó todos los panes de muerto.", .purple, fuentes: [ReferenciasOfrenda.pan]),
        ]
        case "Comida": return [
            hito("Historia de la celebración", "La mesa cambia con el tiempo", "Los testimonios reunidos por el INAH muestran la convivencia y transformación de prácticas indígenas y católicas. No describen una receta única para todos los altares.", .yellow, fuentes: [ReferenciasOfrenda.origen]),
            hito("Identidad regional", "El ejemplo del Hanal Pixán", "En comunidades mayas, el pib o mucbipollo tiene un lugar particular en la conmemoración. Ilustra por qué la comida de ofrenda no se reduce al mismo menú en todo México.", .orange, fuentes: [ReferenciasOfrenda.hanal]),
            hito("Memoria familiar", "Preparar lo que le gustaba", "La SEP presenta la preparación y colocación de alimentos como una actividad familiar que permite hablar de recuerdos y tradiciones.", .purple, fuentes: [ReferenciasOfrenda.comida]),
        ]
        case "Caña de azúcar": return [
            hito("Periodo colonial", "Un cultivo incorporado", "Agricultura documenta la expansión de la caña y sus primeras industrias en el México colonial. Esto no determina cuándo se añadió por primera vez a un altar.", .yellow, fuentes: [ReferenciasOfrenda.cana]),
            hito("Registro local de 1993", "Caña entre los alimentos", "El folleto de Mixquic citado por la CDMX incluye caña en la mesa de temporada. El registro acredita su uso en esa comunidad, no su origen allí.", .orange, fuentes: [ReferenciasOfrenda.mixquic]),
            hito("Tradición actual", "Un producto de la temporada", "La caña aparece con otras frutas de la ofrenda. La elección de alimentos vincula la cosecha con el recuerdo familiar.", .purple, fuentes: [ReferenciasOfrenda.frutas]),
        ]
        case "Frutas": return [
            hito("Ciclo agrícola", "Compartir los frutos disponibles", "Las frutas de temporada relacionan la mesa con las cosechas y la abundancia compartida. La selección depende del clima y de lo que consigue cada familia.", .yellow, fuentes: [ReferenciasOfrenda.frutas]),
            hito("Diversidad culinaria", "La ofrenda tiene sabores locales", "Las celebraciones regionales incorporan distintos alimentos. En el Hanal Pixán, la preparación familiar acompaña la memoria de los difuntos.", .orange, fuentes: [ReferenciasOfrenda.hanal]),
            hito("Memoria familiar", "Los gustos también cuentan", "La SEP invita a reconocer los alimentos y su preparación en casa como parte de la celebración. No existe una lista nacional de frutas obligatorias.", .purple, fuentes: [ReferenciasOfrenda.comida]),
        ]
        case "Incienso y copal": return [
            hito("Evidencia arqueológica", "Copal en el Templo Mayor", "El estudio del INAH identifica resina de Bursera bipinnata en ofrendas del Templo Mayor de Tenochtitlan. Es evidencia de uso ritual, no del origen del altar moderno.", .yellow, fuentes: [ReferenciasOfrenda.copal]),
            hito("Obtención de la resina", "Del árbol al sahumerio", "La investigación compara restos antiguos con técnicas recientes de extracción de copal. No se debe confundir la procedencia de una resina con el lugar donde nació una festividad.", .orange, fuentes: [ReferenciasOfrenda.copal]),
            hito("Ofrendas actuales", "Un aroma para la conmemoración", "En las descripciones del Museo Nacional de las Intervenciones, el aroma del copal acompaña el sentido ritual del altar.", .purple, fuentes: [ReferenciasOfrenda.altar]),
        ]
        case "Cigarro": return [
            hito("Registro local de 1993", "Un gusto personal", "El folleto de Mixquic incluye cigarros entre los gustos del difunto. Esta referencia no establece cuándo comenzó la práctica ni la hace obligatoria.", .yellow, fuentes: [ReferenciasOfrenda.mixquic]),
            hito("Lectura del objeto", "Recordar una costumbre", "En este contexto, el cigarro representa un rasgo de una persona adulta. No se identifica con el conjunto de antiguos usos rituales del tabaco.", .orange, fuentes: [ReferenciasOfrenda.mixquic]),
        ]
        case "Vaso de tequila": return [
            hito("Desde el siglo XVI · bebida", "El paisaje del agave", "La UNESCO vincula el paisaje de Tequila con la producción de destilados desde el siglo XVI. Distingue esta actividad de los usos más antiguos del agave para bebidas fermentadas y fibras.", .yellow, fuentes: [ReferenciasOfrenda.agave]),
            hito("Registro local de 1993", "Una bebida elegida para alguien", "El registro de Mixquic menciona tequila y mezcal entre las preferencias que se incorporan a la ofrenda. Esa costumbre es distinta de la historia productiva del tequila.", .orange, fuentes: [ReferenciasOfrenda.mixquic]),
        ]
        default: return []
        }
    }

    private static func hito(_ epoca: String, _ titulo: String, _ descripcion: String, _ color: Color,
                             fuentes: [FuenteCultural]) -> HitoHistorico {
        HitoHistorico(epoca: epoca, titulo: titulo, descripcion: descripcion, colorPunto: color,
                      fuentes: fuentes.map {
            FuenteDocumental(periodo: epoca, titulo: $0.titulo,
                             detalle: "Respalda el contexto descrito. Consultada el \(revision).",
                             referencia: $0.titulo, url: $0.url)
        })
    }
}
