import SwiftUI
import PhotosUI

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
    @State private var photo: UIImage?
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        OfrendaModelView(resetToken: resetToken,
                         photo: $photo,
                         onLoad: { loadState = $0 })
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
                VStack(spacing: 10) {
                    PhotosPicker(selection: $pickerItem,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Label(photo == nil ? "Elegir foto" : "Cambiar foto",
                              systemImage: "photo.on.rectangle")
                            .font(.headline)
                            .padding(.horizontal, 20).padding(.vertical, 12)
                            .background(.ultraThinMaterial, in: Capsule())
                    }

                    Text("1 dedo: girar · 2 dedos: mover\nPellizca para acercar · Doble toque: restablecer")
                        .font(.caption).multilineTextAlignment(.center)
                        .padding(14).background(.black.opacity(0.55), in: RoundedRectangle(cornerRadius: 16))
                        .allowsHitTesting(false)
                }
                .padding(20)
            }
            .overlay {
                Group {
                    if case .loading = loadState {
                        ProgressView("Cargando ofrenda…")
                            .padding(24).background(.black.opacity(0.75), in: RoundedRectangle(cornerRadius: 20))
                            .allowsHitTesting(false)
                    }
                    if case .failed(let message) = loadState {
                        ContentUnavailableView("No se pudo abrir el modelo",
                                               systemImage: "cube",
                                               description: Text(message))
                            .padding().background(.black.opacity(0.75))
                    }
                }.allowsHitTesting(false)
            }
            .foregroundStyle(.white).tint(.white).preferredColorScheme(.dark)
            .onChange(of: pickerItem) { _, newItem in
                Task {
                    guard let data = try? await newItem?.loadTransferable(type: Data.self),
                          let image = UIImage(data: data) else { return }
                    await MainActor.run { photo = image }
                }
            }
    }
}

#Preview { ContentView() }
