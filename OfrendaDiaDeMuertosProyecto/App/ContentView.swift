//
//  ContentView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI
import UIKit
import Combine

struct ContentView: View {
    @State private var mostrandoEntrada = true
    @State private var recorridoTerminado = false
    @State private var precargaFinalizada = false
    @State private var revisionPrecarga = 0
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            if mostrandoEntrada {
                MictlanIntroView(esperandoModelo: recorridoTerminado && !precargaFinalizada) {
                    recorridoTerminado = true
                    entrarSiEstaLista()
                }
            } else {
                AppTabsView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background.ignoresSafeArea())
        .task(id: revisionPrecarga) {
            guard scenePhase == .active, mostrandoEntrada, !precargaFinalizada else { return }
            do {
                try await OfrendaAssets.shared.preload(named: "Ofrenda")
                try Task.checkCancellation()
            } catch is CancellationError {
                return
            } catch {
                // El visor reintenta su carga y muestra su error habitual si el recurso falla.
                guard !Task.isCancelled else { return }
            }
            precargaFinalizada = true
            entrarSiEstaLista()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)) { _ in
            OfrendaAssets.shared.clearCachedModels()
            if mostrandoEntrada {
                precargaFinalizada = false
                revisionPrecarga += 1
            }
        }   
        .onChange(of: scenePhase) { _, phase in
            if phase == .background {
                OfrendaAssets.shared.clearCachedModels()
                if mostrandoEntrada { precargaFinalizada = false }
            }
            if mostrandoEntrada {
                revisionPrecarga += 1
                entrarSiEstaLista()
            }
        }
    }

    private func entrarSiEstaLista() {
        guard mostrandoEntrada, recorridoTerminado, precargaFinalizada, scenePhase == .active else { return }
        mostrandoEntrada = false
    }
}

#Preview("Ofrenda · Modelo 3D") {
    AppTabsView()
}
