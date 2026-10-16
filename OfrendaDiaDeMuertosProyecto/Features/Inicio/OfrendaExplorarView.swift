//
//  OfrendaExplorarView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 15/10/26.
//

import SwiftUI
import SceneKit

// MARK: - Modelo de Datos con Anclaje 3D
struct ElementoOfrenda: Identifiable {
    let id = UUID()
    let nombre: String
    let icono: String
    let tituloHistoria: String
    let descripcionHistoria: String
    let significado: String
    /// Coordenadas normalizadas respecto a la caja delimitadora (Bounding Box) del altar 3D
    let anclaNormalizada: SIMD3<Float>
}

struct OfrendaExplorarView: View {
    // Estados de la interfaz y progreso
    @State private var elementoSeleccionado: ElementoOfrenda? = nil
    @State private var elementosVisitados: Set<String> = ["Flores"]
    @State private var tabSeleccionado: Int = 0
    
    // Estados del visor 3D (usa el ModelLoadState que ya existe en tu proyecto)
    @State private var resetToken: Int = 0
    @State private var loadState: ModelLoadState = .loading
    @State private var posiciones2D: [String: CGPoint] = [:]
    
    // Paleta de colores del diseño en Figma
    let colorFondo = Color(red: 0.11, green: 0.05, blue: 0.18)       // #1C0D2E (Morado oscuro)
    let colorTarjeta = Color(red: 0.21, green: 0.13, blue: 0.30)     // #35214C
    let colorAcento = Color(red: 0.96, green: 0.65, blue: 0.25)      // #F5A640 (Dorado/Cempasúchil)
    let colorTextoSecundario = Color(red: 0.78, green: 0.75, blue: 0.84)
    
    // Los 8 botones calibrados con la distribución de tu modelo 3D de Blender
    let elementos: [ElementoOfrenda] = [
        ElementoOfrenda(
            nombre: "Flores", icono: "🌼",
            tituloHistoria: "Un camino de pétalos",
            descripcionHistoria: "En muchas ofrendas, los pétalos y arcos de cempasúchil trazan un sendero de bienvenida hasta el altar.",
            significado: "Su color intenso y su aroma ayudan a guiar a las ánimas hacia la ofrenda.",
            anclaNormalizada: SIMD3<Float>(-0.28, 0.52, 0.05)
        ),
        ElementoOfrenda(
            nombre: "Retrato", icono: "🖼️",
            tituloHistoria: "Una sonrisa conocida",
            descripcionHistoria: "La fotografía en lo alto del altar dedica la ofrenda a la persona que recordamos.",
            significado: "Mantiene presente su rostro e identidad en la memoria familiar.",
            anclaNormalizada: SIMD3<Float>(0.06, 0.56, 0.0)
        ),
        ElementoOfrenda(
            nombre: "Velas", icono: "🕯️",
            tituloHistoria: "Una luz para volver",
            descripcionHistoria: "La flama ilumina el camino de regreso a casa durante la noche.",
            significado: "Simboliza la luz, la fe y la esperanza para guiar a los seres queridos.",
            anclaNormalizada: SIMD3<Float>(-0.22, 0.38, 0.12)
        ),
        ElementoOfrenda(
            nombre: "Papel", icono: "🎊",
            tituloHistoria: "El aire entre los colores",
            descripcionHistoria: "El papel picado se mueve con la brisa, anunciando el paso de las ánimas.",
            significado: "Representa el elemento aire y la alegría festiva de la tradición.",
            anclaNormalizada: SIMD3<Float>(0.25, 0.78, 0.0)
        ),
        ElementoOfrenda(
            nombre: "Agua y sal", icono: "🥛",
            tituloHistoria: "Después del viaje",
            descripcionHistoria: "Un vaso de agua fresca espera a las ánimas tras su largo recorrido.",
            significado: "El agua mitiga la sed del camino y la sal actúa como elemento de purificación.",
            anclaNormalizada: SIMD3<Float>(-0.32, 0.24, 0.22)
        ),
        ElementoOfrenda(
            nombre: "Calaveritas", icono: "💀",
            tituloHistoria: "Recordar con una sonrisa",
            descripcionHistoria: "Pueden ser dulces de azúcar o versos llenos de ingenio y cariño.",
            significado: "Nos invitan a mirar la muerte con humor, afecto y cercanía.",
            anclaNormalizada: SIMD3<Float>(0.24, 0.38, 0.15)
        ),
        ElementoOfrenda(
            nombre: "Pan", icono: "🍞",
            tituloHistoria: "El aroma de la cocina",
            descripcionHistoria: "El pan de muerto se comparte como símbolo de fraternidad y cariño.",
            significado: "Su forma circular representa el ciclo de la vida y sus relieves los huesos.",
            anclaNormalizada: SIMD3<Float>(0.0, 0.22, 0.28)
        ),
        ElementoOfrenda(
            nombre: "Comida", icono: "🍲",
            tituloHistoria: "Su platillo favorito",
            descripcionHistoria: "Los guisos, tamales o frutas que más disfrutaba en vida llenan la mesa.",
            significado: "Agasaja a nuestros seres queridos con los aromas de casa.",
            anclaNormalizada: SIMD3<Float>(-0.18, 0.20, 0.28)
        )
    ]

