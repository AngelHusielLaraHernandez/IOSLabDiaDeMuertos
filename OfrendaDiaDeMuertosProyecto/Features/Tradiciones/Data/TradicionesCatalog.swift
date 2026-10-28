//
//  TradicionesCatalog.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation

enum TradicionesCatalog {
    private static func fuente(_ titulo: String, _ url: String) -> FuenteCultural {
        FuenteCultural(titulo: titulo, url: URL(string: url)!)
    }
    static let revision = "28 de octubre de 2026"
    static let mixquicFuente = fuente("CDMX · Ofrendas de Día de Muertos", "https://mexicocity.cdmx.gob.mx/day-of-the-dead-ofrendas/")
    static let huaquechulaFuente = fuente("Secretaría de Cultura · Altares de Huaquechula", "https://sic.cultura.gob.mx/ficha.php?table=festividad&table_id=1395")
    static let atlixcoFuente = fuente("Ayuntamiento de Atlixco · Valle de Catrinas 2026", "https://www.atlixco.gob.mx/Pages/Noticias/Noticia?idnoti=4509")
    static let unamFuente = fuente("UNAM · Megaofrenda 2026", "https://sitios.fi-a.unam.mx/evento.php?id=65&y=2026")

    // Coordenadas de referencia de las localidades, no accesos a viviendas ni rutas dentro de los recintos.
    static let xochimilco = LugarCultural(
        id: "xochimilco", nombre: "Xochimilco", region: "Ciudad de México", referencia: "Entorno del Convento de San Bernardino de Siena, Xochimilco",
        latitud: 19.263263, longitud: -99.102493,
        descripcion: "En sus zonas de cultivo se produce cempasúchil para la temporada de Día de Muertos. El trabajo de las familias floricultoras conecta la tierra con los altares.",
        avisoVisita: "El punto corresponde al entorno de San Bernardino de Siena en el centro histórico, no a una chinampa. Los cultivos se encuentran en distintos parajes; consulta las rutas y actividades de productores antes de visitarlos.",
        fuentes: [ReferenciasOfrenda.florCultivo])
    static let huixcolotla = LugarCultural(
        id: "huixcolotla", nombre: "San Salvador Huixcolotla", region: "Puebla", referencia: "Centro de San Salvador Huixcolotla",
        latitud: 18.921, longitud: -97.772,
        descripcion: "Los talleres de la localidad conservan el oficio del papel picado. Los diseños calados transforman hojas de papel en adornos para fiestas y ofrendas.",
        avisoVisita: "El mapa señala una referencia aproximada de la localidad, no un taller en particular. Cada taller tiene su propio acceso y horario; acuerda la visita con sus artesanos.",
        fuentes: [ReferenciasOfrenda.huixcolotla])
    static let toluca = LugarCultural(
        id: "toluca", nombre: "Toluca y el alfeñique", region: "Estado de México", referencia: "Los Portales de Toluca",
        latitud: 19.290453, longitud: -99.656575,
        descripcion: "En los Portales se celebra la Feria del Alfeñique. Sus dulces artesanales incluyen cráneos, frutas y otras figuras que acompañan la temporada de muertos.",
        avisoVisita: "El punto es una referencia de los Portales. La feria es temporal; revisa el programa de la edición que quieras visitar.",
        fuentes: [ReferenciasOfrenda.alfenique])
    static let janitzio = LugarCultural(
        id: "janitzio", nombre: "Janitzio", region: "Michoacán", referencia: "Isla de Janitzio",
        latitud: 19.574114, longitud: -101.651683,
        descripcion: "La velación y las ofrendas forman parte de la Noche de Muertos de la isla. Las velas acompañan alimentos y recuerdos familiares.",
        avisoVisita: "Es un punto de referencia en la isla, no un acceso por carretera. Consulta el transporte lacustre y los avisos oficiales de acceso al panteón para cada temporada.",
        fuentes: [ReferenciasOfrenda.janitzio])
    static let mixquic = LugarCultural(
        id: "mixquic", nombre: "San Andrés Mixquic", region: "Ciudad de México", referencia: "Centro de San Andrés Mixquic",
        latitud: 19.224968, longitud: -98.965120,
        descripcion: "La memoria familiar se expresa en sus ofrendas. Un registro local de 1993 describe alimentos, frutas, copal y gustos personales que reciben a los difuntos.",
        avisoVisita: "El punto señala el centro del pueblo. Las ofrendas familiares y ceremonias tienen condiciones de acceso propias; consulta la información local.",
        fuentes: [mixquicFuente])
    static let tequila = LugarCultural(
        id: "tequila", nombre: "Tequila y su paisaje agavero", region: "Jalisco", referencia: "Centro de Tequila, Jalisco",
        latitud: 20.882, longitud: -103.836,
        descripcion: "El paisaje agavero permite conocer la relación entre el cultivo, el trabajo y la elaboración del tequila. Su historia es distinta de la de las bebidas fermentadas de agave.",
        avisoVisita: "El mapa señala una referencia aproximada del centro de Tequila, no una destilería ni un campo. Los campos y recintos industriales tienen accesos y horarios propios.",
        fuentes: [fuente("UNESCO · Paisaje agavero de Tequila", "https://whc.unesco.org/en/list/1209/")])
    static let huaquechula = LugarCultural(
        id: "huaquechula", nombre: "Huaquechula", region: "Puebla", referencia: "Centro de Huaquechula",
        latitud: 18.770708, longitud: -98.541389,
        descripcion: "Sus altares monumentales blancos reúnen retratos, alimentos y objetos que evocan a la persona recordada. La composición expresa los vínculos entre la familia, la memoria y sus creencias.",
        avisoVisita: "El mapa señala el centro del municipio. Los altares se distribuyen en distintos espacios; las viviendas requieren autorización de sus familias.",
        fuentes: [huaquechulaFuente, ReferenciasOfrenda.huaquechula])
    static let universum = LugarCultural(
        id: "universum", nombre: "Explanada de Universum", region: "Ciudad Universitaria, CDMX", referencia: "Universum, UNAM",
        latitud: 19.311407, longitud: -99.180638,
        descripcion: "La explanada del museo es la sede anunciada por la UNAM para su Megaofrenda de 2026. La comunidad universitaria participa en una celebración colectiva de la memoria.",
        avisoVisita: "Punto de referencia del museo. Confirma entradas, accesibilidad y programa con la UNAM; la sede de la Megaofrenda puede cambiar en otras ediciones.",
        fuentes: [unamFuente])
    static let atlixco = LugarCultural(
        id: "atlixco", nombre: "Atlixco", region: "Puebla", referencia: "Centro de Atlixco",
        latitud: 18.909451, longitud: -98.434028,
        descripcion: "Valle de Catrinas reúne esculturas monumentales de cartonería en distintos espacios. La celebración permite recorrer la localidad y conocer el trabajo artístico de la región.",
        avisoVisita: "El mapa señala el centro de Atlixco. Las esculturas están distribuidas en varios puntos; consulta el recorrido oficial de cada edición.",
        fuentes: [atlixcoFuente])

