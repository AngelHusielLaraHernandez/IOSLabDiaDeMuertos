//
//  TarjetaHitoTimeline.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct TarjetaHitoTimeline: View {
    let hito: HitoHistorico
    let onVerFuentes: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(hito.colorPunto)
                .frame(width: 10, height: 10)
                .padding(.top, 6)
            VStack(alignment: .leading, spacing: 6) {
                Text(hito.epoca.uppercased())
                    .font(.caption2.bold())
                    .foregroundStyle(AppTheme.accent)
                Text(hito.titulo)
                    .font(.headline)
                Text(hito.descripcion)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
                Button(action: onVerFuentes) {
                    Label("Ver fuentes (\(hito.fuentes.count))", systemImage: "arrow.right")
                        .font(.caption.bold())
                        .padding(.vertical, 4)
                }
                .ofrendaSecondaryAction()
                .padding(.top, 4)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .ofrendaSurface()
    }
}