    var body: some View {
        ZStack {
            colorFondo.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 12) {
                
                // MARK: - Contenido dinámico según la pestaña seleccionada
                if tabSeleccionado == 0 {
                    
                    // MARK: 1. Encabezado y Progreso
                    VStack(alignment: .leading, spacing: 6) {
                        Text("LA OFRENDA DE ELENA")
                            .font(.caption.weight(.bold))
                            .tracking(0.8)
                            .foregroundColor(colorAcento)
                        
                        Text("Cada objeto,\nuna historia.")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                            .lineSpacing(2)
                        
                        Text("Toca un objeto: historia y significado.")
                            .font(.subheadline)
                            .foregroundColor(colorTextoSecundario)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Ocho elementos · Explora a tu ritmo")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(colorAcento)
                            
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(colorTarjeta)
                                        .frame(height: 6)
                                    
                                    Capsule()
                                        .fill(colorAcento)
                                        .frame(width: max(24, geo.size.width * (CGFloat(elementosVisitados.count) / 8.0)), height: 6)
                                        .animation(.spring(), value: elementosVisitados.count)
                                }
                            }
                            .frame(height: 6)
                        }
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 6)
                    
                    // MARK: 2. Zona Central: Modelo 3D Interactivo + Botones que siguen al modelo
                    ZStack {
                        OfrendaInteractive3DView(
                            elementos: elementos,
                            resetToken: resetToken,
                            posicionesEnPantalla: $posiciones2D,
                            onLoad: { loadState = $0 }
                        )
                        
                        ForEach(elementos) { elemento in
                            if let punto = posiciones2D[elemento.nombre] {
                                Button {
                                    elementosVisitados.insert(elemento.nombre)
                                    elementoSeleccionado = elemento
                                } label: {
                                    Text(elemento.nombre)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(colorAcento)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(
                                            Capsule()
                                                .fill(colorTarjeta.opacity(0.92))
                                                .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 3)
                                        )
                                        .overlay(
                                            Capsule()
                                                .stroke(
                                                    elementosVisitados.contains(elemento.nombre) ? colorAcento.opacity(0.6) : Color.white.opacity(0.12),
                                                    lineWidth: 1
                                                )
                                        )
                                }
                                .position(x: punto.x, y: punto.y)
                            }
                        }
                        
