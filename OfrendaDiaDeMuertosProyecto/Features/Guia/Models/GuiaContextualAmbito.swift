//
//  GuiaContextualAmbito.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation

struct PasoGuiaContextual: Identifiable {
    let id: String
    let titulo: String
    let explicacion: String
    var objetivo: String { id.hasPrefix("ficha.seccion.") ? "ficha.secciones" : id }
}


enum GuiaContextualAmbito: String, CaseIterable {
    case ficha, azucar, literaria, marcos, recorrido, fuentes, fechas, crearOfrenda, ajusteFoto
    case guardarCalaverita, calaveritasGuardadas, misOfrendas, generador, marcosGeneral

    var clave: String {
        let version = self == .azucar ? 3 : (self == .ficha || self == .literaria || self == .crearOfrenda ? 2 : 1)
        return "ofrenda.guiaHoja.v\(version).\(rawValue).completada"
    }
    var pasos: [PasoGuiaContextual] {
        func paso(_ id: String, _ titulo: String, _ texto: String) -> PasoGuiaContextual {
            PasoGuiaContextual(id: id, titulo: titulo, explicacion: texto)
        }
        switch self {
        case .ficha, .azucar:
            let historia = paso("ficha.seccion.Historia", "Historia: de dónde viene", "Esta sección cuenta el origen del elemento y cómo se ha integrado a las ofrendas. Desliza el texto para leerlo completo.")
            let significado = paso("ficha.seccion.Significado", self == .azucar ? "Significado y elaboración" : "Significado: por qué está aquí", self == .azucar ? "Conoce qué representan las calaveritas de azúcar y cómo se preparan. La misma sección reúne su significado, el alfeñique y sus variedades." : "Conoce lo que representa este elemento y el lugar que tiene al recordar a una persona.")
            let mapa = paso("ficha.seccion.Mapa", "Mapa: una tradición que sigue viva", "Aquí encuentras un lugar relacionado con esta tradición. Su fotografía y contexto te ayudan a conocerlo; puedes abrir su explorador y las opciones de visita.")
            let referencias = paso("ficha.seccion.Conocer más", "Conocer más: sigue su evolución", "La línea del tiempo reúne momentos de su historia. Toca un hito o Ver fuentes documentales para consultar las referencias.")
            let lectura = paso("ficha.voz", "Escucha la sección abierta", "Escuchar lee el texto de la sección que elijas. Puedes pausar, continuar o detener la voz; cambiar de sección detiene la lectura anterior.")
            let modelo = paso("ficha.modelo", "Mira el objeto de cerca", "Este visor muestra el elemento separado del altar. Arrastra para apreciarlo desde otros ángulos. Usa Volver a la ofrenda para cerrar la ficha.")
            return (self == .azucar ? [significado, historia] : [historia, significado]) + [mapa, referencias, lectura, modelo]
        case .literaria:
            return [paso("ficha.seccion.Ejemplo", "Ejemplo: escucha cómo suenan los versos", "Lee una calaverita literaria y observa su tono de humor y recuerdo. La pestaña Calaveritas te permite crear tus propios versos."),
                    paso("ficha.seccion.Origen", "Origen: de dónde vienen", "Conoce cómo surgieron las calaveritas literarias y su relación con la sátira y la tradición del Día de Muertos."),
                    paso("ficha.seccion.Estructura", "Estructura: cómo se escribe", "Esta sección explica cómo se construyen los versos, sus rimas y la presencia de la Muerte como personaje."),
                    paso("ficha.seccion.Conocer más", "Conocer más: versos a través del tiempo", "Recorre su evolución y abre los hitos o Ver fuentes documentales para conocer las referencias."),
                    paso("ficha.voz", "Escucha la calaverita", "Escuchar lee la sección actual. Pausa o detén la voz cuando quieras."),
                    paso("hoja.cerrar", "Regresa a las historias", "Cierra la ficha para seguir explorando. El signo de interrogación repite esta ayuda.")]
        case .marcosGeneral:
            return [paso("marcos.disposicion", "Elige uno o dos marcos", "Selecciona cuántas fotografías quieres mostrar y toca el retrato que quieras editar. La ofrenda general no necesita nombres ni músicas."),
                    paso("marcos.fotografia", "Elige su fotografía", "Selecciona una imagen y ajusta su encuadre. Aquí puedes cambiar las fotos sin introducir datos de personalización."),
                    paso("marcos.guardar", "Guarda las fotografías", "Guardar confirma las imágenes de la ofrenda general y te devuelve al altar. Las ofrendas personalizadas conservan sus propios datos.")]
        case .marcos:
            return [paso("marcos.disposicion", "Elige tus marcos", "Puedes usar uno o dos retratos. Con dos marcos, añade dos nombres y dos músicas diferentes. Toca una foto para elegir el marco que estás editando."),
                    paso("marcos.fotografia", "Pon su fotografía", "Elige una imagen para el marco seleccionado. Para reemplazar una foto personal guardada también debes cambiar su nombre. Puedes conservar las fotos de ejemplo."),
                    paso("marcos.guardar", "Guarda para volver al altar", "Guardar confirma las fotos y la disposición. Los cambios aparecen en la ofrenda principal y en su vista previa.")]
        case .recorrido:
            return [paso("recorrido.lista", "Descubre lo que te falta", "Toca un elemento para acercarte a él y abrir su historia. Los checks indican las fichas que ya exploraste; los elementos ocultos no cuentan."),
                    paso("recorrido.volver", "Continúa a tu ritmo", "Este botón cierra la lista y te devuelve a la ofrenda.")]
        case .fuentes:
            return [paso("fuentes.documentos", "Consulta de dónde viene", "Las referencias acompañan la línea del tiempo. Toca un enlace disponible para abrir su fuente original."),
                    paso("fuentes.voz", "También puedes escucharlas", "Escuchar lee los datos de las fuentes. Volver al elemento te lleva a la ficha sin perder tu sección.")]
        case .fechas:
            return [paso("fechas.calendario", "Cada recuerdo tiene su día", "Consulta las fechas de mascotas, niñas y niños, y adultos. El contador usa la fecha y zona horaria de tu teléfono; las costumbres pueden variar según la comunidad.")]
        case .crearOfrenda:
            return [paso("personalizar.nombre", "Una persona por marco", "El retrato seleccionado muestra su nombre, su música y la opción para elegir su fotografía. Puedes conservar la foto de ejemplo."),
                    paso("personalizar.continuar", "Continúa con el siguiente marco", "Con dos retratos, Siguiente selecciona el marco 2 para completar sus datos. Desde el segundo marco, Añadir gustos y recuerdos continúa con los gustos compartidos. Después podrás guardar y marcar tu ofrenda en Mis ofrendas.")]
        case .ajusteFoto:
            return [paso("ajuste.imagen", "Encuadra su recuerdo", "Arrastra la fotografía dentro del marco. Usa el control de ampliación para acercarla sin deformarla."),
                    paso("ajuste.confirmar", "Conserva este encuadre", "Usar esta foto aplica el recorte al marco elegido. Volver cancela este ajuste.")]
        case .guardarCalaverita:
            return [paso("calaverita.nombre", "Distingue cada versión", "Escribe un nombre único para encontrar estos versos después. Toca Guardar arriba para conservarlos, o Cancelar para volver sin guardarlos.")]
        case .calaveritasGuardadas:
            return [paso("calaveritas.coleccion", "Tus versos, a la mano", "Toca una calaverita para leerla completa. El símbolo de compartir junto a cada una envía su texto; también está disponible dentro del detalle.")]
        case .generador:
            return [paso("calaveritas.preparacion", "Tus recuerdos, hechos versos", "Guarda primero una ofrenda personalizada. Después elige la ofrenda y la persona, y toca Generar calaverita. Guardar conserva una versión con nombre; Compartir envía su texto. En Guardadas encontrarás tu colección.")]
        case .misOfrendas:
            return [paso("ofrendas.crear", "Crea otro recuerdo", "Crear empieza una ofrenda personalizada independiente. Cada ofrenda conserva sus fotos, gustos y elementos."),
                    paso("ofrendas.eliminar", "Administra tus ofrendas", "Eliminar ofrenda activa los controles para borrar una de la lista. Terminar de eliminar sale de ese modo. El check de cada ofrenda decide cuál aparece en la pantalla principal.")]
        }
    }
}
