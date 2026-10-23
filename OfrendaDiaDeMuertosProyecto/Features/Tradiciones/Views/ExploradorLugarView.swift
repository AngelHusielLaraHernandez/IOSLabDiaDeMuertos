//
//  ExploradorLugarView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI
import MapKit

struct ExploradorLugarView: View {
    let lugar: LugarCultural
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var posicion: MapCameraPosition = .automatic
    @State private var modo: Modo = .mapa
    @State private var escena: MKLookAroundScene?
    @State private var estadoCalle = "Comprobando vista de calle…"
    @State private var solicitud: MKLookAroundSceneRequest?

    private enum Modo: String, CaseIterable, Identifiable {
        case mapa = "Mapa", satelite = "Satélite", calle = "Vista de calle"
        var id: String { rawValue }
    }

    var body: some View {
        GeometryReader { geometria in
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Picker("Vista del lugar", selection: $modo) {
                        ForEach(Modo.allCases) { opcion in
                            Text(opcion.rawValue).tag(opcion).disabled(opcion == .calle && escena == nil)
                        }
                    }.pickerStyle(.menu).ofrendaSecondaryAction()
                    Spacer(minLength: 8)
                    if escena != nil && !dynamicTypeSize.isAccessibilitySize {
                        Text("Vista de calle disponible").font(.caption).foregroundStyle(AppTheme.secondaryText)
                    }
                }.padding(.horizontal, 20).padding(.vertical, 8)

                Group {
                    if modo == .calle, let escena, scenePhase == .active {
                        LookAroundPreview(initialScene: escena, allowsNavigation: true)
                    } else if scenePhase == .active {
                        Map(position: $posicion) { Marker(lugar.referencia, coordinate: lugar.coordenada).tint(AppTheme.accent) }
                            .mapStyle(modo == .satelite ? .imagery(elevation: .realistic) : .standard(elevation: .flat))
                            .mapControls { MapCompass(); MapScaleView() }
                    } else {
                        Color(AppTheme.background)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityIdentifier("tradicion.mapa.\(lugar.id)")
            }
            .background(AppTheme.background)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                PanelInformacionMapa(alturaMaxima: geometria.size.height * 0.42) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(lugar.referencia).font(.headline)
                    Text(estadoCalle).font(.caption).foregroundStyle(AppTheme.secondaryText)
                    Text("Los mapas necesitan conexión. Las imágenes pueden ser anteriores a la celebración; el relieve depende de la cobertura.")
                        .font(.caption).foregroundStyle(AppTheme.secondaryText)
                    BotonRutasView(lugar: lugar)
                }
                .padding(20).frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.background)
                }
            }
            .navigationTitle(lugar.nombre).navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cerrar") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Centrar", systemImage: "scope") { centrar() }
                        .accessibilityLabel("Centrar el mapa en \(lugar.referencia)")
                }
            }
            .onAppear { centrar() }
            .task(id: scenePhase) {
                guard scenePhase == .active else {
                    solicitud?.cancel(); escena = nil
                    return
                }
                estadoCalle = "Comprobando vista de calle…"
                let request = MKLookAroundSceneRequest(coordinate: lugar.coordenada)
                solicitud = request
                do {
                    let resultado = try await withTaskCancellationHandler {
                        try await request.scene
                    } onCancel: { request.cancel() }
                    try Task.checkCancellation()
                    escena = resultado
                    estadoCalle = resultado == nil ? "Sin vista de calle para este punto. Puedes usar Mapa o Satélite." : "Elige Vista de calle para explorar las imágenes disponibles."
                } catch is CancellationError {} catch {
                    estadoCalle = "No se pudo consultar la vista de calle. Mapa y Satélite siguen disponibles con conexión."
                }
            }
            .onChange(of: modo) { _, _ in centrar() }
            .onDisappear { solicitud?.cancel(); solicitud = nil; escena = nil }
        }
        .preferredColorScheme(.dark).tint(AppTheme.accent)
        }
    }

    private func centrar() {
        posicion = .camera(MapCamera(centerCoordinate: lugar.coordenada, distance: 3500, heading: 0, pitch: modo == .satelite ? 60 : 0))
    }
}
