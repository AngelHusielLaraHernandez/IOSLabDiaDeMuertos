//
//  OfrendaModelView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI


struct OfrendaModelView: View {
    let renderSession: OfrendaRenderSession
    let resetToken: Int
    let fotosMarcos: [MarcoOfrenda: FotoMarco]
    var configuracionMarcos = ConfiguracionMarcos()
    var seleccionElementos = ConfiguracionElementosOfrenda()
    var isObscured = false
    let onLoad: (ModelLoadState) -> Void
    let onSeleccionarMarco: (MarcoOfrenda) -> Void
    let onErrorFoto: (String) -> Void
    var mostrarControlesFotos = true
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
                    seleccionElementos: seleccionElementos,
                    isObscured: isObscured,
                    renderSession: renderSession
                )
                if mostrarControlesFotos {
                    MarcoPhotoControls(placements: isObscured ? [] : controls, onSelect: onSeleccionarMarco)
                }
            }
            .clipped()
        }
    }
}
