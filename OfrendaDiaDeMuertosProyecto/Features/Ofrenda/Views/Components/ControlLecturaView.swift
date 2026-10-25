//
//  ControlLecturaView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct ControlLecturaView: View {
    let texto: String
    var suspendida = false
    @EnvironmentObject private var lector: LectorVozOfrenda

    private var titulo: String {
        switch lector.estado {
        case .inactivo: "Escuchar"
        case .preparando: "Preparando voz…"
        case .leyendo: "Pausar"
        case .pausado: "Continuar"
        }
    }
    private var simbolo: String {
        switch lector.estado {
        case .leyendo: "pause.fill"
        case .pausado: "play.fill"
        default: "speaker.wave.2.fill"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Button {
                    switch lector.estado {
                    case .inactivo: lector.escuchar(texto)
                    case .leyendo: lector.pausar()
                    case .pausado: lector.continuar()
                    case .preparando: break
                    }
                } label: {
                    HStack(spacing: 8) {
                        if lector.estado == .preparando { ProgressView().tint(AppTheme.accent) }
                        else { Image(systemName: simbolo).dynamicTypeSize(...DynamicTypeSize.xxxLarge) }
                        Text(titulo).fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(minHeight: 32)
                }
                .ofrendaSecondaryAction()
                .disabled(lector.estado == .preparando || suspendida || texto.isEmpty)
                .accessibilityHint("Lee en español el contenido de la sección abierta")
                .accessibilityIdentifier("ofrenda.escuchar")
                if lector.estado != .inactivo {
                    GlassIconButton(systemImage: "stop.fill", label: "Detener lectura") { lector.detener() }
                        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                        .accessibilityIdentifier("ofrenda.detenerLectura")
                }
                Spacer(minLength: 0)
            }
            if let mensaje = lector.mensaje {
                Text(mensaje).font(.footnote).foregroundStyle(AppTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .onChange(of: texto) { _, _ in lector.detener() }
        .onChange(of: suspendida) { _, _ in lector.detener() }
        .onDisappear { lector.detener() }
    }
}
