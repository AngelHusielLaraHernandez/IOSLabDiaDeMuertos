//
//  AjusteFotoView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct AjusteFotoView: View {
    let imagenOriginal: UIImage
    let onConfirmar: (UIImage) -> Void
    let onCancelar: () -> Void
    var aspectMarco: CGFloat = 4.0 / 5.0
    var titulo = "Ajusta su fotografía."
    var subtitulo = "EL RETRATO EN TU ALTAR"
    @State private var escala: CGFloat = 1
    @State private var offset: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero
    @State private var previewSize = CGSize(width: 320, height: 400)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                FlowNavigationBar(onVolver: onCancelar)
                VStack(alignment: .leading, spacing: 6) {
                    Text(subtitulo)
                        .font(.caption.bold()).tracking(0.8)
                        .foregroundStyle(AppTheme.accent)
                    Text(titulo)
                        .font(.largeTitle.bold())
                    Text("Centra su rostro dentro del marco.")
                        .foregroundStyle(AppTheme.secondaryText)
                }
                .padding(.horizontal, 24)
                GeometryReader { geometry in
                    let size = geometry.size
                    let filled = PhotoCropGeometry.filledSize(image: imagenOriginal.size, viewport: size, zoom: escala)
                    let displayedOffset = PhotoCropGeometry.clampedOffset(
                        CGSize(width: offset.width + dragOffset.width, height: offset.height + dragOffset.height),
                        image: imagenOriginal.size, viewport: size, zoom: escala
                    )
                    ZStack {
                        Image(uiImage: imagenOriginal)
                            .resizable()
                            .frame(width: filled.width, height: filled.height)
                            .offset(displayedOffset)
                    }
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(AppTheme.accent, lineWidth: 2)
                            .allowsHitTesting(false)
                    }
                    .clipShape(.rect(cornerRadius: 16))
                    .contentShape(.rect)
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in state = value.translation }
                            .onEnded { value in
                                offset = PhotoCropGeometry.clampedOffset(
                                    CGSize(width: offset.width + value.translation.width,
                                           height: offset.height + value.translation.height),
                                    image: imagenOriginal.size, viewport: size, zoom: escala
                                )
                            }
                    )
                    .onGeometryChange(for: CGSize.self) { $0.size } action: { size in
                        if previewSize.width > 0, previewSize.height > 0 {
                            offset.width *= size.width / previewSize.width
                            offset.height *= size.height / previewSize.height
                        }
                        previewSize = size
                        limitarDesplazamiento()
                    }
                }
                .objetivoGuiaContextual("ajuste.imagen")
                .aspectRatio(aspectMarco, contentMode: .fit)
                .frame(maxWidth: 360)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
                HStack(spacing: 16) {
                    GlassIconButton(systemImage: "minus", label: "Alejar fotografía") {
                        escala = max(1, escala - 0.25)
                    }
                    .disabled(escala <= 1)
                    Slider(value: $escala, in: 1...3)
                        .accessibilityLabel("Ampliación de la fotografía")
                    GlassIconButton(systemImage: "plus", label: "Acercar fotografía") {
                        escala = min(3, escala + 0.25)
                    }
                    .disabled(escala >= 3)
                }
                .padding(.horizontal, 24)
                Text("Mueve y amplía para elegir el encuadre. La foto conservará su proporción.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.secondaryText)
                    .padding(.horizontal, 24)
                Button { onConfirmar(recortar(ladoMaximo: 1024)) } label: {
                    Text("Usar esta foto")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .ofrendaPrimaryAction().objetivoGuiaContextual("ajuste.confirmar")
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .guiaContextual(.ajusteFoto)
        .onChange(of: escala) { _, _ in limitarDesplazamiento() }
    }

    private func limitarDesplazamiento() {
        offset = PhotoCropGeometry.clampedOffset(
            offset, image: imagenOriginal.size, viewport: previewSize, zoom: escala
        )
    }

    private func recortar(ladoMaximo: CGFloat) -> UIImage {
        let size = CGSize(width: ladoMaximo * min(1, aspectMarco), height: ladoMaximo / max(1, aspectMarco))
        let adjustedOffset = CGSize(
            width: offset.width * size.width / max(previewSize.width, 1),
            height: offset.height * size.height / max(previewSize.height, 1)
        )
        let rect = PhotoCropGeometry.imageRect(
            image: imagenOriginal.size, viewport: size, zoom: escala, offset: adjustedOffset
        )
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.preferredRange = .standard
        format.opaque = true
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            UIColor.black.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            imagenOriginal.draw(in: rect)
        }
    }
}
