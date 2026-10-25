//
//  CreditosView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct CreditosView: View {
    let onVerGuia: () -> Void
    private let integrantes = [
        "Angel Husiel Lara Hernandez",
        "Adolfo de Jesus Garcia Cortes",
        "Victor Jaziel Flores Colin",
        "Rodrigo Lugo Manzano"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Créditos").font(.largeTitle.bold()).accessibilityAddTraits(.isHeader)
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(Array(integrantes.enumerated()), id: \.offset) { indice, nombre in
                        Text(nombre).font(.title3.weight(.semibold))
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if indice < integrantes.count - 1 { Divider().overlay(AppTheme.secondaryText.opacity(0.25)) }
                    }
                }
                Text("Hecho en el iOS Development Lab.")
                    .font(.body.weight(.medium)).foregroundStyle(AppTheme.accent)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 8)
                Button("Volver a ver la guía", systemImage: "questionmark.circle") { onVerGuia() }
                    .ofrendaSecondaryAction()
                    .frame(minHeight: 44)
                    .accessibilityIdentifier("creditos.verGuia")
            }
            .frame(maxWidth: 600, alignment: .leading)
            .padding(24).frame(maxWidth: .infinity, alignment: .center)
        }
        .foregroundStyle(.white)
        .background(AppTheme.background.ignoresSafeArea())
    }
}
