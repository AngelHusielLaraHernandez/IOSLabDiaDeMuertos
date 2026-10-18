//
//  OfrendaModelView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

/// La propuesta usa la misma escena y los mismos marcos que la pantalla principal.
struct OfrendaModelView: View {
    let resetToken: Int
    let fotosMarcos: [MarcoOfrenda: FotoMarco]
    var configuracionMarcos = ConfiguracionMarcos()
    var isObscured = false
    let onLoad: (ModelLoadState) -> Void
    let onSeleccionarMarco: (MarcoOfrenda) -> Void
    let onErrorFoto: (String) -> Void
    @State private var viewport = OfrendaViewportState()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geometry in
            let controls = MarcoPhotoControls.placements(viewport.frameProjections, in: geometry.size)
            ZStack {
                OfrendaInteractive3DView(
                    elementos: [],
                    resetToken: resetToken,
                    viewport: $viewport,
                    focusRequest: nil,
                    reduceMotion: reduceMotion,
                    onFocusCompleted: { _ in },
                    onLoad: onLoad,
                    fotosMarcos: fotosMarcos,
                    onSeleccionarMarco: onSeleccionarMarco,
                    onErrorFoto: onErrorFoto,
                    configuracionMarcos: configuracionMarcos,
                    isObscured: isObscured
                )
                MarcoPhotoControls(placements: isObscured ? [] : controls, onSelect: onSeleccionarMarco)
            }
            .clipped()
        }
    }
}
