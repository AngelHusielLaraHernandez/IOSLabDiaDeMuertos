//
//  OfrendaRenderConfiguration.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import UIKit
import SwiftUI
import RealityKit

@MainActor
enum OfrendaRenderConfiguration {
    static func apply(to view: ARView) {
        view.environment.background = .color(UIColor(AppTheme.background))
        view.renderOptions = [.disableMotionBlur, .disableDepthOfField, .disableCameraGrain]
        #if targetEnvironment(simulator)
        // Evita técnicas de sombras/HDR no soportadas por algunas GPU del simulador.
        view.renderOptions.formUnion([.disableHDR, .disableGroundingShadows])
        #endif
    }

    static func release(_ view: ARView) {
        view.scene.anchors.removeAll()
        view.gestureRecognizers?.forEach { view.removeGestureRecognizer($0) }
    }
}
