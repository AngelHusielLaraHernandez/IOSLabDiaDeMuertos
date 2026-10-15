//
//  OfrendaExplorarView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 15/10/26.
//

import SwiftUI


struct ViewMictlan: View {
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

// MARK: - Modelo de Datos para los Elementos de la Ofrenda
struct ElementoOfrenda: Identifiable {
    let id = UUID()
    let nombre: String
    let icono: String
    let tituloHistoria: String
    let descripcionHistoria: String
    let significado: String
    // Posición relativa (x, y) dentro del contenedor del altar
    let offset: CGSize
}

struct OfrendaExplorarView: View {
    // Control de progreso y selección de tarjetas (Sheets)
    @State private var elementoSeleccionado: ElementoOfrenda? = nil
    @State private var elementosVisitados: Set<String> = ["Flores"] // Inicia con 1 elemento en la barra como en el boceto
    @State private var tabSeleccionado: Int = 0
    
    // Paleta de colores extraída del diseño de Figma
    let colorFondo = Color(red: 0.11, green: 0.05, blue: 0.18)       // #1C0D2E aprox.
    let colorTarjeta = Color(red: 0.21, green: 0.13, blue: 0.30)     // #35214C aprox.
    let colorAcento = Color(red: 0.96, green: 0.65, blue: 0.25)      // #F5A640 (Dorado/Cempasúchil)
    let colorTextoSecundario = Color(red: 0.78, green: 0.75, blue: 0.84)
    
    // Los 8 botones principales concentrados alrededor del altar
    let elementos: [ElementoOfrenda] = [
        ElementoOfrenda(
            nombre: "Flores", icono: "🌼",
            tituloHistoria: "Un camino de pétalos",
            descripcionHistoria: "En muchas ofrendas, los pétalos y arcos de cempasúchil trazan un sendero de bienvenida hasta el altar.",
            significado: "Su color intenso y su aroma ayudan a guiar a las ánimas hacia la ofrenda.",
            offset: CGSize(width: -95, height: -115)
        ),
        ElementoOfrenda(
            nombre: "Retrato", icono: "🖼️",
            tituloHistoria: "Una sonrisa conocida",
            descripcionHistoria: "La fotografía en lo alto del altar dedica la ofrenda a la persona que recordamos.",
            significado: "Mantiene presente su rostro e identidad en la memoria familiar.",
            offset: CGSize(width: 85, height: -85)
        ),
        ElementoOfrenda(
            nombre: "Velas", icono: "🕯️",
            tituloHistoria: "Una luz para volver",
            descripcionHistoria: "La flama ilumina el camino de regreso a casa durante la noche.",
            significado: "Simboliza la luz, la fe y la esperanza para guiar a los seres queridos.",
            offset: CGSize(width: -110, height: -35)
        ),
        ElementoOfrenda(
            nombre: "Papel", icono: "🎊",
            tituloHistoria: "El aire entre los colores",
            descripcionHistoria: "El papel picado se mueve con la brisa, anunciando el paso de las ánimas.",
            significado: "Representa el elemento aire y la alegría festiva de la tradición.",
            offset: CGSize(width: 90, height: -5)
        ),
        ElementoOfrenda(
            nombre: "Agua y sal", icono: "🥛",
            tituloHistoria: "Después del viaje",
            descripcionHistoria: "Un vaso de agua fresca espera a las ánimas tras su largo recorrido.",
            significado: "El agua mitiga la sed del camino y la sal actúa como elemento de purificación.",
            offset: CGSize(width: -90, height: 45)
        ),
        ElementoOfrenda(
            nombre: "Calaveritas", icono: "💀",
            tituloHistoria: "Recordar con una sonrisa",
            descripcionHistoria: "Pueden ser dulces de azúcar o versos llenos de ingenio y cariño.",
            significado: "Nos invitan a mirar la muerte con humor, afecto y cercanía.",
            offset: CGSize(width: 95, height: 105)
        ),
        ElementoOfrenda(
            nombre: "Pan", icono: "🍞",
            tituloHistoria: "El aroma de la cocina",
            descripcionHistoria: "El pan de muerto se comparte como símbolo de fraternidad y cariño.",
            significado: "Su forma circular representa el ciclo de la vida y sus relieves los huesos.",
            offset: CGSize(width: -30, height: 125)
        ),
        ElementoOfrenda(
            nombre: "Comida", icono: "🍲",
            tituloHistoria: "Su platillo favorito",
            descripcionHistoria: "Los guisos, tamales o frutas que más disfrutaba en vida llenan la mesa.",
            significado: "Agasaja a nuestros seres queridos con los aromas de casa.",
            offset: CGSize(width: -95, height: 140)
        )
    ]

