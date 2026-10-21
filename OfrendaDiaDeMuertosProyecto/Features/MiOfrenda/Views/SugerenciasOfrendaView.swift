//
//  SugerenciasOfrendaView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Victor Flores on 16/10/26.
//

import SwiftUI

struct SugerenciasOfrendaView: View {
    let personalizacion: PersonalizacionOfrenda
    let onContinuar: () -> Void
    let onVolver: () -> Void
    let onSalir: () -> Void

    private let colorFondo = AppTheme.background
    private let colorTarjeta = AppTheme.surface
    private let colorAcento = AppTheme.accent
    private let colorTextoSec = AppTheme.secondaryText

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                FlowNavigationBar(onVolver: onVolver, onSalir: onSalir)

                VStack(alignment: .leading, spacing: 6) {
                    Text("INSPIRADAS EN SUS RECUERDOS")
                        .font(.caption.weight(.bold)).tracking(0.8)
                        .foregroundColor(colorAcento)
                    Text("Ideas para su ofrenda.")
                        .font(.system(size: 34, weight: .bold)).foregroundColor(.white)
                    Text("Para \(personalizacion.nombre) · Tú decides qué conservar.")
                        .font(.subheadline).foregroundColor(colorTextoSec)
                }
                .padding(.horizontal, 24)

                // Bloque 1: elementos básicos
                VStack(alignment: .leading, spacing: 12) {
                    Text("PARA RECIBIRLE")
                        .font(.caption.weight(.bold)).tracking(0.6)
                        .foregroundColor(colorAcento)
                    HStack(spacing: 24) {
                        VStack { Text("🌼").font(.largeTitle); Text("Flores").font(.caption).foregroundColor(.white) }
                        VStack { Text("🕯️").font(.largeTitle); Text("Una vela").font(.caption).foregroundColor(.white) }
                        VStack { Text("💧").font(.largeTitle); Text("Agua").font(.caption).foregroundColor(.white) }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 20).fill(colorTarjeta.opacity(0.75)))
                .padding(.horizontal, 24)

                // Comida favorita
                if !personalizacion.comidaFavorita.isEmpty {
                    TarjetaSugerencia(
                        icono: "🍲",
                        titulo: "\(personalizacion.comidaFavorita), como le gustaban",
                        razon: "Porque elegiste su comida favorita.",
                        colorTarjeta: colorTarjeta, colorTextoSec: colorTextoSec
                    )
                    .padding(.horizontal, 24)
                }

                // Música o canción favorita
                if !personalizacion.musicaFavorita.isEmpty {
                    TarjetaSugerencia(
                        icono: "🎵",
                        titulo: "\(personalizacion.musicaFavorita)",
                        razon: "Para hacer sonar la música que alegraba sus días.",
                        colorTarjeta: colorTarjeta, colorTextoSec: colorTextoSec
                    )
                    .padding(.horizontal, 24)
                }

                // Aficiones
                ForEach(Array(personalizacion.aficiones).sorted(), id: \.self) { aficion in
                    TarjetaSugerencia(
                        icono: iconoPara(aficion),
                        titulo: tituloPara(aficion),
                        razon: razonPara(aficion),
                        colorTarjeta: colorTarjeta, colorTextoSec: colorTextoSec
                    )
                    .padding(.horizontal, 24)
                }

                if !personalizacion.recuerdoCompartido.isEmpty {
                    TarjetaSugerencia(
                        icono: "📸",
                        titulo: "Un recuerdo: \(personalizacion.recuerdoCompartido.lowercased())",
                        razon: "Lo compartiste como momento especial.",
                        colorTarjeta: colorTarjeta, colorTextoSec: colorTextoSec
                    )
                    .padding(.horizontal, 24)
                }

                Text("En el siguiente paso eliges qué objetos disponibles se verán en el modelo 3D.")
                    .font(.subheadline).foregroundColor(colorTextoSec)
                    .padding(.horizontal, 24)

                Button { onContinuar() } label: {
                    Text("Elegir elementos del modelo")
                        .font(.headline).foregroundColor(.black)
                        .frame(maxWidth: .infinity).padding(.vertical, 8)

                }
                .ofrendaPrimaryAction()
                .padding(.horizontal, 24).padding(.bottom, 24)
            }
        }
        .background(colorFondo.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }

    private func iconoPara(_ aficion: String) -> String {
        Aficion.todas.first { $0.nombre == aficion }?.icono ?? "✨"
    }
    private func tituloPara(_ aficion: String) -> String {
        switch aficion {
        case "Jardinería": return "Un recuerdo de su jardín"
        case "Música":     return "Su música favorita"
        case "Cocina":     return "Recetas de casa"
        case "Lectura":    return "Los libros que atesoraba"
        case "Costura":    return "Sus labores de costura"
        case "Café":       return "Las tardes con café"
        default:           return aficion
        }
    }
    private func razonPara(_ aficion: String) -> String {
        switch aficion {
        case "Jardinería": return "Porque disfrutaba cuidar sus flores."
        case "Música":     return "Porque le gustaba escuchar canciones."
        case "Cocina":     return "Porque preparaba sus platillos."
        case "Lectura":    return "Porque le gustaba leer."
        case "Costura":    return "Porque cosía con sus manos."
        case "Café":       return "Porque disfrutaba una buena taza."
        default:           return "Elegido entre sus gustos."
        }
    }
}

private struct TarjetaSugerencia: View {
    let icono: String
    let titulo: String
    let razon: String
    let colorTarjeta: Color
    let colorTextoSec: Color

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Text(icono).font(.largeTitle).frame(width: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text(titulo).font(.headline).foregroundColor(.white)
                Text(razon).font(.subheadline).foregroundColor(colorTextoSec)
            }
            Spacer()
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20).fill(colorTarjeta.opacity(0.75)))
    }
}
