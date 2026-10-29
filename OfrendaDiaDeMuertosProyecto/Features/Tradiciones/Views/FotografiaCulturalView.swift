//
//  FotografiaCulturalView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI


struct FotografiaCulturalView: View {
    let lugar: LugarCultural
    var altura: CGFloat = 200
    var incluirCredito = true
    @State private var imagen: UIImage?
    @State private var cargando = true
    @State private var mostrarCredito = false

    var body: some View {
        if let foto = FotografiasCulturales.foto(para: lugar) {
            VStack(alignment: .leading, spacing: 8) {
                GeometryReader { geometria in
                    Group {
                        if let imagen {
                            Image(uiImage: imagen).resizable().scaledToFill()
                        } else if cargando {
                            ProgressView("Cargando fotografía…")
                        } else {
                            Label("Fotografía no disponible", systemImage: "photo")
                                .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                        }
                    }
                    .frame(width: geometria.size.width, height: geometria.size.height)
                    .clipped()
                }
                .frame(height: altura)
                .background(AppTheme.surface)
                .clipShape(.rect(cornerRadius: 16))
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(foto.descripcion)
                .accessibilityIdentifier("tradicion.foto.\(lugar.id)")
                Text(foto.pie).font(.caption).foregroundStyle(AppTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
                if !incluirCredito {
                    Text("Foto: \(foto.credito)" + (foto.urlLicencia != nil ? " · \(foto.licencia)" : ""))
                        .font(.caption2).foregroundStyle(AppTheme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                if incluirCredito {
                    Button("Fotografía y fuente", systemImage: "info.circle") { mostrarCredito = true }
                        .font(.caption).frame(minHeight: 44, alignment: .leading)
                        .buttonStyle(.plain).foregroundStyle(AppTheme.accent)
                }
            }
            .task(id: foto.archivo) {
                imagen = nil; cargando = true
                do { imagen = try await FotografiasCulturalesLoader.shared.imagen(archivo: foto.archivo) }
                catch is CancellationError { return }
                catch { imagen = nil }
                cargando = false
            }
            .sheet(isPresented: $mostrarCredito) {
                NavigationStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(foto.pie).font(.title3.bold())
                            Text("Fotografía: \(foto.credito)")
                            Text(foto.licencia).font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                            Text("Imagen de archivo o de contexto. El punto del mapa es una referencia de la localidad; no confirma el acceso a este altar ni una instalación en la edición actual.")
                                .font(.footnote).foregroundStyle(AppTheme.secondaryText)
                            Link("Ver publicación original", destination: foto.fuente).frame(minHeight: 44)
                            if let licencia = foto.urlLicencia {
                                Link("Consultar licencia", destination: licencia).frame(minHeight: 44)
                                Text("Redimensionada y comprimida para la app. Las tarjetas pueden mostrar un recorte del encuadre.")
                                    .font(.footnote).foregroundStyle(AppTheme.secondaryText)
                            }
                        }.padding(24)
                    }
                    .background(AppTheme.background.ignoresSafeArea())
                    .navigationTitle("Fotografía").navigationBarTitleDisplayMode(.inline)
                    .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Listo") { mostrarCredito = false } } }
                }.ofrendaSheet(detents: [.medium, .large])
            }
        }
    }
}
