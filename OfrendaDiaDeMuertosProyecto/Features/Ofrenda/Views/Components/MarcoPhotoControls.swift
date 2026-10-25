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
        var width: CGFloat = 44
        var rect: CGRect { CGRect(x: center.x - width / 2, y: center.y - 22, width: width, height: 44) }
    }

    let placements: [Placement]
    var nombres: [MarcoOfrenda: String] = [:]
    var isEnabled = true
    var requiereCambioDeNombre = true
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
                    Group {
                        if let nombre = nombres[placement.marco], !nombre.isEmpty {
                            Text(nombre).font(.subheadline.bold()).lineLimit(1).truncationMode(.tail)
                        } else { Image(systemName: "photo.badge.plus").font(.body.weight(.semibold)) }
                    }
                    .padding(.horizontal, 10)
                    .frame(width: placement.width, height: 44)
                    .contentShape(.capsule)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: .capsule)
                .position(placement.center)
                .accessibilityLabel("Editar foto: \(nombres[placement.marco].flatMap { $0.isEmpty ? nil : $0 } ?? placement.marco.titulo)")
                .accessibilityHint(requiereCambioDeNombre ? "Para reemplazar una foto personal, cambia también su nombre" : "Elige y encuadra la fotografía de este marco")
                .disabled(!isEnabled)
            }
        }
    }

    static func placements(_ projections: [MarcoOfrenda: MarcoProjection], in size: CGSize, nombres: [MarcoOfrenda: String] = [:]) -> [Placement] {
        guard size.width > 100, size.height > 100 else { return [] }
        let viewport = CGRect(origin: .zero, size: size).insetBy(dx: 8, dy: 8)
        var result: [Placement] = []
        for marco in MarcoOfrenda.allCases {
            guard let projection = projections[marco] else { continue }
            let bounds = projection.bounds
            guard viewport.contains(CGPoint(x: bounds.midX, y: bounds.midY)),
                  bounds.width > 4, bounds.height > 4 else { continue }
            let anchor = CGPoint(x: marco == .izquierdo ? bounds.minX : bounds.maxX, y: bounds.maxY)
            let nombre = nombres[marco] ?? ""
            let width: CGFloat = nombre.isEmpty ? 44 : min(size.width / 2 - 16, max(64, CGFloat(nombre.count) * 9 + 24))
            let margen = width / 2 + 8
            let desiredX = anchor.x + (marco == .izquierdo ? -12 : 12)
            let center = CGPoint(
                x: min(size.width - margen, max(margen, desiredX)),
                y: min(size.height - 30, max(30, anchor.y + 26))
            )
            result.append(Placement(marco: marco, anchor: anchor, center: center, photoBounds: bounds, width: width))
        }
        if result.count == 2, result[0].rect.insetBy(dx: -4, dy: -4).intersects(result[1].rect) {
            let total = result[0].width + result[1].width + 8
            let mid = min(size.width - total / 2 - 8, max(total / 2 + 8, (result[0].center.x + result[1].center.x) / 2))
            result = result.enumerated().map { index, item in
                let x = index == 0 ? mid - total / 2 + item.width / 2 : mid + total / 2 - item.width / 2
                return Placement(marco: item.marco, anchor: item.anchor,
                    center: CGPoint(x: x, y: item.center.y), photoBounds: item.photoBounds, width: item.width)
            }
        }
        return result
    }

    static func reservedRects(_ placements: [Placement]) -> [CGRect] {
        placements.flatMap { [$0.photoBounds.insetBy(dx: -8, dy: -8), $0.rect.insetBy(dx: -4, dy: -4)] }
    }
}
