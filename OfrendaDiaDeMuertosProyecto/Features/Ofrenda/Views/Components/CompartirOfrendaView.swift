//
//  CompartirOfrendaView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI
import UIKit
import LinkPresentation
import UniformTypeIdentifiers

/// La imagen vive solo mientras está abierta la hoja nativa de compartir.
struct CapturaOfrenda: Identifiable {
    let id = UUID()
    let imagen: UIImage
    let titulo: String
}

struct CompartirOfrendaView: UIViewControllerRepresentable {
    let captura: CapturaOfrenda

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [FuenteCapturaOfrenda(captura)], applicationActivities: nil)
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) { }
}

/// Da a la hoja una miniatura de la propia ofrenda, sin resolver enlaces en internet.
private final class FuenteCapturaOfrenda: NSObject, UIActivityItemSource {
    private let captura: CapturaOfrenda
    init(_ captura: CapturaOfrenda) { self.captura = captura }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        captura.imagen
    }

    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        captura.imagen
    }

    func activityViewController(_ activityViewController: UIActivityViewController,
                                subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        captura.titulo
    }

    func activityViewController(_ activityViewController: UIActivityViewController,
                                dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?) -> String {
        UTType.png.identifier
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = captura.titulo
        let imagen = NSItemProvider(object: captura.imagen)
        metadata.imageProvider = imagen
        metadata.iconProvider = imagen
        return metadata
    }
}
