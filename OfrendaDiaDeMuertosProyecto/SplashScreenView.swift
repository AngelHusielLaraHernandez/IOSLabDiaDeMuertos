//
//  SplashScreenView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Adolfo G on 14/10/26.
//

import SwiftUI
import WebKit

struct HTMLAnimationView: UIViewRepresentable {
    var onAction: (String) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, WKScriptMessageHandler {
        var parent: HTMLAnimationView
        init(_ parent: HTMLAnimationView) { self.parent = parent }

        func userContentController(_ c: WKUserContentController,
                                   didReceive message: WKScriptMessage) {
            if message.name == "bookAction", let action = message.body as? String {
                DispatchQueue.main.async { self.parent.onAction(action) }
            }
        }
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(context.coordinator, name: "bookAction")

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        if let url = Bundle.main.url(forResource: "mictlan-entrada", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct SplashScreenView: View {
    @Binding var showSplash: Bool

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.04, blue: 0.12)
                .ignoresSafeArea()

            HTMLAnimationView { action in
                if action == "opened" {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
    }
}

#Preview { SplashScreenView(showSplash: .constant(true)) }
