//
//  OfrendaViewportState.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import CoreGraphics

struct MarcoProjection: Equatable {
    let corners: [CGPoint]
    var bounds: CGRect {
        corners.reduce(CGRect.null) { $0.union(CGRect(origin: $1, size: CGSize(width: 0.1, height: 0.1))) }
    }
}

struct OfrendaViewportState: Equatable {
    var positions: [String: CGPoint] = [:]
    var zoomFactor: Float = 1
    var frameProjections: [MarcoOfrenda: MarcoProjection] = [:]
}

struct OfrendaFocusRequest: Equatable {
    let id = UUID()
    let elementID: String
}
