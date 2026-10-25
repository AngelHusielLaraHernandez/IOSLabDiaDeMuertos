//
//  TarjetaDetalleElementoView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI
import AVFAudio

struct TarjetaDetalleElementoView: View {
    let elemento: ElementoOfrenda
    let renderSession: OfrendaRenderSession
    let fotosMarcos: FotosMarcosStore
    var textoBotonCerrar = "Volver a la ofrenda"
    @StateObject private var lector = LectorVozOfrenda()
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var exploracion = ExploracionGeografica()

    var body: some View {
        GeometryReader { geometry in
            if dynamicTypeSize.isAccessibilitySize {
                ScrollView {
                    VStack(spacing: 0) {
                        modelo(altura: 180)
                        contenido.frame(maxWidth: .infinity)
                    }
                }
            } else {
                VStack(spacing: 0) {
                    modelo(altura: min(220, max(140, geometry.size.height * 0.29)))
                    contenido.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .ilustracionesOfrenda(activa: exploracion.lugar == nil)
        .guiaContextual(elemento.esElementoDelAltar ? (elemento.nombre == "Calaveritas" ? .azucar : .ficha) : .literaria)
        .environmentObject(exploracion)
        .environmentObject(lector)
        .onChange(of: scenePhase) { _, fase in if fase != .active { lector.detener() } }
        .onChange(of: exploracion.lugar) { _, lugar in if lugar != nil { lector.detener() } }
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { aviso in
            if let tipo = aviso.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
               tipo == AVAudioSession.InterruptionType.began.rawValue { lector.detener() }
        }
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification)) { aviso in
            if let razon = aviso.userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt,
               razon == AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue { lector.detener() }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.voiceOverStatusDidChangeNotification)) { _ in lector.detener() }
        .onDisappear { lector.detener() }
        .fullScreenCover(item: $exploracion.lugar) { lugar in ExploradorLugarView(lugar: lugar) }
    }

    @ViewBuilder private func modelo(altura: CGFloat) -> some View {
        if elemento.esElementoDelAltar {
            Elemento3DView(elemento: elemento, fotosMarcos: fotosMarcos, renderSession: renderSession, isActive: exploracion.lugar == nil)
                .frame(height: altura).padding(.horizontal, 24).padding(.top, 16)
                .objetivoGuiaContextual("ficha.modelo")
        }
    }

    @ViewBuilder private var contenido: some View {
        switch elemento.nombre {
        case "Flores", "Cempasúchil": FloresView(textoBotonCerrar: textoBotonCerrar)
        case "Velas": VelasView(textoBotonCerrar: textoBotonCerrar)
        case "Agua y sal": AguaYSalView(textoBotonCerrar: textoBotonCerrar)
        case "Pan", "Pan de muerto": PanDeMuertoView(textoBotonCerrar: textoBotonCerrar)
        case "Comida": ComidaView(textoBotonCerrar: textoBotonCerrar)
        case "Retrato": RetratoView(textoBotonCerrar: textoBotonCerrar)
        case "Papel", "Papel picado": PapelView(textoBotonCerrar: textoBotonCerrar)
        case "Calaveritas": CalaveritasView(textoBotonCerrar: textoBotonCerrar)
        case "Calaveritas literarias": CalaveritaLiterariaView(textoBotonCerrar: textoBotonCerrar)
        case "Caña de azúcar": CanaDeAzucarView(textoBotonCerrar: textoBotonCerrar)
        case "Frutas": FrutasView(textoBotonCerrar: textoBotonCerrar)
        case "Incienso": InciensoView(textoBotonCerrar: textoBotonCerrar)
        case "Cigarro": CigarroView(textoBotonCerrar: textoBotonCerrar)
        case "Tequila": TequilaView(textoBotonCerrar: textoBotonCerrar)
        default: FloresView(textoBotonCerrar: textoBotonCerrar)
        }
    }
}
