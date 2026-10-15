import SwiftUI

@main
struct OfrendaApp: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                if showSplash {
                    SplashScreenView(showSplash: $showSplash)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
        }
    }
}
