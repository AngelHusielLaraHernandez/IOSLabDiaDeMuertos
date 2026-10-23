//
//  CelebracionesView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct CelebracionesView: View {
    let onExplorarElementos: () -> Void
    @EnvironmentObject private var recorrido: ProgresoRecorridoStore
    @State private var bloqueo: CelebracionCultural?
    @State private var mostrarMapaNacional = false
    @State private var seleccion: CelebracionCultural?

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(recorrido.cantidad) de \(recorrido.total) historias exploradas").font(.headline)
                ProgressView(value: Double(recorrido.cantidad), total: Double(recorrido.total)).tint(AppTheme.accent)
                Text("Abre historias desde el altar o desde Elementos. Tu recorrido se conserva y desbloquea estas celebraciones.")
                    .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
            }
            .padding(.bottom, 8)
            ForEach(TradicionesCatalog.celebraciones) { celebracion in
                Button {
                    if recorrido.desbloqueada(celebracion) { seleccion = celebracion }
                    else { bloqueo = celebracion }
                } label: {
                    HStack(alignment: .top, spacing: 16) {
                        Image(systemName: celebracion.simbolo)
                            .font(.title2).foregroundStyle(AppTheme.accent)
                            .frame(width: 48, height: 48)
                            .background(.white.opacity(0.08), in: .circle)
                            .accessibilityHidden(true)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(celebracion.nombre).font(.headline)
                            Text(celebracion.lugar.region).font(.caption).foregroundStyle(AppTheme.accent)
                            Text(celebracion.resumen).font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                            if !recorrido.desbloqueada(celebracion) {
                                Label("Explora \(celebracion.historiasRequeridas) historias para desbloquear", systemImage: "lock")
                                    .font(.caption).foregroundStyle(AppTheme.accent)
                            }
                        }
                        Spacer(minLength: 0)
                        Image(systemName: "chevron.right").font(.caption.bold()).foregroundStyle(AppTheme.secondaryText)
                    }
                    .padding(16).frame(maxWidth: .infinity, alignment: .leading)
                    .ofrendaSurface()
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("celebracion.\(celebracion.id)")
                .accessibilityHint(recorrido.desbloqueada(celebracion) ? "Abre la historia de esta celebración" : "Se desbloquea al explorar \(celebracion.historiasRequeridas) historias de elementos")
            }
            if recorrido.completo {
                Label("Guardián de la Tradición", systemImage: "seal.fill")
                    .font(.title3.bold()).foregroundStyle(AppTheme.accent).padding(.top, 12)
                Text("Exploraste los 13 elementos. Ahora puedes recorrer todos los lugares del catálogo en un solo mapa.")
                    .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                Button("Ver mapa de tradiciones", systemImage: "map") { mostrarMapaNacional = true }
                    .frame(maxWidth: .infinity, minHeight: 44).ofrendaPrimaryAction()
            } else {
                Text("Al explorar los 13 elementos recibirás la insignia Guardián de la Tradición y el mapa completo del catálogo.")
                    .font(.footnote).foregroundStyle(AppTheme.secondaryText).padding(.top, 12)
                Button("Explorar elementos", action: onExplorarElementos)
                    .frame(minHeight: 44).ofrendaSecondaryAction()
            }
        }
        .alert("Sigue descubriendo", isPresented: Binding(get: { bloqueo != nil }, set: { if !$0 { bloqueo = nil } })) {
            Button("Ver elementos") { bloqueo = nil; onExplorarElementos() }
            Button("Ahora no", role: .cancel) { bloqueo = nil }
        } message: {
            Text("Para conocer \(bloqueo?.nombre ?? "esta celebración"), explora \(bloqueo?.historiasRequeridas ?? 3) historias. Llevas \(recorrido.cantidad) de 13. Puedes abrirlas desde Elementos o desde el altar.")
        }
        .fullScreenCover(isPresented: $mostrarMapaNacional) { MapaTradicionesView() }
        .sheet(item: $seleccion) { celebracion in
            CelebracionDetalleView(celebracion: celebracion).ofrendaSheet(detents: [.large])
        }
    }
}

private struct CelebracionDetalleView: View {
    let celebracion: CelebracionCultural
    @Environment(\.dismiss) private var dismiss
    @StateObject private var exploracion = ExploracionGeografica()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(celebracion.nombre).font(.largeTitle.bold())
                    Text(celebracion.resumen).font(.title3).foregroundStyle(AppTheme.secondaryText)
                    Text(celebracion.historia).lineSpacing(4)
                    Text("Una tradición que crece").font(.headline)
                    Text(celebracion.datoDestacado).lineSpacing(4)
                    if celebracion.id == "megaofrenda-unam" {
                        Link("UNAM · Historia y sedes de la Megaofrenda", destination: URL(string: "https://www.iia.unam.mx/sites/default/files/2025-10/media_kit_megaofrenda_2025_vers27Oct.pdf")!)
                            .font(.footnote).frame(minHeight: 44)
                    }
                    Text(celebracion.referenciaTemporal).font(.headline).foregroundStyle(AppTheme.accent)
                    Text(celebracion.avisoEdicion).font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                    Link("Consultar información oficial", destination: celebracion.fuente.url)
                        .frame(minHeight: 44)
                    Text("Revisión editorial: \(celebracion.verificadoEl)")
                        .font(.footnote).foregroundStyle(AppTheme.secondaryText)
                    TarjetaLugarView(lugar: celebracion.lugar)
                    Text(celebracion.lugar.avisoVisita).font(.footnote).foregroundStyle(AppTheme.secondaryText)
                }
                .padding(24).frame(maxWidth: 640, alignment: .leading).frame(maxWidth: .infinity)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Celebración").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Listo") { dismiss() } } }
            .environmentObject(exploracion)
            .fullScreenCover(item: $exploracion.lugar) { lugar in ExploradorLugarView(lugar: lugar) }
        }
    }
}
