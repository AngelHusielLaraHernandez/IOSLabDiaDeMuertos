//
//  GlassControls.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

extension View {
    func ofrendaPrimaryAction() -> some View {
        font(.headline)
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .tint(AppTheme.accent)
            .foregroundStyle(.black)
    }

    func ofrendaSecondaryAction() -> some View {
        font(.subheadline.weight(.semibold))
            .buttonStyle(.glass)
            .buttonBorderShape(.capsule)
            .controlSize(.regular)
            .tint(AppTheme.accent)
    }

    
    func ofrendaSurface(cornerRadius: CGFloat = 20) -> some View {
        background(AppTheme.surface.opacity(0.72), in: .rect(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(.white.opacity(0.06), lineWidth: 1)
                    .allowsHitTesting(false)
            }
    }

    
    func ofrendaSheet(detents: Set<PresentationDetent> = [.fraction(0.68), .large]) -> some View {
        presentationDetents(detents)
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(32)
            .preferredColorScheme(.dark)
            .tint(AppTheme.accent)
            .foregroundStyle(.white)
    }
}

struct GlassIconButton: View {
    let systemImage: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                .font(.body.weight(.semibold))
                .frame(width: 44, height: 44)
                .contentShape(.circle)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .circle)
        .accessibilityLabel(label)
    }
}

struct FlowNavigationBar: View {
    let onVolver: () -> Void
    var onSalir: (() -> Void)? = nil

    var body: some View {
        HStack {
            Button(action: onVolver) {
                Label("Volver", systemImage: "chevron.left")
                    .padding(.vertical, 4)
            }
            .ofrendaSecondaryAction()
            Spacer()
            AyudaGuiaContextualButton()
            if let onSalir {
                Button("Volver a la ofrenda", action: onSalir)
                    .ofrendaSecondaryAction()
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }
}
