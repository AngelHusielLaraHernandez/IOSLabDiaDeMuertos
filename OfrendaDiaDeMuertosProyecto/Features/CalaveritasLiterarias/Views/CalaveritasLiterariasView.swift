//
//  CalaveritasLiterariasView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct CalaveritasLiterariasView: View {
    @EnvironmentObject private var ofrendasManager: OfrendasManager
    @EnvironmentObject private var calaveritasStore: CalaveritasStore
    let isActive: Bool
    let onPersonalizar: () -> Void

    @State private var idOfrenda: UUID?
    @State private var calaverita: CalaveritaGuardada?
    @State private var mostrandoGuardadas = false

    private var ofrendasDisponibles: [PersonalizacionOfrenda] { ofrendasManager.ofrendasParaCalaveritas }
    private var ofrenda: PersonalizacionOfrenda? {
        ofrendasDisponibles.first { $0.id == idOfrenda }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Sus recuerdos, hechos versos.")
                        .font(.title2.bold())
                    if let ofrenda {
                        generador(para: ofrenda)
                    } else {
                        accesoPendiente
                    }
                }
                .padding(24)
                .frame(maxWidth: 640, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .recortaIlustraciones()
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Calaveritas")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Guardadas", systemImage: "books.vertical") { mostrandoGuardadas = true }
                        .labelStyle(.titleOnly)
                        .accessibilityLabel("Mis calaveritas guardadas, \(calaveritasStore.calaveritas.count)")
                        .accessibilityIdentifier("calaveritas.guardadas")
                }
            }
            .ilustracionesOfrenda(activa: isActive && !mostrandoGuardadas)
            .sheet(isPresented: $mostrandoGuardadas) {
                CalaveritasGuardadasView()
                    .ofrendaSheet(detents: [.large])
            }
            .alert("Tus calaveritas", isPresented: Binding(
                get: { calaveritasStore.mensajeError != nil && !mostrandoGuardadas },
                set: { if !$0 { calaveritasStore.mensajeError = nil } }
            )) {
                Button("Entendido", role: .cancel) { calaveritasStore.mensajeError = nil }
            } message: { Text(calaveritasStore.mensajeError ?? "") }
            .onAppear(perform: seleccionarOfrendaDisponible)
            .onChange(of: ofrendasManager.ofrendasGuardadas) { _, _ in seleccionarOfrendaDisponible() }
            .onChange(of: ofrenda) { _, _ in calaverita = nil }
        }
    }

    private var accesoPendiente: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(systemName: "lock")
                .font(.largeTitle)
                .foregroundStyle(AppTheme.accent)
                .accessibilityHidden(true)
            Text("Primero, personaliza tu ofrenda")
                .font(.title3.bold())
            Text("Guarda una ofrenda con el nombre de la persona y su comida favorita para empezar a escribir.")
                .foregroundStyle(AppTheme.secondaryText)
            Text("La música, los pasatiempos y un recuerdo compartido le darán un toque más personal. Son opcionales.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
            Button("Personalizar mi ofrenda", action: onPersonalizar)
                .ofrendaPrimaryAction()
                .accessibilityIdentifier("calaveritas.personalizar")
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .ofrendaSurface()
        .accessibilityIdentifier("calaveritas.bloqueada")
    }

    @ViewBuilder
    private func generador(para ofrenda: PersonalizacionOfrenda) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("Ofrenda", selection: $idOfrenda) {
                ForEach(ofrendasDisponibles) { perfil in
                    Text(perfil.nombre).tag(Optional(perfil.id))
                }
            }
            .pickerStyle(.menu)
            .tint(AppTheme.accent)
            .accessibilityIdentifier("calaveritas.ofrenda")
            Text("Usaremos sus gustos y recuerdos guardados. Puedes cambiarlos en Mi ofrenda.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
        }

        if let calaverita {
            VStack(alignment: .leading, spacing: 20) {
                Text("Para \(calaverita.nombrePersona)")
                    .font(.title3.bold())
                    .foregroundStyle(AppTheme.accent)
                CalaveritaTextoView(texto: calaverita.texto)
                    .accessibilityIdentifier("calaveritas.poema")
            }
            .padding(20)
            .ofrendaSurface()

            Button {
                calaveritasStore.guardar(calaverita)
            } label: {
                Label(calaveritasStore.contiene(calaverita) ? "Calaverita guardada" : "Guardar calaverita",
                      systemImage: calaveritasStore.contiene(calaverita) ? "checkmark" : "bookmark")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .ofrendaPrimaryAction()
            .disabled(calaveritasStore.contiene(calaverita))
            .accessibilityIdentifier("calaveritas.guardar")

            Button("Generar otra", systemImage: "arrow.clockwise") { generar(para: ofrenda) }
                .frame(maxWidth: .infinity, minHeight: 44)
                .ofrendaSecondaryAction()
                .accessibilityIdentifier("calaveritas.generarOtra")
            if !calaveritasStore.contiene(calaverita) {
                Text("Guárdala antes de generar otra si quieres conservarla.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.secondaryText)
            }
        } else {
            VStack(alignment: .leading, spacing: 16) {
                IlustracionOfrendaView(tipo: .calaveritas, tamano: 104)
                Text("Una calaverita para \(ofrenda.nombre)")
                    .font(.title3.bold())
                Text("Sus gustos inspiran un poema con humor y cariño. Genera distintas versiones y guarda tus favoritas.")
                    .foregroundStyle(AppTheme.secondaryText)
            }
            .padding(.vertical, 12)
            Button("Generar calaverita", systemImage: "pencil.and.outline") { generar(para: ofrenda) }
                .frame(maxWidth: .infinity, minHeight: 44)
                .ofrendaPrimaryAction()
                .accessibilityIdentifier("calaveritas.generar")
        }
    }

    private func seleccionarOfrendaDisponible() {
        if !ofrendasDisponibles.contains(where: { $0.id == idOfrenda }) {
            idOfrenda = ofrendasDisponibles.first?.id
        }
    }

    private func generar(para ofrenda: PersonalizacionOfrenda) {
        let texto = CalaveritaGenerator.generar(para: ofrenda, evitando: calaverita?.texto)
        calaverita = CalaveritaGuardada(para: ofrenda, texto: texto)
    }
}
