//
//  PasoGuiaOfrenda.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation

/// El orden corresponde a acciones reales de la pantalla de la ofrenda.
enum PasoGuiaOfrenda: Int, CaseIterable, Identifiable {
    case explorar, historias, recorrido, fotografias, vistaLimpia, compartir, personalizar
    var id: Int { rawValue }
    var numero: Int { rawValue + 1 }
    var esUltimo: Bool { self == .personalizar }
    var titulo: String {
        switch self {
        case .explorar: "Explora con tus dedos"
        case .historias: "Cada objeto cuenta una historia"
        case .recorrido: "Lleva tu propio recorrido"
        case .fotografias: "Dale un lugar a sus recuerdos"
        case .vistaLimpia: "Contempla tu ofrenda"
        case .compartir: "Comparte lo que creaste"
        case .personalizar: "Hazla tuya"
        }
    }
    var explicacion: String {
        switch self {
        case .explorar: "Arrastra con un dedo para girar la ofrenda. Pellizca para acercarte o alejarte y usa dos dedos para mover el encuadre."
        case .historias: "Al tocar una etiqueta, te acercas al objeto y abres su historia y significado. Dentro de la ficha, Escuchar lee la sección en voz alta."
        case .recorrido: "Esta flecha abre la lista de elementos visitados y pendientes. Puedes explorar en el orden que prefieras."
        case .fotografias: "Aquí eliges uno o dos marcos y cambias sus fotos. También puedes tocar los marcos directamente cuando sus controles están visibles."
        case .vistaLimpia: "El ojo oculta las etiquetas y los botones sobre el altar para apreciarlo completo. Otro toque los vuelve a mostrar."
        case .compartir: "El botón de compartir encuadra toda la ofrenda y prepara una imagen sin botones. Después abre las opciones para compartirla."
        case .personalizar: "Desde Mi ofrenda puedes guardar tus fotos, gustos y elementos. Con esos datos, Calaveritas te permite crear tus versos. Historias reúne las fichas y Créditos te permite volver a ver esta guía."
        }
    }
}
