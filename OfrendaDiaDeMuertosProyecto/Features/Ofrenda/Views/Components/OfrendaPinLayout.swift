//
//  OfrendaPinLayout.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import CoreGraphics


enum OfrendaPinLayout {
    struct Pin {
        let id: String
        let anchor: CGPoint
        let width: CGFloat
        var zoomMaximo: Float = 2.5
    }

    struct Placement {
        let center: CGPoint
        let width: CGFloat
        var rect: CGRect {
            CGRect(x: center.x - width / 2, y: center.y - 22, width: width, height: 44)
        }
    }

    private static let gap: CGFloat = 16
    private static let margin: CGFloat = 12

    static func limit(for zoomFactor: Float) -> Int {
        if zoomFactor > 0.9 { return 8 }
        if zoomFactor > 0.7 { return 5 }
        if zoomFactor > 0.5 { return 3 }
        return 2
    }

    static func place(
        _ pins: [Pin], in size: CGSize,
        zoomFactor: Float = 1, selectedID: String? = nil,
        reservedRects: [CGRect] = []
    ) -> [String: Placement] {
        guard size.width > 100, size.height >= 100 else { return [:] }
        let viewport = CGRect(origin: .zero, size: size).insetBy(dx: 8, dy: 8)
        let center = CGPoint(x: size.width / 2, y: size.height / 2)

        var visible = pins.filter {
            zoomFactor <= $0.zoomMaximo &&
            $0.anchor.x.isFinite && $0.anchor.y.isFinite && viewport.contains($0.anchor)
        }
        if zoomFactor <= 0.9 || selectedID != nil {
            visible.sort {
                if ($0.id == selectedID) != ($1.id == selectedID) { return $0.id == selectedID }
                let a = distance($0.anchor, center), b = distance($1.anchor, center)
                return a == b ? $0.id < $1.id : a < b
            }
        } else {
        
            visible.sort {
                if $0.anchor.y != $1.anchor.y { return $0.anchor.y > $1.anchor.y }
                if $0.anchor.x != $1.anchor.x { return $0.anchor.x < $1.anchor.x }
                return $0.id < $1.id
            }
        }
        var placed: [String: Placement] = [:]
        var occupied = reservedRects
        for pin in visible {
            if placed.count == limit(for: zoomFactor) { break }
            let width = min(pin.width, size.width - 2 * margin)
            let minX = margin + width / 2
            let maxX = size.width - minX
            func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
                CGPoint(x: min(maxX, max(minX, x)), y: min(size.height - 34, max(34, y)))
            }
            let preferred = point(pin.anchor.x, pin.anchor.y)
            var candidates = [preferred]
            for y in stride(from: CGFloat(34), through: size.height - 34, by: 44 + gap) {
                for x in stride(from: minX, through: maxX, by: 16) {
                    candidates.append(CGPoint(x: x, y: y))
                }
                candidates.append(CGPoint(x: maxX, y: y))
            }
            candidates.sort { distance($0, preferred) < distance($1, preferred) }
            let maxShift = max(90, min(140, size.height * 0.32))
            guard let location = candidates.first(where: { candidate in
                if zoomFactor <= 0.9 && distance(candidate, pin.anchor) > maxShift * maxShift { return false }
                let rect = Placement(center: candidate, width: width).rect.insetBy(dx: -gap / 2, dy: -gap / 2)
                return !occupied.contains { $0.intersects(rect) }
            }) else { continue }
            let placement = Placement(center: location, width: width)
            placed[pin.id] = placement
            occupied.append(placement.rect.insetBy(dx: -gap / 2, dy: -gap / 2))
        }
     
        if zoomFactor > 0.9, placed.count < visible.count {
            let grid = gridPlacement(visible, in: size, reservedRects: reservedRects)
            if grid.count > placed.count { return grid }
        }
        return placed
    }

    private static func gridPlacement(_ pins: [Pin], in size: CGSize, reservedRects: [CGRect]) -> [String: Placement] {
        guard !pins.isEmpty else { return [:] }
        let width = min(pins.map(\.width).max() ?? 84, size.width - margin * 2)
        let columns = max(1, Int((size.width - margin * 2 + gap) / (width + gap)))
        let desiredRows = Int(ceil(Double(pins.count + reservedRects.count) / Double(columns)))
        let fittingRows = max(1, Int((size.height - margin * 2 + gap) / (44 + gap)))
        let rows = min(desiredRows, fittingRows)
        guard CGFloat(rows) * 44 + CGFloat(max(0, rows - 1)) * gap <= size.height - margin * 2 else { return [:] }
        var slots: [CGPoint] = []
        for row in 0..<rows {
            let y = rows == 1 ? size.height / 2 : 34 + CGFloat(row) * (size.height - 68) / CGFloat(rows - 1)
            for column in 0..<columns {
                let x = columns == 1 ? size.width / 2 : margin + width / 2 + CGFloat(column) * (size.width - margin * 2 - width) / CGFloat(columns - 1)
                let center = CGPoint(x: x, y: y)
                let rect = Placement(center: center, width: width).rect
                if !reservedRects.contains(where: { $0.intersects(rect.insetBy(dx: -gap / 2, dy: -gap / 2)) }) {
                    slots.append(center)
                }
            }
        }
        var result: [String: Placement] = [:]
        for pin in pins {
            if result.count == limit(for: 1) { break }
            guard let index = slots.indices.min(by: {
                distance(slots[$0], pin.anchor) < distance(slots[$1], pin.anchor)
            }) else { break }
            result[pin.id] = Placement(center: slots.remove(at: index), width: min(pin.width, width))
        }
        return result
    }

    private static func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let dx = a.x - b.x, dy = a.y - b.y
        return dx * dx + dy * dy
    }
}