    var body: some View {
        ZStack {
            // Fondo general
            colorFondo.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 14) {
                
                // MARK: 1. Encabezado y Progreso
                VStack(alignment: .leading, spacing: 6) {
                    Text("LA OFRENDA DE ELENA")
                        .font(.caption.weight(.bold))
                        .tracking(0.8)
                        .foregroundColor(colorAcento)
                    
                    Text("Cada objeto,\nuna historia.")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .lineSpacing(2)
                    
                    Text("Toca un objeto: historia y significado.")
                        .font(.subheadline)
                        .foregroundColor(colorTextoSecundario)
                        .padding(.top, 2)
                    
                    // Indicador de progreso
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
                    .padding(.top, 6)
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                Spacer(minLength: 0)
                
                // MARK: 2. Zona Central: Altar + 8 Botones Principales
                ZStack {
                    // Ilustración base de la ofrenda (Puedes reemplazar AltarIlustracionView por tu Image("altar_vector"))
                    AltarIlustracionView()
                    
                    // Botones flotantes distribuidos sobre la ofrenda
                    ForEach(elementos) { elemento in
                        Button {
                            elementosVisitados.insert(elemento.nombre)
                            elementoSeleccionado = elemento
                        } label: {
                            Text(elemento.nombre)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(colorAcento)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 11)
                                .background(
                                    Capsule()
                                        .fill(colorTarjeta.opacity(0.92))
                                        .shadow(color: .black.opacity(0.35), radius: 6, x: 0, y: 4)
                                )
                                .overlay(
                                    Capsule()
                                        .stroke(
                                            elementosVisitados.contains(elemento.nombre) ? colorAcento.opacity(0.5) : Color.white.opacity(0.08),
                                            lineWidth: 1
                                        )
                                )
                        }
                        .offset(elemento.offset)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 330)
                
                Spacer(minLength: 0)
                
                // MARK: 3. Tarjeta "Personalización Opcional"
                Button {
                    // Acción para navegar a la vista "17 · Crear · Elegir elemento" o "Mi ofrenda"
                    tabSeleccionado = 2
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
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
                    .padding(18)
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
                
                // MARK: 4. Barra de Navegación Inferior (Custom Tab Bar)
                HStack {
                    TabBarItem(icono: "house", titulo: "Ofrenda", activo: tabSeleccionado == 0, colorAcento: colorAcento) {
                        tabSeleccionado = 0
                    }
                    Spacer()
                    TabBarItem(icono: "doc.text", titulo: "Historias", activo: tabSeleccionado == 1, colorAcento: colorAcento) {
                        tabSeleccionado = 1
                    }
                    Spacer()
                    TabBarItem(icono: "heart", titulo: "Mi ofrenda", activo: tabSeleccionado == 2, colorAcento: colorAcento) {
                        tabSeleccionado = 2
                    }
                }
                .padding(.horizontal, 36)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(colorTarjeta.opacity(0.85))
                        .overlay(
                            Capsule().stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 6)
            }
        }
        // Modal (Sheet) que muestra la tarjeta de Historia / Significado / Indagar al tocar un botón
        .sheet(item: $elementoSeleccionado) { elemento in
            TarjetaDetalleElementoView(
                elemento: elemento,
                colorFondo: colorFondo,
                colorTarjeta: colorTarjeta,
                colorAcento: colorAcento
            )
            .presentationDetents([.fraction(0.68), .large])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Subvista: Ilustración Vectorial del Altar (Placeholder Nativo)
struct AltarIlustracionView: View {
    var body: some View {
        ZStack {
            // Papel picado superior
            HStack(spacing: 10) {
                ForEach(0..<5) { index in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(index % 2 == 0 ? Color.orange : Color.purple.opacity(0.8))
                        .frame(width: 42, height: 34)
                }
            }
            .offset(y: -125)
            
            // Niveles piramidales del altar
            VStack(spacing: 0) {
                // Retrato central
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 0.95, green: 0.82, blue: 0.55))
                    .frame(width: 58, height: 68)
                    .overlay(
                        VStack(spacing: 4) {
                            Circle().fill(Color.brown).frame(width: 22, height: 22)
                            RoundedRectangle(cornerRadius: 8).fill(Color.purple).frame(width: 34, height: 18)
                        }
                    )
                    .padding(.bottom, 4)
                
                // Nivel 1 (Superior)
                Rectangle()
                    .fill(Color(red: 0.44, green: 0.26, blue: 0.76))
                    .frame(width: 90, height: 42)
                
                // Nivel 2 (Medio)
                Rectangle()
                    .fill(Color(red: 0.36, green: 0.20, blue: 0.64))
                    .frame(width: 170, height: 48)
                
                // Nivel 3 (Base)
                Rectangle()
                    .fill(Color(red: 0.28, green: 0.16, blue: 0.50))
                    .frame(width: 240, height: 45)
            }
            .offset(y: 15)
            
            // Velas laterales
            HStack(spacing: 115) {
                VelaVectorView()
                VelaVectorView()
            }
            .offset(y: -10)
        }
    }
}

struct VelaVectorView: View {
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: "flame.fill")
                .foregroundColor(.yellow)
                .font(.system(size: 18))
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.white)
                .frame(width: 14, height: 42)
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

// MARK: - Subvista: Tarjeta Modal (Historia / Significado / Indagar)
struct TarjetaDetalleElementoView: View {
    let elemento: ElementoOfrenda
    let colorFondo: Color
    let colorTarjeta: Color
    let colorAcento: Color
    
