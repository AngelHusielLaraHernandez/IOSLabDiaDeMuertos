//
//  GuiaContextual.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

private struct ObjetivosGuiaContextual: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] { [:] }
    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { _, nuevo in nuevo })
    }
}
private struct PasoGuiaContextualKey: EnvironmentKey {
    static var defaultValue: String? { nil }
}
private struct RepetirGuiaContextualKey: EnvironmentKey {
    static var defaultValue: (() -> Void)? { nil }
}
extension EnvironmentValues {
    var pasoGuiaContextual: String? {
        get { self[PasoGuiaContextualKey.self] }
        set { self[PasoGuiaContextualKey.self] = newValue }
    }
    var repetirGuiaContextual: (() -> Void)? {
        get { self[RepetirGuiaContextualKey.self] }
        set { self[RepetirGuiaContextualKey.self] = newValue }
    }
}

extension View {
    func objetivoGuiaContextual(_ id: String, activo: Bool = true) -> some View {
        transformAnchorPreference(key: ObjetivosGuiaContextual.self, value: .bounds) { objetivos, ancla in if activo { objetivos[id] = ancla } }
            .id(id)
    }
    func guiaContextual(_ ambito: GuiaContextualAmbito) -> some View { modifier(GuiaContextualModifier(ambito: ambito)) }
}

struct AyudaGuiaContextualButton: View {
    @Environment(\.repetirGuiaContextual) private var repetir
    var body: some View {
        if let repetir {
            GlassIconButton(systemImage: "questionmark", label: "Volver a ver la guía de esta pantalla", action: repetir)
        }
    }
}

private struct GuiaContextualModifier: ViewModifier {
    @StateObject private var guia: GuiaContextualStore
    @Environment(\.scenePhase) private var scenePhase
    init(ambito: GuiaContextualAmbito) { _guia = StateObject(wrappedValue: GuiaContextualStore(ambito: ambito)) }

    func body(content: Content) -> some View {
        ScrollViewReader { desplazamiento in
            content
                .accessibilityHidden(guia.activa && scenePhase == .active)
                .onChange(of: guia.indice) { _, _ in
                    if let paso = guia.paso { desplazamiento.scrollTo(paso.objetivo, anchor: .top) }
                }
        }
        .overlayPreferenceValue(ObjetivosGuiaContextual.self) { objetivos in
            GeometryReader { geometria in
                if let paso = guia.paso, let indice = guia.indice,
                   let ancla = objetivos[paso.objetivo], scenePhase == .active {
                    GuiaDestacadoView(numero: indice + 1, total: guia.ambito.pasos.count,
                        titulo: paso.titulo, texto: paso.explicacion, identificador: paso.id,
                        objetivo: geometria[ancla], pantalla: geometria.size,
                        anterior: indice == 0 ? nil : { guia.anterior() },
                        siguiente: { guia.siguiente() }, omitir: { guia.terminar() },
                        tituloFinal: "Entendido")
                }
            }
        }
        .environment(\.pasoGuiaContextual, guia.paso?.id)
        .environment(\.repetirGuiaContextual, { guia.repetir() })
        .onAppear { guia.presentarSiNecesaria() }
    }
}
