//
//  OfrendaRenderSession.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import UIKit
import RealityKit

/// Un único ARView se presta a la tarjeta; el altar conserva sus entidades fuera de escena.
@MainActor
final class OfrendaRenderSession {
    private(set) var view: ARView?
    weak var altar: Entity?
    private weak var primaryHost: OfrendaRenderHost?
    private weak var detailHost: OfrendaRenderHost?
    private var gestures: [(UIGestureRecognizer, Bool)] = []
    private var ownershipChanged: (() -> Void)?
    var isInspecting: Bool { detailHost != nil }

    func register(_ view: ARView, host: OfrendaRenderHost, ownershipChanged: @escaping () -> Void) {
        self.view = view
        primaryHost = host
        self.ownershipChanged = ownershipChanged
    }

    func borrow(into host: OfrendaRenderHost) -> ARView? {
        guard let view, detailHost == nil else { return nil }
        detailHost = host
        ownershipChanged?()
        gestures = (view.gestureRecognizers ?? []).map { ($0, $0.isEnabled) }
        gestures.forEach { $0.0.isEnabled = false }
        host.install(view)
        return view
    }

    func cloneElement(nombres: [String]) async throws -> Entity {
        // Sigue disponible aunque NSCache se vacíe por presión de memoria o segundo plano.
        try await OfrendaAssets.shared.cloneElement(nombres: nombres, from: altar)
    }

    func giveBack(from host: OfrendaRenderHost) {
        guard detailHost === host, let view else { return }
        gestures.forEach { $0.0.isEnabled = $0.1 }
        gestures.removeAll()
        detailHost = nil
        primaryHost?.install(view)
        ownershipChanged?()
    }

    func unregister(_ view: ARView) {
        guard self.view === view else { return }
        gestures.removeAll()
        ownershipChanged = nil
        self.view = nil
        altar = nil
        primaryHost = nil
        detailHost = nil
    }
}

@MainActor
final class OfrendaRenderHost: UIView {
    var onLayout: (() -> Void)?
    var onWindow: (() -> Void)?

    func install(_ view: ARView) {
        view.removeFromSuperview()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    override func layoutSubviews() { super.layoutSubviews(); onLayout?() }
    override func didMoveToWindow() { super.didMoveToWindow(); onWindow?() }
}
