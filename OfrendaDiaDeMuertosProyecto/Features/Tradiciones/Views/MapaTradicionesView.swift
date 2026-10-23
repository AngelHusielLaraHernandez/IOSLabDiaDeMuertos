//
//  MapaTradicionesView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI
import MapKit

struct MapaTradicionesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var exploracion = ExploracionGeografica()
    @State private var seleccionado: String?
    @State private var posicion: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 21.5, longitude: -102.0),
        span: MKCoordinateSpan(latitudeDelta: 12, longitudeDelta: 15)))

    private var lugar: LugarCultural? { TradicionesCatalog.lugares.first { $0.id == seleccionado } }

    var body: some View {
        GeometryReader { geometria in
        NavigationStack {
            Group {
                if exploracion.lugar == nil && scenePhase == .active {
                    Map(position: $posicion, selection: $seleccionado) {
                        ForEach(TradicionesCatalog.lugares) { lugar in
                            Marker(lugar.nombre, coordinate: lugar.coordenada).tint(AppTheme.accent).tag(lugar.id)
                        }
                    }
                    .mapStyle(.standard(elevation: .flat))
                    .mapControls { MapCompass(); MapScaleView() }
                } else { AppTheme.background }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                PanelInformacionMapa(alturaMaxima: geometria.size.height * 0.42) {
                VStack(alignment: .leading, spacing: 12) {
                    if let lugar {
                        Text(lugar.nombre).font(.headline)
                        Text(lugar.region).font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                        Button("Explorar lugar", systemImage: "map") { exploracion.lugar = lugar }
                            .frame(maxWidth: .infinity, minHeight: 44).ofrendaPrimaryAction()
                    } else {
                        Text("Toca un lugar para conocerlo").font(.headline)
                        Text("Este mapa reúne los puntos de referencia del catálogo. No representa todas las celebraciones de México.")
                            .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                    }
                }.padding(20).frame(maxWidth: .infinity, alignment: .leading).background(AppTheme.background)
                }
            }
            .navigationTitle("Mapa de tradiciones").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cerrar") { dismiss() } } }
            .fullScreenCover(item: $exploracion.lugar) { lugar in ExploradorLugarView(lugar: lugar) }
        }
        .preferredColorScheme(.dark).tint(AppTheme.accent)
        }
    }
}