    @Environment(\.dismiss) var dismiss
    @State private var seccionActiva: Int = 0 // 0: Historia, 1: Significado, 2: Indagar
    let secciones = ["Historia", "Significado", "Indagar"]
    
    var body: some View {
        ZStack {
            colorFondo.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 18) {
                // Cabecera de la tarjeta
                HStack(spacing: 12) {
                    Text(elemento.icono)
                        .font(.title2)
                        .padding(10)
                        .background(Circle().fill(colorTarjeta))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("EN EL ALTAR")
                            .font(.caption2.weight(.bold))
                            .foregroundColor(colorAcento)
                        Text(elemento.nombre)
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(8)
                            .background(Circle().fill(colorTarjeta))
                    }
                }
                
                // Selector de pestañas (Historia | Significado | Indagar)
                HStack(spacing: 8) {
                    ForEach(0..<secciones.count, id: \.self) { idx in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                seccionActiva = idx
                            }
                        } label: {
                            Text(secciones[idx])
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(seccionActiva == idx ? .black : .white.opacity(0.8))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .fill(seccionActiva == idx ? colorAcento : colorTarjeta)
                                )
                        }
                    }
                }
                
                // Contenido dinámico según la pestaña
                VStack(alignment: .leading, spacing: 12) {
                    if seccionActiva == 0 {
                        Text(elemento.tituloHistoria)
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)
                        Text(elemento.descripcionHistoria)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.85))
                            .lineSpacing(4)
                    } else if seccionActiva == 1 {
                        Text("¿Por qué está aquí?")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)
                        Text(elemento.significado)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.85))
                            .lineSpacing(4)
                    } else {
                        Text("Su camino hasta el altar")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)
                        Text("Antecedentes y registros documentados sobre el uso de \(elemento.nombre.lowercased()) en las distintas regiones y familias.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.85))
                            .lineSpacing(4)
                    }
                }
                .padding(.top, 4)
                
                Spacer()
                
                // Botón inferior de retorno
                Button {
                    dismiss()
                } label: {
                    Text("Volver a la ofrenda")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(colorAcento)
                        )
                }
            }
            .padding(24)
        }
    }
}

#Preview {
    ViewMictlan()
}



