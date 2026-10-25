//
//  ListaMisOfrendasView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Adolfo G on 21/10/26.
//

import SwiftUI

struct ListaMisOfrendasView: View {
    @EnvironmentObject var ofrendasManager: OfrendasManager
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
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
                    HStack(spacing: 12) {
                        Button {
                            withAnimation { editMode = editMode == .active ? .inactive : .active }
                        } label: {
                            etiquetaAccion(editMode == .active ? "Terminar" : "Eliminar", simbolo: editMode == .active ? "checkmark" : "trash")
                        }
                        .buttonStyle(.glass).buttonBorderShape(.capsule).controlSize(.regular).tint(AppTheme.accent)
                        .accessibilityLabel(editMode == .active ? "Terminar de eliminar" : "Eliminar ofrenda")
                        .disabled(ofrendasManager.ofrendas.isEmpty)
                        .accessibilityIdentifier("ofrendas.eliminar")
                        .objetivoGuiaContextual("ofrendas.eliminar")
                        Spacer(minLength: 4)
                        Button {
                            editMode = .inactive
                            nuevaOfrenda = PersonalizacionOfrenda()
                            mostrandoNuevaOfrenda = true
                        } label: {
                            etiquetaAccion("Crear", simbolo: "plus")
                        }
                        .buttonStyle(.glassProminent).buttonBorderShape(.capsule).controlSize(.regular)
                        .tint(AppTheme.accent).foregroundStyle(.black)
                        .accessibilityLabel("Crear ofrenda")
                        .accessibilityIdentifier("ofrendas.crear")
                        .objetivoGuiaContextual("ofrendas.crear")
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    .listRowBackground(AppTheme.background)
                }
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
                        ForEach(ofrendasManager.ofrendasGuardadas) { ofrenda in
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
                                    EditorOfrendaView(ofrenda: ofrenda, renderSession: renderSession, isActive: isActive,
                                                      onSalir: onSalir, onGuardar: {})
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
            .safeAreaInset(edge: .bottom) {
                HStack { Spacer(); AyudaGuiaContextualButton() }.padding(.horizontal, 24).padding(.vertical, 8)
            }
            .alert("No se pudo cambiar la ofrenda", isPresented: Binding(
                get: { ofrendasManager.mensajeErrorSeleccion != nil },
                set: { if !$0 { ofrendasManager.mensajeErrorSeleccion = nil } }
            )) {
                Button("Entendido", role: .cancel) { ofrendasManager.mensajeErrorSeleccion = nil }
            } message: { Text(ofrendasManager.mensajeErrorSeleccion ?? "") }
            .navigationDestination(isPresented: $mostrandoNuevaOfrenda) {
                EditorOfrendaView(ofrenda: nuevaOfrenda, renderSession: renderSession, isActive: isActive,
                    onSalir: { mostrandoNuevaOfrenda = false; onSalir() },
                    onGuardar: { mostrandoNuevaOfrenda = false })
            }
        }
        .guiaContextual(.misOfrendas)
    }
    @ViewBuilder private func etiquetaAccion(_ titulo: String, simbolo: String) -> some View {
        if dynamicTypeSize.isAccessibilitySize {
            Image(systemName: simbolo).font(.system(size: 20, weight: .semibold)).frame(minWidth: 32, minHeight: 32)
        } else {
            Label(titulo, systemImage: simbolo).font(.subheadline.weight(.semibold)).frame(minHeight: 32)
        }
    }

    private func nombre(_ ofrenda: PersonalizacionOfrenda) -> String {
        ofrenda.nombresResumen.isEmpty ? "Ofrenda sin nombre" : ofrenda.nombresResumen
    }

}

/// Mantiene el borrador y los almacenes estables mientras se editan los campos.
/// Salir sin Guardar no modifica los perfiles que se muestran en la lista.
private struct EditorOfrendaView: View {
    @State private var borrador: PersonalizacionOfrenda
    @State private var fotos: FotosMarcosStore
    @State private var elementos: ElementosOfrendaStore
    let renderSession: OfrendaRenderSession
    let isActive: Bool
    let onSalir: () -> Void
    let onGuardar: () -> Void
    init(ofrenda: PersonalizacionOfrenda, renderSession: OfrendaRenderSession, isActive: Bool,
         onSalir: @escaping () -> Void, onGuardar: @escaping () -> Void) {
        _borrador = State(initialValue: ofrenda)
        _fotos = State(initialValue: FotosMarcosStore(idOfrenda: ofrenda.id))
        _elementos = State(initialValue: ElementosOfrendaStore(idOfrenda: ofrenda.id))
        self.renderSession = renderSession; self.isActive = isActive
        self.onSalir = onSalir; self.onGuardar = onGuardar
    }
    var body: some View {
        OfrendaPersonalizadaFlowView(personalizacion: $borrador, renderSession: renderSession,
            fotosMarcos: fotos, elementosStore: elementos, isActive: isActive,
            onSalir: onSalir, onGuardar: onGuardar)
    }
}
