//
//  ObjetivoGuia.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct ObjetivosGuiaPreference: PreferenceKey {
    static var defaultValue: [PasoGuiaOfrenda: Anchor<CGRect>] { [:] }
    static func reduce(value: inout [PasoGuiaOfrenda: Anchor<CGRect>], nextValue: () -> [PasoGuiaOfrenda: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { _, nuevo in nuevo })
    }
}

extension View {
    /// El ancla sigue el control real al girar el teléfono, cambiar texto o desplazar la pantalla.
    func objetivoGuia(_ paso: PasoGuiaOfrenda, activo: Bool = true) -> some View {
        transformAnchorPreference(key: ObjetivosGuiaPreference.self, value: .bounds) { objetivos, ancla in
            if activo { objetivos[paso] = ancla }
        }
    }
}