    static func vinculo(para elemento: String) -> VinculoCultural? {
        switch elemento {
        case "Flores", "Cempasúchil":
            return .init(lugar: xochimilco, contexto: "Conoce una zona que cultiva flores para la temporada.", tipo: .cultivo,
                         origen: "El cempasúchil es nativo de México. Las fuentes consultadas no sitúan el nacimiento de su uso ritual en Xochimilco: el punto representa una zona productora actual.",
                         fuentesOrigen: [ReferenciasOfrenda.flor, ReferenciasOfrenda.florCultivo])
        case "Retrato":
            return .init(lugar: huaquechula, contexto: "Aquí se documenta el retrato dentro de los altares monumentales.", tipo: .practica,
                         origen: "La fotografía llegó a México en 1839, pero eso no fecha su entrada a la ofrenda. Huaquechula muestra una disposición regional del retrato, no el lugar de invención de fotografiar o recordar a los difuntos.",
                         fuentesOrigen: [ReferenciasOfrenda.foto, ReferenciasOfrenda.huaquechula])
        case "Velas":
            return .init(lugar: janitzio, contexto: "La Noche de Muertos permite conocer una tradición de velación.", tipo: .practica,
                         origen: "Janitzio conserva una práctica regional de ofrendas con velas. La documentación citada no identifica a la isla como origen de las velas ni de toda la iluminación ritual de México.",
                         fuentesOrigen: [ReferenciasOfrenda.janitzio, ReferenciasOfrenda.cera])
        case "Papel", "Papel picado":
            return .init(lugar: huixcolotla, contexto: "La localidad conserva talleres especializados en el calado de papel.", tipo: .oficio,
                         origen: "Huixcolotla es un centro artesanal del papel picado. Debe distinguirse esa tradición de taller de los antecedentes del papel ritual y del recorte de papel en otras culturas.",
                         fuentesOrigen: [ReferenciasOfrenda.huixcolotla, ReferenciasOfrenda.papel])
        case "Agua y sal":
            return .init(lugar: mixquic, contexto: "El registro de ofrendas de Mixquic describe agua y sal.", tipo: .practica,
                         origen: "Las referencias explican su sentido de bienvenida y purificación, pero no establecen un único pueblo donde empezaron a colocarse. Mixquic es una práctica documentada que puedes conocer.",
                         fuentesOrigen: [ReferenciasOfrenda.agua, ReferenciasOfrenda.mixquic])
        case "Calaveritas", "Calaveritas de azúcar":
            return .init(lugar: toluca, contexto: "Toluca conserva un oficio confitero asociado con las calaveritas de dulce.", tipo: .oficio,
                         origen: "El alfeñique llegó a México dentro de intercambios culturales. Toluca tiene una tradición histórica de elaboración; eso no acredita que allí se inventaran todas las calaveritas de azúcar. Las literarias son una expresión distinta.",
                         fuentesOrigen: [ReferenciasOfrenda.azucar, ReferenciasOfrenda.alfenique])
        case "Pan", "Pan de muerto":
            return .init(lugar: mixquic, contexto: "Mixquic conserva panes locales, entre ellos las despeinadas.", tipo: .practica,
                         origen: "La UNAM describe una historia de adaptaciones alimentarias y panaderas y numerosas variantes regionales. Mixquic se relaciona con formas locales, no con el origen exclusivo de todo pan de muerto.",
                         fuentesOrigen: [ReferenciasOfrenda.pan, ReferenciasOfrenda.panHistoria])
        case "Comida":
            return .init(lugar: mixquic, contexto: "Una mesa regional permite conocer alimentos de la conmemoración.", tipo: .practica,
                         origen: "Los alimentos rituales y las cocinas familiares tienen historias diversas. La documentación no atribuye a un solo lugar la costumbre de ofrecer comida; este mapa presenta el ejemplo de Mixquic.",
                         fuentesOrigen: [ReferenciasOfrenda.origen, ReferenciasOfrenda.comida])
        case "Caña de azúcar":
            return .init(lugar: mixquic, contexto: "La caña está registrada entre los alimentos de esta comunidad.", tipo: .practica,
                         origen: "La historia del cultivo colonial es distinta de la historia de su uso en la ofrenda. El punto de Mixquic documenta esa costumbre, no el origen botánico ni la llegada de la caña a México.",
                         fuentesOrigen: [ReferenciasOfrenda.cana, ReferenciasOfrenda.mixquic])
        case "Frutas":
            return .init(lugar: mixquic, contexto: "Aquí se registran frutos de temporada dentro de la ofrenda.", tipo: .practica,
                         origen: "Las frutas tienen diferentes procedencias y sus usos cambian por región. No se establece una localidad única de origen para esta práctica: Mixquic es uno de sus ejemplos documentados.",
                         fuentesOrigen: [ReferenciasOfrenda.frutas, ReferenciasOfrenda.comida])
        case "Incienso", "Incienso y copal", "Copal":
            return .init(lugar: mixquic, contexto: "La ficha local relaciona el copal con el acto de ofrendar.", tipo: .practica,
                         origen: "El INAH documenta copal en ofrendas del Templo Mayor de Tenochtitlan. Ese hallazgo acredita uso antiguo, no un origen exclusivo. Mixquic muestra una práctica de ofrenda posterior y distinta.",
                         fuentesOrigen: [ReferenciasOfrenda.copal, ReferenciasOfrenda.altar])
        case "Cigarro":
            return .init(lugar: mixquic, contexto: "El registro local lo incluye entre las preferencias de algunos adultos.", tipo: .practica,
                         origen: "La fuente no establece dónde comenzó a ponerse un cigarro en el altar. Mixquic documenta una práctica familiar, distinta de la historia general del tabaco.",
                         fuentesOrigen: [ReferenciasOfrenda.mixquic])
        case "Tequila", "Vaso de tequila":
            return .init(lugar: tequila, contexto: "El mapa permite conocer el paisaje vinculado con la producción de la bebida.", tipo: .bebida,
                         origen: "Tequila forma parte del paisaje agavero de Jalisco junto con Amatitán y El Arenal. Es una referencia histórica de producción, no evidencia del lugar donde comenzó a servirse tequila en las ofrendas.",
                         fuentesOrigen: [ReferenciasOfrenda.agave])
        default: return nil
        }
    }

