//
//  TarjetaLugarView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct TarjetaLugarView: View {
    let lugar: LugarCultural
    var contexto: String? = nil
    @EnvironmentObject private var exploracion: ExploracionGeografica
    @State private var imagen: UIImage?
    @State private var cargando = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider().padding(.vertical, 6)
            Text("Tradición en México").font(.title3.bold())
            Text(lugar.nombre).font(.headline).foregroundStyle(AppTheme.accent)
            Text(lugar.region).font(.subheadline).foregroundStyle(AppTheme.secondaryText)
            Text(contexto ?? lugar.descripcion).font(.body).lineSpacing(4)
            Group {
                if let imagen {
                    Image(uiImage: imagen).resizable().scaledToFit()
                } else if cargando {
                    ProgressView("Cargando vista del mapa…").frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ContentUnavailableView("Vista previa no disponible", systemImage: "map", description: Text("Puedes explorar el mapa con conexión o consultar la ubicación indicada."))
                }
            }
            .frame(maxWidth: .infinity).frame(height: 160)
            .background(AppTheme.surface).clipShape(.rect(cornerRadius: 16))
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Vista general de \(lugar.nombre). Punto de referencia: \(lugar.referencia)")

            Button("Explorar lugar", systemImage: "map") { exploracion.lugar = lugar }
                .frame(maxWidth: .infinity, minHeight: 44)
                .ofrendaPrimaryAction()
                .accessibilityIdentifier("tradicion.explorar.\(lugar.id)")
            BotonRutasView(lugar: lugar)
            Text("Referencia: \(lugar.referencia). Las tradiciones también se viven en otras regiones.")
                .font(.footnote).foregroundStyle(AppTheme.secondaryText)
            ForEach(lugar.fuentes, id: \.self) { fuente in
                Link(destination: fuente.url) { Label(fuente.titulo, systemImage: "arrow.up.right") }
                    .font(.footnote).frame(minHeight: 44, alignment: .leading)
            }
        }
        .task(id: lugar.id) {
            imagen = nil; cargando = true
            do { imagen = try await MiniaturasMapas.shared.imagen(para: lugar) }
            catch is CancellationError { return }
            catch { imagen = nil }
            cargando = false
        }
    }
}

struct BotonRutasView: View {
    let lugar: LugarCultural
    @State private var errorApertura = false
    var body: some View {
        Menu {
            ForEach(TransporteCultural.allCases) { modo in
                Button(modo.rawValue, systemImage: modo.simbolo) {
                    errorApertura = !MapasCulturales.abrir(lugar, transporte: modo)
                }
            }
        } label: {
            Label("Cómo llegar", systemImage: "arrow.triangle.turn.up.right.diamond")
                .frame(maxWidth: .infinity, minHeight: 44)
        }
        .ofrendaSecondaryAction()
        .accessibilityHint("Elige transporte y abre Apple Maps. La disponibilidad de rutas depende de Maps.")
        .alert("No se pudo abrir Apple Maps", isPresented: $errorApertura) {
            Button("Entendido", role: .cancel) {}
        } message: { Text("Busca \(lugar.referencia) en tu aplicación de mapas. Puedes volver a intentarlo desde Cómo llegar.") }
    }
}

/// Mantiene espacio para el mapa cuando Dynamic Type necesita un panel desplazable.
struct PanelInformacionMapa<Contenido: View>: View {
    let alturaMaxima: CGFloat
    @ViewBuilder var contenido: Contenido
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        if dynamicTypeSize.isAccessibilitySize {
            ScrollView { contenido }
                .frame(height: alturaMaxima)
                .background(AppTheme.background)
        } else {
            contenido
        }
    }
}
