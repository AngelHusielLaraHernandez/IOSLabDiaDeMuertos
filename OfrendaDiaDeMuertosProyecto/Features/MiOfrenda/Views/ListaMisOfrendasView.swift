//
//  ListaMisOfrendasView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Adolfo G on 21/10/26.
//

import SwiftUI

struct ListaMisOfrendasView: View {
    @EnvironmentObject var ofrendasManager: OfrendasManager
    
    let renderSession: OfrendaRenderSession
    var isActive = true
    let onSalir: () -> Void
    
    @State private var mostrandoNuevaOfrenda = false
    @State private var nuevaOfrenda = PersonalizacionOfrenda()
    @State private var editMode: EditMode = .inactive

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        ofrendasManager.seleccionarOfrendaPrincipal(nil)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: ofrendasManager.idOfrendaPrincipal == nil ? "checkmark.circle.fill" : "circle")
                                .font(.title2).foregroundStyle(AppTheme.accent)
                                .frame(minWidth: 44, minHeight: 44)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Ofrenda general").font(.headline).foregroundStyle(.white)
                                Text("El altar didáctico con todos sus elementos.")
                                    .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.borderless)
                    .disabled(editMode == .active)
                    .accessibilityElement(children: .ignore)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel("Mostrar ofrenda general")
                    .accessibilityValue(ofrendasManager.idOfrendaPrincipal == nil ? "Seleccionada" : "No seleccionada")
                    .accessibilityAddTraits(ofrendasManager.idOfrendaPrincipal == nil ? .isSelected : [])
                    .accessibilityIdentifier("ofrenda.seleccion.general")
                    .listRowBackground(AppTheme.surface.opacity(0.8))
                } footer: {
                    Text("Marca una ofrenda para verla en la pantalla principal. Toca su nombre para editarla.")
                        .foregroundStyle(AppTheme.secondaryText)
                }

                Section("Tus ofrendas") {
                    if ofrendasManager.ofrendas.isEmpty {
                        ContentUnavailableView {
                            Label("Todavía no tienes ofrendas", systemImage: "heart")
                        } description: {
                            Text("Crea una con sus fotos, gustos y recuerdos; después podrás marcarla para mostrarla.")
                        } actions: {
                            Button("Crear mi primera ofrenda") {
                                nuevaOfrenda = PersonalizacionOfrenda()
                                mostrandoNuevaOfrenda = true
                            }
                            .ofrendaPrimaryAction()
                        }
                        .listRowBackground(AppTheme.background)
                    } else {
                        ForEach($ofrendasManager.ofrendas) { $ofrenda in
                            HStack(spacing: 8) {
                                Button {
                                    ofrendasManager.seleccionarOfrendaPrincipal(ofrenda.id)
                                } label: {
                                    Image(systemName: ofrendasManager.idOfrendaPrincipal == ofrenda.id ? "checkmark.circle.fill" : "circle")
                                        .font(.title2).foregroundStyle(AppTheme.accent)
                                        .frame(minWidth: 44, minHeight: 44)
                                        .contentShape(.rect)
                                }
                                .buttonStyle(.borderless)
                                .disabled(editMode == .active)
                                .accessibilityLabel("Mostrar la ofrenda de \(nombre(ofrenda))")
                                .accessibilityValue(ofrendasManager.idOfrendaPrincipal == ofrenda.id ? "Seleccionada" : "No seleccionada")
                                .accessibilityAddTraits(ofrendasManager.idOfrendaPrincipal == ofrenda.id ? .isSelected : [])
                                .accessibilityIdentifier("ofrenda.seleccion.\(ofrenda.id.uuidString)")

                                NavigationLink(destination:
                                    OfrendaPersonalizadaFlowView(
                                        personalizacion: $ofrenda,
                                        renderSession: renderSession,
                                        fotosMarcos: FotosMarcosStore(idOfrenda: ofrenda.id),
                                        elementosStore: ElementosOfrendaStore(idOfrenda: ofrenda.id),
                                        isActive: isActive,
                                        onSalir: onSalir,
                                        onGuardar: {}
                                    )
                                ) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(nombre(ofrenda)).font(.headline).foregroundStyle(.white)
                                        if ofrendasManager.idOfrendaPrincipal == ofrenda.id {
                                            Text("En la pantalla principal")
                                                .font(.caption).foregroundStyle(AppTheme.accent)
                                        }
                                        if !ofrenda.comidaFavorita.isEmpty {
                                            Text(ofrenda.comidaFavorita)
                                                .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                                }
                            }
                            .listRowBackground(AppTheme.surface.opacity(0.8))
                        }
                        .onDelete(perform: ofrendasManager.eliminarOfrenda)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Mis ofrendas")
            .environment(\.editMode, $editMode)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 16) {
                        if !ofrendasManager.ofrendas.isEmpty {
                            Button {
                                withAnimation {
                                    editMode = (editMode == .active) ? .inactive : .active
                                }
                            } label: {
                                Image(systemName: editMode == .active ? "checkmark.circle.fill" : "minus.circle")
                                    .font(.title3).foregroundStyle(AppTheme.accent)
                                    .frame(minWidth: 44, minHeight: 44)
                            }
                            .accessibilityLabel(editMode == .active ? "Terminar de eliminar ofrendas" : "Eliminar ofrendas")
                        }
                        
                        Button(action: {
                            nuevaOfrenda = PersonalizacionOfrenda()
                            mostrandoNuevaOfrenda = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3).foregroundStyle(AppTheme.accent)
                                .frame(minWidth: 44, minHeight: 44)
                        }
                        .accessibilityLabel("Crear ofrenda")
                    }
                }
            }
            .alert("No se pudo cambiar la ofrenda", isPresented: Binding(
                get: { ofrendasManager.mensajeErrorSeleccion != nil },
                set: { if !$0 { ofrendasManager.mensajeErrorSeleccion = nil } }
            )) {
                Button("Entendido", role: .cancel) { ofrendasManager.mensajeErrorSeleccion = nil }
            } message: { Text(ofrendasManager.mensajeErrorSeleccion ?? "") }
            .sheet(isPresented: $mostrandoNuevaOfrenda) {
                OfrendaPersonalizadaFlowView(
                    personalizacion: $nuevaOfrenda,
                    renderSession: renderSession,
                    fotosMarcos: FotosMarcosStore(idOfrenda: nuevaOfrenda.id),
                    elementosStore: ElementosOfrendaStore(idOfrenda: nuevaOfrenda.id),
                    isActive: isActive,
                    onSalir: {
                        // Al salir del sheet, lo cerramos y cambiamos a la pestaña principal
                        mostrandoNuevaOfrenda = false
                        onSalir()
                    },
                    onGuardar: { mostrandoNuevaOfrenda = false }
                )
            }
        }
    }
    private func nombre(_ ofrenda: PersonalizacionOfrenda) -> String {
        ofrenda.nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Ofrenda sin nombre" : ofrenda.nombre
    }

}
