//
//  AjusteFotoView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Victor Flores on 16/10/26.
//

import SwiftUI

struct AjusteFotoView: View {
    let imagenOriginal: UIImage
    let onConfirmar: (UIImage) -> Void
    let onCancelar: () -> Void

    @State private var escala: CGFloat = 1
    @State private var offset: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero

    private let aspectMarco: CGFloat = 4.0 / 5.0   // proporción del marco
    private let colorFondo = Color(red: 0.11, green: 0.05, blue: 0.18)
    private let colorAcento = Color(red: 0.96, green: 0.65, blue: 0.25)

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button { onCancelar() } label: {
                    Label("Volver", systemImage: "chevron.left")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(colorAcento)
                }
                Spacer()
            }
            .padding(.horizontal, 24).padding(.top, 12)

            VStack(alignment: .leading, spacing: 6) {
                Text("EL RETRATO EN TU ALTAR")
                    .font(.caption.weight(.bold)).tracking(0.8)
                    .foregroundColor(colorAcento)
                Text("Ajusta su fotografía.")
                    .font(.system(size: 30, weight: .bold)).foregroundColor(.white)
                Text("Centra su rostro dentro del marco.")
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)

            GeometryReader { geo in
                let ancho = geo.size.width - 48
                let alto = ancho / aspectMarco

                ZStack {
                    Image(uiImage: imagenOriginal)
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(escala)
                        .offset(x: offset.width + dragOffset.width,
                                y: offset.height + dragOffset.height)
                        .frame(width: ancho, height: alto)
                        .clipped()

                    Rectangle()
                        .strokeBorder(colorAcento, lineWidth: 2)
                        .frame(width: ancho, height: alto)
                }
                .frame(maxWidth: .infinity)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation
                        }
                        .onEnded { value in
                            offset.width  += value.translation.width
                            offset.height += value.translation.height
                        }
                )
            }
            .frame(height: 420)

            HStack(spacing: 12) {
                Image(systemName: "minus").foregroundColor(colorAcento)
                Slider(value: $escala, in: 1...3)
                    .tint(colorAcento)
                Image(systemName: "plus").foregroundColor(colorAcento)
            }
            .padding(.horizontal, 24)

            Text("Mueve y amplía para elegir el encuadre.")
                .font(.footnote)
                .foregroundColor(Color.white.opacity(0.7))

            Spacer()

            Button {
                let recortada = recortar(ancho: 1024)
                onConfirmar(recortada)
            } label: {
                Text("Usar esta foto")
                    .font(.headline).foregroundColor(.black)
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(colorAcento, in: Capsule())
            }
            .padding(.horizontal, 24).padding(.bottom, 24)
        }
        .background(colorFondo.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }

    /// Recorta la imagen teniendo en cuenta escala + offset, respetando el aspect del marco.
    private func recortar(ancho: CGFloat) -> UIImage {
        let alto = ancho / aspectMarco
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: ancho, height: alto))
        return renderer.image { _ in
            let iw = imagenOriginal.size.width
            let ih = imagenOriginal.size.height
            let scaleToFill = max(ancho / iw, alto / ih) * escala
            let dw = iw * scaleToFill
            let dh = ih * scaleToFill
            let dx = (ancho - dw) / 2 + offset.width * (ancho / 400)
            let dy = (alto  - dh) / 2 + offset.height * (alto  / 400)
            imagenOriginal.draw(in: CGRect(x: dx, y: dy, width: dw, height: dh))
        }
    }
}
