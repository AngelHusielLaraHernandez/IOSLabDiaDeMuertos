//
//  MapasCulturales.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import MapKit
import UIKit
import Combine

@MainActor
final class ExploracionGeografica: ObservableObject {
    @Published var lugar: LugarCultural?
}

enum TransporteCultural: String, CaseIterable, Identifiable {
    case automovil = "Automóvil", transportePublico = "Transporte público", caminando = "Caminando"
    var id: String { rawValue }
    var simbolo: String {
        switch self { case .automovil: "car"; case .transportePublico: "tram"; case .caminando: "figure.walk" }
    }
    var modoMapas: String {
        switch self {
        case .automovil: MKLaunchOptionsDirectionsModeDriving
        case .transportePublico: MKLaunchOptionsDirectionsModeTransit
        case .caminando: MKLaunchOptionsDirectionsModeWalking
        }
    }
}

@MainActor
enum MapasCulturales {
    /// Solo entrega el destino público. La ubicación del usuario la administra Apple Maps.
    static func abrir(_ lugar: LugarCultural, transporte: TransporteCultural) -> Bool {
        let item = MKMapItem(location: CLLocation(latitude: lugar.latitud, longitude: lugar.longitud), address: nil)
        item.name = lugar.referencia
        return item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: transporte.modoMapas])
    }
}

/// Caché breve y únicamente en memoria: no descarga mapas para uso sin conexión.
@MainActor
final class MiniaturasMapas {
    static let shared = MiniaturasMapas()
    private let cache = NSCache<NSString, UIImage>()
    private init() { cache.totalCostLimit = 6 * 1024 * 1024; cache.countLimit = 12 }

    func imagen(para lugar: LugarCultural) async throws -> UIImage {
        if let image = cache.object(forKey: lugar.id as NSString) { return image }
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: lugar.coordenada, latitudinalMeters: 5000, longitudinalMeters: 5000)
        options.size = CGSize(width: 640, height: 240)
        options.scale = 1
        options.traitCollection = UITraitCollection(userInterfaceStyle: .dark)
        options.preferredConfiguration = MKStandardMapConfiguration(elevationStyle: .flat)
        let snapshotter = MKMapSnapshotter(options: options)
        let snapshot = try await withTaskCancellationHandler {
            try await snapshotter.start()
        } onCancel: { snapshotter.cancel() }
        try Task.checkCancellation()
        cache.setObject(snapshot.image, forKey: lugar.id as NSString, cost: 640 * 240 * 4)
        return snapshot.image
    }
}