    static let lugares = [xochimilco, huixcolotla, toluca, janitzio, mixquic, tequila, huaquechula, universum, atlixco]

    static let celebraciones: [CelebracionCultural] = [
        .init(id: "megaofrenda-unam", nombre: "Megaofrenda UNAM", simbolo: "building.columns", resumen: "La comunidad universitaria convierte la memoria en una creación colectiva.", historia: "Cada edición reúne ofrendas y actividades de la comunidad universitaria. Sus temas y sedes cambian: conocer una edición no garantiza que la siguiente ocurra en el mismo lugar.", datoDestacado: "La celebración universitaria comenzó en 1997. A lo largo de su historia ha ocupado diferentes espacios de la UNAM.", lugar: universum, referenciaTemporal: "Edición 2026 · Explanada de Universum", avisoEdicion: "La agenda de la Facultad de Ingeniería anuncia el 31 de octubre de 2026 a las 11:00 h. Consulta el programa oficial para conocer todos los días, horarios y accesos.", fuente: unamFuente, verificadoEl: revision, historiasRequeridas: 3),
        .init(id: "altares-huaquechula", nombre: "Altares de Huaquechula", simbolo: "photo.on.rectangle.angled", resumen: "Altares blancos que hacen espacio a la historia de una familia.", historia: "El blanco y la disposición por niveles distinguen estas ofrendas. Fotografías, alimentos y objetos personales acompañan a quienes son recordados; su significado se vincula con las creencias de cada familia.", datoDestacado: "Una misma tradición se expresa en diferentes altares familiares. La visita es también un encuentro con la memoria de quienes abren su casa.", lugar: huaquechula, referenciaTemporal: "Tradición anual · Puebla", avisoEdicion: "Las ubicaciones y los accesos dependen de cada temporada. Esta ficha presenta la tradición; no confirma viviendas abiertas ni horarios para 2026.", fuente: huaquechulaFuente, verificadoEl: revision, historiasRequeridas: 6),
        .init(id: "valle-catrinas", nombre: "Valle de Catrinas", simbolo: "figure.stand", resumen: "La cartonería crece y sale al encuentro de la ciudad.", historia: "Las figuras monumentales forman un recorrido de arte popular por diversos espacios. Es una celebración de esculturas y tradiciones; no todas sus piezas son altares.", datoDestacado: "El anuncio municipal de 2026 contempla 27 piezas: 19 en Atlixco y ocho representando al municipio en otros sitios.", lugar: atlixco, referenciaTemporal: "Edición 2026 · Recorrido por Atlixco", avisoEdicion: "El punto del mapa es una referencia del centro, no la ubicación de todas las figuras. Consulta el recorrido y las fechas del programa municipal.", fuente: atlixcoFuente, verificadoEl: revision, historiasRequeridas: 13)
    ]
}
