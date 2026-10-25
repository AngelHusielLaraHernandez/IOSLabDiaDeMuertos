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
    static let revision = "23 de octubre de 2026"
    static let mixquicFuente = fuente("CDMX · Ofrendas de Día de Muertos", "https://mexicocity.cdmx.gob.mx/day-of-the-dead-ofrendas/")
    static let huaquechulaFuente = fuente("Ayuntamiento de Huaquechula · Tradiciones", "https://huaquechula.gob.mx/")
    static let atlixcoFuente = fuente("Ayuntamiento de Atlixco · Valle de Catrinas 2026", "https://atlixco.gob.mx/Pages/Noticias/Noticia?idnoti=4500")
    static let unamFuente = fuente("UNAM · Megaofrenda 2026", "https://www.ingenieria.unam.mx/evento.php?id=65&y=2026")

    // Coordenadas de referencia de las localidades, no accesos a viviendas ni rutas dentro de los recintos.
    static let xochimilco = LugarCultural(
        id: "xochimilco", nombre: "Xochimilco", region: "Ciudad de México", referencia: "Centro de Xochimilco",
        latitud: 19.257, longitud: -99.103,
        descripcion: "En sus zonas de cultivo se produce cempasúchil para la temporada de Día de Muertos. El trabajo de las familias floricultoras conecta la tierra con los altares.",
        avisoVisita: "El punto señala el centro de la localidad. Los cultivos se encuentran en distintos parajes; consulta las rutas y actividades de productores antes de visitarlos.",
        fuentes: [fuente("Gobierno de la CDMX · Floricultores y cempasúchil", "https://www.jefaturadegobierno.cdmx.gob.mx/comunicacion/nota/presenta-clara-brugada-sendero-de-las-almas-anuncia-actividades-de-dia-de-muertos-y-celebra-produccion-record-de-cempasuchil")])
    static let huixcolotla = LugarCultural(
        id: "huixcolotla", nombre: "San Salvador Huixcolotla", region: "Puebla", referencia: "Centro de San Salvador Huixcolotla",
        latitud: 18.921, longitud: -97.772,
        descripcion: "Los talleres de la localidad conservan el oficio del papel picado. Los diseños calados transforman hojas de papel en adornos para fiestas y ofrendas.",
        avisoVisita: "El mapa señala la localidad. Cada taller tiene su propio acceso y horario; acuerda la visita con sus artesanos.",
        fuentes: [fuente("Secretaría de Cultura · Papel picado de Huixcolotla", "https://mncp.cultura.gob.mx/obras-2/perforando-papel-picado-en-san-salvador-huixcolotla/")])
    static let toluca = LugarCultural(
        id: "toluca", nombre: "Toluca y el alfeñique", region: "Estado de México", referencia: "Los Portales de Toluca",
        latitud: 19.289, longitud: -99.656,
        descripcion: "En los Portales se celebra la Feria del Alfeñique. Sus dulces artesanales incluyen cráneos, frutas y otras figuras que acompañan la temporada de muertos.",
        avisoVisita: "El punto es una referencia de los Portales. La feria es temporal; revisa el programa de la edición que quieras visitar.",
        fuentes: [fuente("Ayuntamiento de Toluca · Feria del Alfeñique", "https://www2.toluca.gob.mx/tradiciones/")])
    static let janitzio = LugarCultural(
        id: "janitzio", nombre: "Janitzio", region: "Michoacán", referencia: "Isla de Janitzio",
        latitud: 19.574, longitud: -101.652,
        descripcion: "La velación y las ofrendas forman parte de la Noche de Muertos de la isla. Las velas acompañan alimentos y recuerdos familiares.",
        avisoVisita: "Es un punto de referencia en la isla, no un acceso por carretera. Consulta el transporte lacustre y los avisos oficiales de acceso al panteón para cada temporada.",
        fuentes: [fuente("Secretaría de Cultura de Michoacán · Noche de Muertos en Janitzio", "https://cultura.michoacan.gob.mx/noticias/fiel-a-sus-raices-dona-lourdes-realiza-los-preparativos-de-noche-de-muertos-en-janitzio/"), fuente("Gobierno de Michoacán · Avisos de acceso 2026", "https://michoacan.gob.mx/noticias/noche-de-muertos-en-janitzio-tendra-altares-monumentales-y-actividades-tradicionales/")])
    static let mixquic = LugarCultural(
        id: "mixquic", nombre: "San Andrés Mixquic", region: "Ciudad de México", referencia: "Centro de San Andrés Mixquic",
        latitud: 19.225, longitud: -98.964,
        descripcion: "La memoria familiar se expresa en sus ofrendas. Un registro local de 1993 describe alimentos, frutas, copal y gustos personales que reciben a los difuntos.",
        avisoVisita: "El punto señala el centro del pueblo. Las ofrendas familiares y ceremonias tienen condiciones de acceso propias; consulta la información local.",
        fuentes: [mixquicFuente])
    static let tequila = LugarCultural(
        id: "tequila", nombre: "Tequila y su paisaje agavero", region: "Jalisco", referencia: "Centro de Tequila, Jalisco",
        latitud: 20.882, longitud: -103.836,
        descripcion: "El paisaje agavero permite conocer la relación entre el cultivo, el trabajo y la elaboración del tequila. Su historia es distinta de la de las bebidas fermentadas de agave.",
        avisoVisita: "El mapa señala el centro de Tequila. Los campos y recintos industriales tienen accesos y horarios propios.",
        fuentes: [fuente("UNESCO · Paisaje agavero de Tequila", "https://whc.unesco.org/en/list/1209/")])
    static let huaquechula = LugarCultural(
        id: "huaquechula", nombre: "Huaquechula", region: "Puebla", referencia: "Centro de Huaquechula",
        latitud: 18.768, longitud: -98.541,
        descripcion: "Sus altares monumentales blancos reúnen retratos, alimentos y objetos que evocan a la persona recordada. La composición expresa los vínculos entre la familia, la memoria y sus creencias.",
        avisoVisita: "El mapa señala el centro del municipio. Los altares se distribuyen en distintos espacios; las viviendas requieren autorización de sus familias.",
        fuentes: [huaquechulaFuente, fuente("Ayuntamiento · Plan municipal, tradición de los altares", "https://huaquechula.gob.mx/Documentos/Transparencia/Adjudicaciones/Pagina/PMD%20Huaquechula%202021_2024.pdf")])
    static let universum = LugarCultural(
        id: "universum", nombre: "Explanada de Universum", region: "Ciudad Universitaria, CDMX", referencia: "Universum, UNAM",
        latitud: 19.311, longitud: -99.180,
        descripcion: "La explanada del museo es la sede anunciada por la UNAM para su Megaofrenda de 2026. La comunidad universitaria participa en una celebración colectiva de la memoria.",
        avisoVisita: "Punto de referencia del museo. Confirma entradas, accesibilidad y programa con la UNAM; la sede de la Megaofrenda puede cambiar en otras ediciones.",
        fuentes: [unamFuente])
    static let atlixco = LugarCultural(
        id: "atlixco", nombre: "Atlixco", region: "Puebla", referencia: "Centro de Atlixco",
        latitud: 18.908, longitud: -98.434,
        descripcion: "Valle de Catrinas reúne esculturas monumentales de cartonería en distintos espacios. La celebración permite recorrer la localidad y conocer el trabajo artístico de la región.",
        avisoVisita: "El mapa señala el centro de Atlixco. Las esculturas están distribuidas en varios puntos; consulta el recorrido oficial de cada edición.",
        fuentes: [atlixcoFuente])

    static func vinculo(para elemento: String) -> VinculoCultural? {
        switch elemento {
        case "Flores", "Cempasúchil": return .init(lugar: xochimilco, contexto: "Conoce una región productora de la flor que acompaña a las ánimas. Su cultivo también existe en otras zonas de México.")
        case "Retrato": return .init(lugar: huaquechula, contexto: "En los altares de esta región, el retrato forma parte de una composición dedicada a la memoria de una persona.")
        case "Velas": return .init(lugar: janitzio, contexto: "La luz acompaña la velación y las ofrendas de la isla. Es un ejemplo regional, no el origen de las velas.")
        case "Papel", "Papel picado": return .init(lugar: huixcolotla, contexto: "Descubre una comunidad de artesanos que mantiene vivo el oficio del papel picado.")
        case "Agua y sal": return .init(lugar: huaquechula, contexto: "Conoce los altares familiares de Huaquechula. El agua y la sal acompañan las ofrendas en distintas regiones; su sentido ritual se explica en Significado.")
        case "Calaveritas": return .init(lugar: toluca, contexto: "Este lugar se relaciona con las calaveritas de dulce y el alfeñique. La calaverita literaria tiene una historia propia.")
        case "Pan", "Pan de muerto": return .init(lugar: mixquic, contexto: "El registro de Mixquic describe panes colocados en la ofrenda. Es una expresión local de una tradición con variantes regionales.")
        case "Comida": return .init(lugar: mixquic, contexto: "El mole y los tamales aparecen entre los alimentos de las ofrendas descritas en esta comunidad.")
        case "Caña de azúcar": return .init(lugar: mixquic, contexto: "La caña se menciona entre los productos de temporada que acompañan la ofrenda local.")
        case "Frutas": return .init(lugar: mixquic, contexto: "Naranjas y manzanas forman parte de los alimentos de temporada descritos en las ofrendas de Mixquic.")
        case "Incienso": return .init(lugar: mixquic, contexto: "El registro local relaciona el humo del copal con el acto de ofrendar y recordar.")
        case "Cigarro": return .init(lugar: mixquic, contexto: "Los cigarros aparecen como un gusto personal de algunos difuntos adultos. No son un requisito para todas las ofrendas.")
        case "Tequila", "Vaso de tequila": return .init(lugar: tequila, contexto: "Conoce el paisaje asociado con la bebida. Su presencia en el altar depende de los gustos del adulto recordado.")
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
