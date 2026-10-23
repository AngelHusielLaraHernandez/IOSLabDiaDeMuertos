//
//  PhotoCropGeometry.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 17/10/26.
//

import Foundation
import CoreGraphics

/// La vista previa y la exportación utilizan el mismo cálculo de encuadre.
enum PhotoCropGeometry {
    nonisolated static func filledSize(image: CGSize, viewport: CGSize, zoom: CGFloat) -> CGSize {
        guard image.width > 0, image.height > 0 else { return viewport }
        let factor = max(viewport.width / image.width, viewport.height / image.height) * max(1, zoom)
        return CGSize(width: image.width * factor, height: image.height * factor)
    }

    nonisolated static func clampedOffset(_ offset: CGSize, image: CGSize, viewport: CGSize, zoom: CGFloat) -> CGSize {
        let size = filledSize(image: image, viewport: viewport, zoom: zoom)
        let maxX = max(0, (size.width - viewport.width) / 2)
        let maxY = max(0, (size.height - viewport.height) / 2)
        return CGSize(
            width: min(maxX, max(-maxX, offset.width)),
            height: min(maxY, max(-maxY, offset.height))
        )
    }

    nonisolated static func imageRect(image: CGSize, viewport: CGSize, zoom: CGFloat, offset: CGSize) -> CGRect {
        let size = filledSize(image: image, viewport: viewport, zoom: zoom)
        let offset = clampedOffset(offset, image: image, viewport: viewport, zoom: zoom)
        return CGRect(
            x: (viewport.width - size.width) / 2 + offset.width,
            y: (viewport.height - size.height) / 2 + offset.height,
            width: size.width, height: size.height
        )
    }
}
