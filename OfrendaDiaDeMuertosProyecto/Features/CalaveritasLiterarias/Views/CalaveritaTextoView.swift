//
//  CalaveritaTextoView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

/// Misma lectura con énfasis y pétalos, tanto al generar como al abrir un poema guardado.
struct CalaveritaTextoView: View {
    let texto: String
    @State private var mostrarPetalos = false

    var body: some View {
        Text(texto.formatearCalaverita(colorAcento: AppTheme.accent))
            .font(.body).italic()
            .foregroundStyle(.white)
            .lineSpacing(6)
            .frame(maxWidth: .infinity, alignment: .leading)
            .textSelection(.enabled)
            .environment(\.openURL, OpenURLAction { url in
                guard url.scheme == "cempasuchil" else { return .discarded }
                mostrarPetalos = true
                return .handled
            })
            .overlay {
                if mostrarPetalos {
                    PetalosCempasuchilView { mostrarPetalos = false }
                }
            }
    }
}

// MARK: - Animación de Pétalos de Cempasúchil
private struct PetalosCempasuchilView: View {
    let onTerminar: () -> Void
    @State private var animar = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var petalos = (0..<20).map { _ in
        PetaloData(
            x: Double.random(in: 0.05...0.95),
            retraso: Double.random(in: 0...0.4),
            duracion: Double.random(in: 1.8...2.5),
            tamano: CGFloat.random(in: 18...30),
            rotacion: Double.random(in: -180...180)
        )
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(petalos) { p in
                    Capsule()
                        .fill(LinearGradient(colors: [AppTheme.accent, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: p.tamano * 0.55, height: p.tamano)
                        .rotationEffect(.degrees(animar && !reduceMotion ? p.rotacion + 360 : p.rotacion))
                        .position(
                            x: proxy.size.width * p.x,
                            y: reduceMotion ? proxy.size.height * 0.3 : (animar ? proxy.size.height + 50 : -50)
                        )
                        .opacity(animar ? 0.95 : 0)
                        .animation(
                            .easeOut(duration: reduceMotion ? 0.2 : p.duracion).delay(reduceMotion ? 0 : p.retraso),
                            value: animar
                        )
                }
            }
        }
        .allowsHitTesting(false)
        .task {
            animar = true
            let duracion = reduceMotion ? 0.4 : (petalos.map { $0.duracion + $0.retraso }.max() ?? 2.9) + 0.1
            do { try await Task.sleep(for: .seconds(duracion)) }
            catch { return }
            guard !Task.isCancelled else { return }
            onTerminar()
        }
    }
}

private struct PetaloData: Identifiable {
    let id = UUID()
    let x: Double
    let retraso: Double
    let duracion: Double
    let tamano: CGFloat
    let rotacion: Double
}

// MARK: - Formateador de Texto de Calaverita
private extension String {
    func formatearCalaverita(colorAcento: Color) -> AttributedString {
        var options = AttributedString.MarkdownParsingOptions()
        options.interpretedSyntax = .inlineOnlyPreservingWhitespace

        guard var attrString = try? AttributedString(markdown: self, options: options) else {
            return AttributedString(self)
        }

        for run in attrString.runs {
            if run.inlinePresentationIntent?.contains(.stronglyEmphasized) == true {
                attrString[run.range].foregroundColor = colorAcento
                attrString[run.range].font = Font.body.bold().italic()
                attrString[run.range].link = URL(string: "cempasuchil://flores")
                attrString[run.range].underlineStyle = Text.LineStyle(pattern: .solid, color: colorAcento)
            }
        }

        return attrString
    }
}
