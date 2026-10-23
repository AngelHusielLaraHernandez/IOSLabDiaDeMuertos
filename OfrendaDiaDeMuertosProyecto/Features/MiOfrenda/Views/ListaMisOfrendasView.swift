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
            Group {
                if ofrendasManager.ofrendas.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 50))
                            .foregroundStyle(AppTheme.accent)
                        Text("Sin ofrendas")
                            .font(.title2).bold().foregroundColor(.white)
                        
                        Button("Crear mi primera ofrenda") {
                            nuevaOfrenda = PersonalizacionOfrenda()
                            mostrandoNuevaOfrenda = true
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(AppTheme.accent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach($ofrendasManager.ofrendas) { $ofrenda in
                            NavigationLink(destination:
                                OfrendaPersonalizadaFlowView(
                                    personalizacion: $ofrenda,
                                    renderSession: renderSession,
                                    fotosMarcos: FotosMarcosStore(idOfrenda: ofrenda.id),
                                    elementosStore: ElementosOfrendaStore(idOfrenda: ofrenda.id),
                                    isActive: isActive,
                                    onSalir: onSalir
                                )
                            ) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(ofrenda.nombre.isEmpty ? "Ofrenda en progreso" : ofrenda.nombre)
                                        .font(.headline).foregroundColor(.white)
                                    if !ofrenda.comidaFavorita.isEmpty {
                                        Text(ofrenda.comidaFavorita)
                                            .font(.subheadline).foregroundColor(AppTheme.secondaryText)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(AppTheme.surface.opacity(0.8))
                        }
                        .onDelete(perform: ofrendasManager.eliminarOfrenda)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Mis Ofrendas")
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
                            }
                        }
                        
                        Button(action: {
                            nuevaOfrenda = PersonalizacionOfrenda()
                            mostrandoNuevaOfrenda = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3).foregroundStyle(AppTheme.accent)
                        }
                    }
                }
            }
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
                    }
                )
            }
        }
    }
}
