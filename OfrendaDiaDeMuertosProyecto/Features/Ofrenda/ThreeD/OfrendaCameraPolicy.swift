//
//  OfrendaCameraPolicy.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation


enum OfrendaCameraPolicy {
    static let yawLimit: Float = 65 * .pi / 180
    static let pitchRange: ClosedRange<Float> = (-8 * .pi / 180)...(22 * .pi / 180)
    static let zoomRange: ClosedRange<Float> = 0.45...2.5

    static func yaw(_ value: Float) -> Float {
        min(yawLimit, max(-yawLimit, value))
    }

    static func pitch(_ value: Float) -> Float {
        min(pitchRange.upperBound, max(pitchRange.lowerBound, value))
    }

    static func zoom(_ value: Float) -> Float {
        min(zoomRange.upperBound, max(zoomRange.lowerBound, value))
    }

    static func focusZoom(from value: Float) -> Float { zoom(value * 0.85) }
}
