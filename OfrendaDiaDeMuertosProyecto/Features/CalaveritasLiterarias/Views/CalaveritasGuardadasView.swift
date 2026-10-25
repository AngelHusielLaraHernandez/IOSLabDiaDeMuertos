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
                        HStack(alignment: .center, spacing: 12) {
                            NavigationLink {
                                CalaveritaGuardadaDetalleView(calaverita: calaverita)
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(calaverita.tituloVisible).font(.headline)
                                    Text("Para \(calaverita.nombrePersona)")
                                        .font(.subheadline).foregroundStyle(AppTheme.accent)
                                    Text(calaverita.fechaCreacion, format: .dateTime.day().month(.wide).year().hour().minute())
                                        .font(.caption).foregroundStyle(AppTheme.secondaryText)
                                    Text(vistaPrevia(calaverita.texto))
                                        .font(.subheadline).foregroundStyle(AppTheme.secondaryText).lineLimit(2)
                                }.padding(.vertical, 8)
                            }
                            ShareLink(item: calaverita.textoParaCompartir) {
                                Image(systemName: "square.and.arrow.up")
                                    .frame(minWidth: 44, minHeight: 44)
                            }
                            .buttonStyle(.borderless)
                            .accessibilityLabel("Compartir \(calaverita.tituloVisible)")
                        }
                        .listRowBackground(AppTheme.surface.opacity(0.72))
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .objetivoGuiaContextual("calaveritas.coleccion")
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Mis calaveritas")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { AyudaGuiaContextualButton() }
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
        .guiaContextual(.calaveritasGuardadas)
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
                Text(calaverita.tituloVisible).font(.title2.bold())
                Text("Para \(calaverita.nombrePersona)")
                    .font(.headline).foregroundStyle(AppTheme.accent)
                Text(calaverita.fechaCreacion, format: .dateTime.day().month(.wide).year())
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
                CalaveritaTextoView(texto: calaverita.texto)
                    .padding(20)
                    .ofrendaSurface()
                ShareLink(item: calaverita.textoParaCompartir) {
                    Label("Compartir calaverita", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .ofrendaSecondaryAction()
                .accessibilityIdentifier("calaveritas.guardadaCompartir")
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