                        VStack {
                            HStack {
                                Spacer()
                                Button {
                                    resetToken += 1
                                } label: {
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.subheadline.weight(.bold))
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(colorTarjeta.opacity(0.85), in: Circle())
                                        .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                                }
                                .accessibilityLabel("Restablecer vista 3D")
                            }
                            Spacer()
                            Text("1 dedo: girar · 2 dedos: mover · Pellizca: acercar")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(colorTextoSecundario.opacity(0.85))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 5)
                                .background(colorFondo.opacity(0.75), in: Capsule())
                                .allowsHitTesting(false)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        
                        Group {
                            if case .loading = loadState {
                                ProgressView("Cargando ofrenda…")
                                    .padding(20)
                                    .background(colorTarjeta.opacity(0.9), in: RoundedRectangle(cornerRadius: 16))
                            }
                            if case .failed(let message) = loadState {
                                ContentUnavailableView("No se pudo abrir el modelo", systemImage: "cube", description: Text(message))
                                    .padding()
                                    .background(colorFondo.opacity(0.9), in: RoundedRectangle(cornerRadius: 16))
                            }
                        }
                        .allowsHitTesting(false)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    
                    // MARK: 3. Tarjeta "Personalización Opcional"
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            tabSeleccionado = 2
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("PERSONALIZACIÓN OPCIONAL")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(0.6)
                                .foregroundColor(colorAcento)
                            
                            Text("Hazla personal, si quieres")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 6) {
                                Text("Crear una ofrenda para alguien")
                                    .font(.subheadline.weight(.semibold))
                                Image(systemName: "arrow.right")
                                    .font(.subheadline.weight(.bold))
                            }
                            .foregroundColor(colorAcento)
                            .padding(.top, 2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(colorTarjeta.opacity(0.75))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                )
                        )
                    }
                    .padding(.horizontal, 24)
                    
                } else if tabSeleccionado == 1 {
                    
                    // MARK: Vista de la Pestaña "Historias"
                    HistoriasView(
                        elementos: elementos,
                        elementosVisitados: $elementosVisitados,
                        elementoSeleccionado: $elementoSeleccionado
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else {
                    
                    // MARK: Espacio reservado para la Pestaña "Mi ofrenda" (Tab 2)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SUS GUSTOS, SU HISTORIA")
                            .font(.caption.weight(.bold))
                            .tracking(0.8)
                            .foregroundColor(colorAcento)
                        
                        Text("Mi ofrenda para Elena.")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Próximamente: personalización de retrato, gustos y calaverita literaria.")
                            .font(.subheadline)
                            .foregroundColor(colorTextoSecundario)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                
                // MARK: 4. Barra de Navegación Inferior (Siempre visible)
                HStack {
                    TabBarItem(icono: "house", titulo: "Ofrenda", activo: tabSeleccionado == 0, colorAcento: colorAcento) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            tabSeleccionado = 0
                        }
                    }
                    Spacer()
                    TabBarItem(icono: "doc.text", titulo: "Historias", activo: tabSeleccionado == 1, colorAcento: colorAcento) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            tabSeleccionado = 1
                        }
                    }
                    Spacer()
                    TabBarItem(icono: "heart", titulo: "Mi ofrenda", activo: tabSeleccionado == 2, colorAcento: colorAcento) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            tabSeleccionado = 2
                        }
                    }
                }
                .padding(.horizontal, 36)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(colorTarjeta.opacity(0.85))
                        .overlay(Capsule().stroke(Color.white.opacity(0.1), lineWidth: 1))
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 6)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(item: $elementoSeleccionado) { (elemento: ElementoOfrenda) in
            TarjetaDetalleElementoView(
                elemento: elemento,
                colorFondo: colorFondo,
                colorTarjeta: colorTarjeta,
                colorAcento: colorAcento,
                textoBotonCerrar: tabSeleccionado == 1 ? "Volver a historias" : "Volver a la ofrenda"
            )
            .presentationDetents([.fraction(0.72), .large])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Subvista: Botón de Barra Inferior
struct TabBarItem: View {
    let icono: String
    let titulo: String
    let activo: Bool
    let colorAcento: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icono)
                    .font(.system(size: 18, weight: .semibold))
                Text(titulo)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(activo ? colorAcento : Color.white.opacity(0.65))
        }
    }
}

#Preview {
    OfrendaExplorarView()
}
