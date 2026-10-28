//
//  Confetti.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 26/10/26.
//

import SwiftUI


struct ConfettiView: UIViewRepresentable {
    func makeUIView(context: Context) -> ConfettiUIView {
        return ConfettiUIView()
    }
    
    func updateUIView(_ uiView: ConfettiUIView, context: Context) {}
}

class ConfettiUIView: UIView {
    private let emitter = CAEmitterLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.isUserInteractionEnabled = false
        
        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemYellow, .systemPink, .systemPurple, .systemOrange]
        
        let size = CGSize(width: 6, height: 6)
        let renderer = UIGraphicsImageRenderer(size: size)
        let particleImage = renderer.image { ctx in
            UIColor.white.setFill()
            ctx.cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))
        }
        
        emitter.emitterCells = colors.map { color in
            let cell = CAEmitterCell()
            cell.birthRate = 10
            cell.lifetime = 7.0
            cell.velocity = 100
            cell.velocityRange = 50
            cell.emissionLongitude = .pi
            cell.spin = 5
            cell.spinRange = 3
            cell.scale = 0.5
            cell.scaleRange = 0.2
            cell.color = color.cgColor
            cell.contents = particleImage.cgImage
            return cell
        }
        
        self.layer.addSublayer(emitter)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emitter.emitterPosition = CGPoint(x: bounds.width / 2, y: -50)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: bounds.width, height: 1)
    }
}
