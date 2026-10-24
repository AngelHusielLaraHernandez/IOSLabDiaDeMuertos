//
//  ElementSheetControls.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct ElementSheetHeader: View {
    let icono: IlustracionOfrenda
    let subtitulo: String
    let titulo: String
    var onGuardar: (() -> Void)? = nil
    var guardarDeshabilitado = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        if onGuardar != nil && dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: 12) {
                cabecera
                accionGuardar.frame(maxWidth: .infinity)
            }
        } else {
            HStack(spacing: 12) {
                cabecera
                if onGuardar != nil { accionGuardar }
                else { GlassIconButton(systemImage: "xmark", label: "Cerrar detalle") { dismiss() } }
            }
        }
    }

    private var cabecera: some View {
        HStack(spacing: 12) {
            IlustracionOfrendaView(tipo: icono, tamano: 44)
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
        }
    }

    private var accionGuardar: some View {
        Button("Guardar") { onGuardar?() }
            .fixedSize(horizontal: true, vertical: false)
            .frame(minHeight: 44)
            .ofrendaPrimaryAction()
            .disabled(guardarDeshabilitado)
            .accessibilityHint("Guarda las fotografías y la disposición de los marcos y vuelve a la ofrenda.")
            .accessibilityIdentifier("marcos.guardar")
    }
}

struct SheetSectionPicker: View {
    let secciones: [String]
    @Binding var seleccion: Int
    var titulo = "Sección del elemento"
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        if dynamicTypeSize.isAccessibilitySize || secciones.count > 4 {
            Picker(titulo, selection: $seleccion) {
                ForEach(secciones.indices, id: \.self) { indice in
                    Text(secciones[indice]).tag(indice)
                }
            }
            .pickerStyle(.menu)
            .ofrendaSecondaryAction()
        } else {
            Picker(titulo, selection: $seleccion) {
                ForEach(secciones.indices, id: \.self) { indice in
                    Text(secciones[indice]).tag(indice)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}
