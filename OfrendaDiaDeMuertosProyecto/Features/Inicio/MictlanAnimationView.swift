//
//  MictlanAnimationView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI
import WebKit

/// Puente local de la animación existente; no carga recursos de la red.
struct MictlanAnimationView: UIViewRepresentable {
    let onEntrar: () -> Void

    func makeCoordinator() -> Coordinator { Coordinator(onEntrar: onEntrar) }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(context.coordinator, name: "bookAction")
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.isOpaque = false
        view.backgroundColor = .clear
        view.scrollView.backgroundColor = .clear
        view.scrollView.isScrollEnabled = false
        view.scrollView.contentInsetAdjustmentBehavior = .never
        if let url = Bundle.main.url(forResource: "mictlan-entrada", withExtension: "html") {
            view.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return view
    }

    func updateUIView(_ view: WKWebView, context: Context) {
        context.coordinator.onEntrar = onEntrar
    }

    static func dismantleUIView(_ view: WKWebView, coordinator: Coordinator) {
        view.stopLoading()
        view.configuration.userContentController.removeScriptMessageHandler(forName: "bookAction")
    }

    final class Coordinator: NSObject, WKScriptMessageHandler {
        var onEntrar: () -> Void
        private var haEntrado = false

        init(onEntrar: @escaping () -> Void) { self.onEntrar = onEntrar }

        func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.frameInfo.isMainFrame,
                  message.name == "bookAction",
                  let action = message.body as? String,
                  action == "opened", !haEntrado else { return }
            haEntrado = true
            onEntrar()
        }
    }
}
