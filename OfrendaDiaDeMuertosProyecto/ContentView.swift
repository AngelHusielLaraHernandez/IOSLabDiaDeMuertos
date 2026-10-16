import SwiftUI

/// Intento ver animación html
struct ContentView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            OfrendaExplorarView()

            if showSplash {
                SplashScreenView(showSplash: $showSplash)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }
}

/// Lo de blender
struct OfrendaScreen: View {
    @State private var resetToken = 0
    @State private var loadState: ModelLoadState = .loading

    var body: some View {
        OfrendaModelView(resetToken: resetToken, onLoad: { loadState = $0 })
            .ignoresSafeArea()
            .overlay(alignment: .topLeading) {
                Text("Ofrenda · 3D").font(.headline).padding(20).allowsHitTesting(false)
            }
            .overlay(alignment: .topTrailing) {
                Button { resetToken += 1 } label: {
                    Image(systemName: "arrow.counterclockwise").font(.headline).padding(12)
                        .background(.black.opacity(0.55), in: Circle())
                }.padding(20).accessibilityLabel("Restablecer vista")
            }
            .overlay(alignment: .bottom) {
                Text("1 dedo: girar · 2 dedos: mover\nPellizca para acercar · Doble toque: restablecer")
                    .font(.caption).multilineTextAlignment(.center)
                    .padding(14).background(.black.opacity(0.55), in: RoundedRectangle(cornerRadius: 16))
                    .padding(20).allowsHitTesting(false)
            }
            .overlay {
                Group {
                    if case .loading = loadState {
                        ProgressView("Cargando ofrenda…")
                            .padding(24).background(.black.opacity(0.75), in: RoundedRectangle(cornerRadius: 20))
                            .allowsHitTesting(false)
                    }
                    if case .failed(let message) = loadState {
                        ContentUnavailableView("No se pudo abrir el modelo", systemImage: "cube", description: Text(message))
                            .padding().background(.black.opacity(0.75))
                    }
                }.allowsHitTesting(false)
            }
            .foregroundStyle(.white).tint(.white).preferredColorScheme(.dark)
    }
}

#Preview { ContentView() }
