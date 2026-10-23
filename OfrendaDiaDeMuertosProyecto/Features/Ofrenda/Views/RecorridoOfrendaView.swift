//
//  RecorridoOfrendaView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

/// Los checks reflejan historias abiertas; no se marcan manualmente.
struct RecorridoOfrendaView: View {
    let elementos: [ElementoOfrenda]
    let visitados: Set<String>
    let ocultos: Int
    let puedeAbrir: Bool
    let onElegir: (ElementoOfrenda) -> Void
    @Environment(\.dismiss) private var dismiss

    private var pendientes: [ElementoOfrenda] { elementos.filter { !visitados.contains($0.nombre) } }
    private var completados: [ElementoOfrenda] { elementos.filter { visitados.contains($0.nombre) } }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("TU RECORRIDO").font(.caption.bold()).tracking(0.8).foregroundStyle(AppTheme.accent)
                    Text("\(completados.count) de \(elementos.count) historias exploradas").font(.title2.bold())
                    Text(pendientes.isEmpty && !elementos.isEmpty ? "Ya conociste cada elemento de tu ofrenda." : "Toca un elemento pendiente para acercarte y conocer su historia.")
                        .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                }
                Spacer(minLength: 8)
                GlassIconButton(systemImage: "xmark", label: "Cerrar recorrido") { dismiss() }
            }
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    if elementos.isEmpty {
                        Text("Activa elementos desde Mi ofrenda para empezar tu recorrido.")
                            .foregroundStyle(AppTheme.secondaryText).padding(.vertical)
                    }
                    if !pendientes.isEmpty { seccion("POR DESCUBRIR", elementos: pendientes, visitado: false) }
                    if !completados.isEmpty { seccion("YA EXPLORADOS", elementos: completados, visitado: true) }
                    if ocultos > 0 {
                        Text("\(ocultos) elementos ocultos no cuentan en este recorrido. Sus historias siguen disponibles en Historias.")
                            .font(.footnote).foregroundStyle(AppTheme.secondaryText).padding(.vertical, 10)
                    }
                }
            }.recortaIlustraciones()
            Button { dismiss() } label: {
                Text("Seguir explorando").frame(maxWidth: .infinity).padding(.vertical, 8)
            }
            .ofrendaPrimaryAction()
        }
        .padding(24)
        .background(AppTheme.background.ignoresSafeArea())
        .ilustracionesOfrenda()
    }

    private func seccion(_ titulo: String, elementos: [ElementoOfrenda], visitado: Bool) -> some View {
        Group {
            Text(titulo).font(.caption.bold()).tracking(0.6).foregroundStyle(AppTheme.secondaryText)
                .padding(.top, 8).accessibilityAddTraits(.isHeader)
            ForEach(elementos) { elemento in
                Button { onElegir(elemento) } label: {
                    HStack(spacing: 12) {
                        IlustracionOfrendaView(tipo: elemento.icono, tamano: 40)
                        Text(elemento.nombre).font(.subheadline.weight(.semibold))
                        Spacer(minLength: 4)
                        Image(systemName: visitado ? "checkmark.circle.fill" : "circle")
                            .font(.title3).foregroundStyle(visitado ? AppTheme.accent : AppTheme.secondaryText)
                    }
                    .padding(12).contentShape(.rect(cornerRadius: 18))
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 18))
                .accessibilityLabel(elemento.nombre)
                .accessibilityValue(visitado ? "Visitado" : "Pendiente")
                .accessibilityHint("Abre el elemento de tu ofrenda")
                .disabled(!puedeAbrir)
            }
        }
    }
}
