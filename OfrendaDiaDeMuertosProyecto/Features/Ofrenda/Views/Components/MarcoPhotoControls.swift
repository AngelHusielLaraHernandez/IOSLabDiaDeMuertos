//
//  MarcoPhotoControls.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 17/10/26.
//

import SwiftUI

/// Controles asociados a los dos marcos, compartidos por el altar y su vista previa.
struct MarcoPhotoControls: View {
    struct Placement {
        let marco: MarcoOfrenda
        let anchor: CGPoint
        let center: CGPoint
        let photoBounds: CGRect
        var rect: CGRect { CGRect(x: center.x - 22, y: center.y - 22, width: 44, height: 44) }
    }

    let placements: [Placement]
    var isEnabled = true
    let onSelect: (MarcoOfrenda) -> Void

    var body: some View {
        ZStack {
            ForEach(placements, id: \.marco) { placement in
                Path { path in
                    path.move(to: placement.anchor)
                    path.addLine(to: placement.center)
                }
                .stroke(AppTheme.accent.opacity(0.55), lineWidth: 1)
                .allowsHitTesting(false)
                Button { onSelect(placement.marco) } label: {
                    Image(systemName: "photo.badge.plus")
                        .font(.body.weight(.semibold))
                        .frame(width: 44, height: 44)
                        .contentShape(.circle)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: .circle)
                .position(placement.center)
                .accessibilityLabel("Cambiar foto del \(placement.marco.titulo.lowercased())")
                .accessibilityHint("Elige, encuadra o restablece la foto de este marco")
                .disabled(!isEnabled)
            }
        }
    }

    static func placements(_ projections: [MarcoOfrenda: MarcoProjection], in size: CGSize) -> [Placement] {
        guard size.width > 100, size.height > 100 else { return [] }
        let viewport = CGRect(origin: .zero, size: size).insetBy(dx: 8, dy: 8)
        var result: [Placement] = []
        for marco in MarcoOfrenda.allCases {
            guard let projection = projections[marco] else { continue }
            let bounds = projection.bounds
            guard viewport.contains(CGPoint(x: bounds.midX, y: bounds.midY)),
                  bounds.width > 4, bounds.height > 4 else { continue }
            let anchor = CGPoint(x: marco == .izquierdo ? bounds.minX : bounds.maxX, y: bounds.maxY)
            let desiredX = anchor.x + (marco == .izquierdo ? -12 : 12)
            let center = CGPoint(
                x: min(size.width - 30, max(30, desiredX)),
                y: min(size.height - 30, max(30, anchor.y + 26))
            )
            result.append(Placement(marco: marco, anchor: anchor, center: center, photoBounds: bounds))
        }
        if result.count == 2, abs(result[0].center.x - result[1].center.x) < 52,
           abs(result[0].center.y - result[1].center.y) < 48 {
            let mid = min(size.width - 56, max(56, (result[0].center.x + result[1].center.x) / 2))
            result = result.enumerated().map { index, item in
                Placement(marco: item.marco, anchor: item.anchor,
                          center: CGPoint(x: mid + (index == 0 ? -26 : 26), y: item.center.y),
                          photoBounds: item.photoBounds)
            }
        }
        return result
    }

    static func reservedRects(_ placements: [Placement]) -> [CGRect] {
        placements.flatMap { [$0.photoBounds.insetBy(dx: -8, dy: -8), $0.rect.insetBy(dx: -4, dy: -4)] }
    }
}
