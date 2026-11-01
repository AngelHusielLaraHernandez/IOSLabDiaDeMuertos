//
//  VistaFuentesElemento.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct VistaFuentesElemento: View {
    let nombreElemento: String
    let hitos: [HitoHistorico]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ElementSheetHeader(icono: .fuentes, subtitulo: "Historia, significado y contexto", titulo: nombreElemento)
            ControlLecturaView(texto: TextoLecturaOfrenda.fuentes(nombre: nombreElemento, hitos: hitos))
                .objetivoGuiaContextual("fuentes.voz")
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text(TextoLecturaOfrenda.introduccionFuentes)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                    ForEach(hitos.flatMap { $0.fuentes }) { fuente in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(fuente.periodo) · \(fuente.titulo)")
                                .font(.headline)
                                .foregroundStyle(AppTheme.accent)
                            Text(fuente.detalle)
                                .font(.subheadline)
                            if let url = fuente.url {
                                Link(destination: url) {
                                    Label(fuente.referencia, systemImage: "arrow.up.right.square")
                                        .font(.caption)
                                }
                                .tint(AppTheme.accent)
                            } else {
                                Text("Referencia: \(fuente.referencia)")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.secondaryText)
                            }
                        }
                        .lineSpacing(3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .ofrendaSurface()
                    }
                }
                .padding(.bottom, 16)
            }
            .objetivoGuiaContextual("fuentes.documentos")
            Button { dismiss() } label: {
                Text("Volver al elemento")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .ofrendaPrimaryAction().objetivoGuiaContextual("hoja.cerrar")
        }
        .padding(24)
        .ilustracionesOfrenda()
        .guiaContextual(.fuentes)
    }
}
