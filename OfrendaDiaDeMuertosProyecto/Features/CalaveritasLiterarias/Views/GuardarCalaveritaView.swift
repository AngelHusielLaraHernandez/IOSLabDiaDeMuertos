//
//  GuardarCalaveritaView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct GuardarCalaveritaView: View {
    let calaverita: CalaveritaGuardada
    @EnvironmentObject private var store: CalaveritasStore
    @Environment(\.dismiss) private var dismiss
    @FocusState private var nombreEnfocado: Bool
    @State private var nombre = ""
    @State private var errorGuardado: String?

    private var validacion: String? { store.errorNombre(nombre) }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nombre de la calaverita", text: $nombre, axis: .vertical)
                        .lineLimit(1...3)
                        .textInputAutocapitalization(.sentences)
                        .submitLabel(.done)
                        .focused($nombreEnfocado)
                        .accessibilityIdentifier("calaveritas.nombre")
                        .onSubmit { if validacion == nil { guardar() } }
                    Text("Para \(calaverita.nombrePersona) · \(nombre.count)/80 caracteres")
                        .font(.footnote).foregroundStyle(AppTheme.secondaryText)
                } header: {
                    Text("¿Con qué nombre la guardamos?")
                } footer: {
                    Text("Elige un nombre distinto para reconocer cada versión en Mis calaveritas.")
                }
                .listRowBackground(AppTheme.surface)
                if let mensaje = errorGuardado ?? validacion {
                    Section {
                        Label(mensaje, systemImage: "info.circle")
                            .font(.subheadline).foregroundStyle(AppTheme.accent)
                            .accessibilityIdentifier("calaveritas.errorNombre")
                    }.listRowBackground(AppTheme.surface)
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Guardar calaverita")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar", action: guardar)
                        .buttonStyle(.borderedProminent).tint(AppTheme.accent).foregroundStyle(.black)
                        .disabled(validacion != nil)
                        .accessibilityIdentifier("calaveritas.confirmarNombre")
                }
            }
            .onAppear { nombre = store.nombreSugerido(para: calaverita); nombreEnfocado = true }
            .onChange(of: nombre) { _, _ in errorGuardado = nil }
        }
    }

    private func guardar() {
        guard validacion == nil else { return }
        if store.guardar(calaverita, conNombre: nombre) { dismiss() }
        else { errorGuardado = store.mensajeError; store.mensajeError = nil }
    }
}
