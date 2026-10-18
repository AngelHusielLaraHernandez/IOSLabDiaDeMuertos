//
//  ElementSheetControls.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct ElementSheetHeader: View {
    let icono: String
    let subtitulo: String
    let titulo: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack(spacing: 12) {
            Text(icono)
                .font(.title)
                .frame(width: 44, height: 44)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text(subtitulo.uppercased())
                    .font(.caption2.weight(.bold))
                    .tracking(0.6)
                    .foregroundStyle(AppTheme.accent)
                Text(titulo)
                    .font(.title3.bold())
                    .accessibilityAddTraits(.isHeader)
            }
            Spacer(minLength: 4)
            GlassIconButton(systemImage: "xmark", label: "Cerrar detalle") { dismiss() }
        }
    }
}

struct SheetSectionPicker: View {
    let secciones: [String]
    @Binding var seleccion: Int
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        if dynamicTypeSize.isAccessibilitySize {
            Picker("Sección del elemento", selection: $seleccion) {
                ForEach(secciones.indices, id: \.self) { indice in
                    Text(secciones[indice]).tag(indice)
                }
            }
            .pickerStyle(.menu)
            .ofrendaSecondaryAction()
        } else {
            Picker("Sección del elemento", selection: $seleccion) {
                ForEach(secciones.indices, id: \.self) { indice in
                    Text(secciones[indice]).tag(indice)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}
