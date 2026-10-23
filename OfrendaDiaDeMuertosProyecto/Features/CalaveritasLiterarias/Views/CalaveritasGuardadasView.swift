//
//  CalaveritasGuardadasView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct CalaveritasGuardadasView: View {
    @EnvironmentObject private var store: CalaveritasStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if store.calaveritas.isEmpty {
                    ContentUnavailableView {
                        Label("Aún no guardas calaveritas", systemImage: "books.vertical")
                    } description: {
                        Text("Genera una y toca Guardar calaverita. Aquí podrás volver a leerla cuando quieras.")
                    } actions: {
                        Button("Volver a crear") { dismiss() }
                            .ofrendaPrimaryAction()
                    }
                } else {
                    List(store.calaveritas) { calaverita in
                        NavigationLink {
                            CalaveritaGuardadaDetalleView(calaverita: calaverita)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Para \(calaverita.nombrePersona)").font(.headline)
                                Text(calaverita.fechaCreacion, format: .dateTime.day().month(.wide).year().hour().minute())
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.secondaryText)
                                Text(vistaPrevia(calaverita.texto))
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.secondaryText)
                                    .lineLimit(2)
                            }
                            .padding(.vertical, 8)
                        }
                        .listRowBackground(AppTheme.surface.opacity(0.72))
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Mis calaveritas")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                }
            }
            .onAppear { store.cargar() }
            .alert("Tus calaveritas", isPresented: Binding(
                get: { store.mensajeError != nil },
                set: { if !$0 { store.mensajeError = nil } }
            )) {
                Button("Reintentar") { store.cargar() }
                Button("Entendido", role: .cancel) { store.mensajeError = nil }
            } message: { Text(store.mensajeError ?? "") }
        }
    }

    private func vistaPrevia(_ texto: String) -> AttributedString {
        var opciones = AttributedString.MarkdownParsingOptions()
        opciones.interpretedSyntax = .inlineOnlyPreservingWhitespace
        return (try? AttributedString(markdown: texto.components(separatedBy: "\n\n").first ?? texto, options: opciones))
            ?? AttributedString(texto)
    }
}

private struct CalaveritaGuardadaDetalleView: View {
    let calaverita: CalaveritaGuardada

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Para \(calaverita.nombrePersona)")
                    .font(.title2.bold())
                Text(calaverita.fechaCreacion, format: .dateTime.day().month(.wide).year())
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
                CalaveritaTextoView(texto: calaverita.texto)
                    .padding(20)
                    .ofrendaSurface()
            }
            .padding(24)
            .frame(maxWidth: 640, alignment: .leading)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("Calaverita guardada")
        .navigationBarTitleDisplayMode(.inline)
    }
}
