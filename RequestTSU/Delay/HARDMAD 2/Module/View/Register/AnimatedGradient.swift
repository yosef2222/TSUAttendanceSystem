//
//  Animation.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 21.02.2025.
//

import Foundation
import UIKit



class AnimatedGradientView: UIView {
    
    private var gradientLayers: [CAGradientLayer] = []
    private let colors: [UIColor] = [.lblueW, .lblueW1, .lblueW2, .lblueW3]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayers()
        startAnimation()
        addBlurEffect()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayers()
        startAnimation()
        addBlurEffect()
    }
    
    private func setupGradientLayers() {
        for (index, color) in colors.enumerated() {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [color.withAlphaComponent(0.8).cgColor, color.withAlphaComponent(0.2).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.type = .radial
            
            let size = max(bounds.width, bounds.height) * 1.5
            gradientLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)
            
            switch index {
            case 0:
                gradientLayer.position = CGPoint(x: bounds.width * 0.25, y: bounds.height * 0.75)
            case 1:
                gradientLayer.position = CGPoint(x: bounds.width * 0.75, y: bounds.height * 0.75)
            case 2:
                gradientLayer.position = CGPoint(x: 0, y: bounds.height * 0.25)
            case 3:
                gradientLayer.position = CGPoint(x: bounds.width * 0.75, y: 0)
            default:
                break
            }
            
            gradientLayer.cornerRadius = size / 2
            gradientLayer.masksToBounds = true
            
            layer.addSublayer(gradientLayer)
            gradientLayers.append(gradientLayer)
        }
    }
    
    private func startAnimation() {
        for gradientLayer in gradientLayers {
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = gradientLayer.position
            
            animation.toValue = CGPoint(x: CGFloat.random(in: 0...bounds.width),
                                        y: CGFloat.random(in: 0...bounds.height))
            animation.duration = 4.0
            animation.autoreverses = true
            animation.repeatCount = .infinity
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            gradientLayer.add(animation, forKey: nil)
        }
    }
    
    private func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}
