//
//  MictlanIntroView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct MictlanIntroView: View {
    var esperandoModelo = false
    let onEntrar: () -> Void

    var body: some View {
        MictlanAnimationView(onEntrar: onEntrar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppTheme.background)
            .ignoresSafeArea()
            .overlay {
                if esperandoModelo {
                    ProgressView("Cargando modelo 3D…")
                        .padding(20)
                        .ofrendaSurface()
                        .foregroundStyle(.white)
                }
            }
    }
}
