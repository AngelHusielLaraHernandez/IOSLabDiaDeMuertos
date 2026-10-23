//
//  OfrendaRenderSession.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import UIKit
import RealityKit
import OSLog

/// Conserva el visor y el altar preparados durante la navegación; solo cambia su contenedor.
@MainActor
final class OfrendaRenderSession {
    private let logger = Logger(subsystem: "Tenshi.OfrendaDiaDeMuertosProyecto", category: "OfrendaRenderSession")
    private(set) var view: ARView?
    private var renderer: OfrendaInteractive3DView.Renderer?
    weak var altar: Entity?
    private weak var primaryHost: OfrendaRenderHost?
    private weak var detailHost: OfrendaRenderHost?
    private var owner: UUID?
    private var gestures: [(UIGestureRecognizer, Bool)] = []
    var isInspecting: Bool { detailHost != nil }

    /// Cada montaje recibe una identidad: desmontar una pantalla anterior no libera la nueva.
    func mount(owner: UUID, host: OfrendaRenderHost,
               makeRenderer: () -> (ARView, OfrendaInteractive3DView.Renderer)) -> OfrendaInteractive3DView.Renderer {
        self.owner = owner
        primaryHost = host
        let activeRenderer: OfrendaInteractive3DView.Renderer
        let activeView: ARView
        if let renderer, let view {
            activeRenderer = renderer
            activeView = view
            logger.info("Reutilizando el visor y el altar preparados")
        } else {
            let created = makeRenderer()
            activeView = created.0
            activeRenderer = created.1
            view = activeView
            renderer = activeRenderer
            logger.info("Creado el único visor 3D de la sesión")
        }
        if detailHost == nil { host.install(activeView) }
        return activeRenderer
    }

    func owns(_ owner: UUID) -> Bool { self.owner == owner }

    func unmount(owner: UUID, host: OfrendaRenderHost, discard: Bool) {
        guard owns(owner) else { return }
        self.owner = nil
        primaryHost = nil
        renderer?.suspend()
        if detailHost == nil, view?.superview === host { view?.removeFromSuperview() }
        // Un visor independiente (por ejemplo un Preview) no comparte esta caché de sesión.
        if discard, detailHost == nil {
            renderer?.dispose()
            if let view { OfrendaRenderConfiguration.release(view) }
            renderer = nil
            view = nil
            altar = nil
        }
    }

    func borrow(into host: OfrendaRenderHost) -> ARView? {
        guard let view, detailHost == nil else { return nil }
        detailHost = host
        renderer?.applyVisibility()
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
        if let primaryHost { primaryHost.install(view) }
        else { view.removeFromSuperview() }
        renderer?.applyVisibility()
    }
}

@MainActor
final class OfrendaRenderHost: UIView {
    var onLayout: (() -> Void)?
    var onWindow: (() -> Void)?

    func install(_ view: ARView) {
        guard view.superview !== self else { return }
        view.removeFromSuperview()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        setNeedsLayout()
    }

    override func layoutSubviews() { super.layoutSubviews(); onLayout?() }
    override func didMoveToWindow() { super.didMoveToWindow(); onWindow?() }
}
