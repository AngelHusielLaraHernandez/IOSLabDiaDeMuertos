//
//  IlustracionOfrendaView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI
import WebKit

/// Reserva el espacio del dibujo. La pantalla reúne sus anclas en una única capa HTML.
struct IlustracionOfrendaView: View {
    let tipo: IlustracionOfrenda
    var tamano: CGFloat = 48
    @State private var identidad = UUID()
    @Environment(\.limiteIlustraciones) private var limite

    var body: some View {
        Color.clear
            .frame(width: tamano, height: tamano)
            .anchorPreference(key: AnclasIlustraciones.self, value: .bounds) {
                PreferenciasIlustraciones(anclas: [identidad: AnclaIlustracion(tipo: tipo, bounds: $0, limite: limite)])
            }
            .accessibilityHidden(true)
    }
}

private struct AnclaIlustracion {
    let tipo: IlustracionOfrenda
    let bounds: Anchor<CGRect>
    let limite: UUID?
}

private struct PreferenciasIlustraciones {
    var anclas: [UUID: AnclaIlustracion] = [:]
    var limites: [UUID: Anchor<CGRect>] = [:]
}

private struct AnclasIlustraciones: PreferenceKey {
    static var defaultValue: PreferenciasIlustraciones { PreferenciasIlustraciones() }
    static func reduce(value: inout PreferenciasIlustraciones, nextValue: () -> PreferenciasIlustraciones) {
        let nueva = nextValue()
        value.anclas.merge(nueva.anclas, uniquingKeysWith: { _, nueva in nueva })
        value.limites.merge(nueva.limites, uniquingKeysWith: { _, nueva in nueva })
    }
}

private struct ClaveLimiteIlustraciones: EnvironmentKey {
    static var defaultValue: UUID? { nil }
}

private extension EnvironmentValues {
    var limiteIlustraciones: UUID? {
        get { self[ClaveLimiteIlustraciones.self] }
        set { self[ClaveLimiteIlustraciones.self] = newValue }
    }
}

private struct RecorteIlustraciones: ViewModifier {
    @State private var identidad = UUID()
    func body(content: Content) -> some View {
        content.environment(\.limiteIlustraciones, identidad)
            .transformAnchorPreference(key: AnclasIlustraciones.self, value: .bounds) { preferencias, bounds in
                preferencias.limites[identidad] = bounds
            }
    }
}

private struct MarcoIlustracion: Encodable, Equatable {
    let id: String
    let kind: String
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
    let clipTop: CGFloat
    let clipRight: CGFloat
    let clipBottom: CGFloat
    let clipLeft: CGFloat
}

private struct CapaIlustraciones: ViewModifier {
    let activa: Bool
    @State private var presente = false
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .overlayPreferenceValue(AnclasIlustraciones.self) { anclas in
                GeometryReader { geometry in
                    let limites = CGRect(origin: .zero, size: geometry.size)
                    let marcos = anclas.anclas.compactMap { id, ancla -> MarcoIlustracion? in
                        let rect = geometry[ancla.bounds]
                        guard rect.width > 0, rect.height > 0,
                              rect.minX.isFinite, rect.minY.isFinite,
                              rect.intersects(limites) else { return nil }
                        let area = ancla.limite.flatMap { anclas.limites[$0] }.map { geometry[$0] } ?? limites
                        let visible = rect.intersection(area).intersection(limites)
                        guard !visible.isEmpty, !visible.isNull else { return nil }
                        func redondear(_ n: CGFloat) -> CGFloat { (n * 2).rounded() / 2 }
                        return MarcoIlustracion(id: id.uuidString, kind: ancla.tipo.rawValue,
                                                x: redondear(rect.minX), y: redondear(rect.minY),
                                                width: redondear(rect.width), height: redondear(rect.height),
                                                clipTop: max(0, visible.minY - rect.minY),
                                                clipRight: max(0, rect.maxX - visible.maxX),
                                                clipBottom: max(0, rect.maxY - visible.maxY),
                                                clipLeft: max(0, visible.minX - rect.minX))
                    }.sorted { $0.id < $1.id }
                    if activa && presente && scenePhase == .active && !marcos.isEmpty {
                        IlustracionesHTML(marcos: marcos, reduceMotion: reduceMotion)
                            .allowsHitTesting(false)
                            .accessibilityHidden(true)
                    }
                }
                .clipped()
                .allowsHitTesting(false)
            }
            .onAppear { presente = true }
            .onDisappear { presente = false }
    }
}

extension View {
    /// Un solo WKWebView por pantalla, sin red, sin lectores por fila y sin interceptar gestos.
    func ilustracionesOfrenda(activa: Bool = true) -> some View {
        modifier(CapaIlustraciones(activa: activa))
    }


    func recortaIlustraciones() -> some View { modifier(RecorteIlustraciones()) }
}

private struct IlustracionesHTML: UIViewRepresentable {
    let marcos: [MarcoIlustracion]
    let reduceMotion: Bool

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WebIlustraciones {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        let view = WebIlustraciones(frame: .zero, configuration: configuration)
        view.isOpaque = false
        view.backgroundColor = .clear
        view.underPageBackgroundColor = .clear
        view.scrollView.backgroundColor = .clear
        view.scrollView.isScrollEnabled = false
        view.scrollView.bounces = false
        view.scrollView.contentInsetAdjustmentBehavior = .never
        view.isUserInteractionEnabled = false
        view.accessibilityElementsHidden = true
        let coordinator = context.coordinator
        view.navigationDelegate = coordinator
        view.onWindow = { [weak coordinator, weak view] in
            guard let view else { return }
            coordinator?.enviar(a: view)
        }
        coordinator.cargar(en: view)
        return view
    }

    func updateUIView(_ view: WebIlustraciones, context: Context) {
        context.coordinator.marcos = marcos
        context.coordinator.reduceMotion = reduceMotion
        context.coordinator.enviar(a: view)
    }

    static func dismantleUIView(_ view: WebIlustraciones, coordinator: Coordinator) {
        view.evaluateJavaScript("window.setActive?.(false)", completionHandler: nil)
        view.onWindow = nil
        view.navigationDelegate = nil
        view.stopLoading()
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var marcos: [MarcoIlustracion] = []
        var reduceMotion = false
        private var listo = false
        private var revision = 0
        private var ultimoContenido: String?
        private var recuperaciones = 0

        func cargar(en view: WKWebView) {
            listo = false
            ultimoContenido = nil
            if let url = Bundle.main.url(forResource: "ofrenda-ilustraciones", withExtension: "html") {
                view.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            }
        }

        func enviar(a view: WKWebView) {
            guard listo else { return }
            struct Contenido: Encodable {
                let icons: [MarcoIlustracion]
                let reduceMotion: Bool
                let active: Bool
            }
            let contenido = Contenido(icons: marcos, reduceMotion: reduceMotion, active: view.window != nil)
            guard let data = try? JSONEncoder().encode(contenido),
                  let json = String(data: data, encoding: .utf8), json != ultimoContenido else { return }
            ultimoContenido = json
            revision += 1
            view.evaluateJavaScript("window.setIcons?.(Object.assign(\(json),{revision:\(revision)}))", completionHandler: nil)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            listo = true
            ultimoContenido = nil
            enviar(a: webView)
        }

        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            guard recuperaciones < 1 else { return }
            recuperaciones += 1
            cargar(en: webView)
        }
    }
}

private final class WebIlustraciones: WKWebView {
    var onWindow: (() -> Void)?
    override func didMoveToWindow() { super.didMoveToWindow(); onWindow?() }
}
