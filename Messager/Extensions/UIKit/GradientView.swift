//
//  GradientView.swift
//  Messager
//
//  Created by Сергей on 09.11.2021.
//

import UIKit

/*
 class GradientView to create gradient for UIView
 */
class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    enum Point {
        case topLeading
        case leading
        case bottomLeading
        case top
        case center
        case bottom
        case trailing
        case topTrailing
        case bottomTrailing
        
        var point: CGPoint {
            switch self {
            case .topLeading:        return CGPoint(x: 0, y: 0)
            case .leading:           return CGPoint(x: 0, y: 0.5)
            case .bottomLeading:     return CGPoint(x: 0, y: 1)
            case .top:               return CGPoint(x: 0.5, y: 0)
            case .center:            return CGPoint(x: 0.5, y: 0.5)
            case .bottom:            return CGPoint(x: 0.5, y: 1)
            case .trailing:          return CGPoint(x: 1, y: 0.5)
            case .topTrailing:       return CGPoint(x: 1, y: 0)
            case .bottomTrailing:    return CGPoint(x: 1, y: 1)
            }
        }
    }
    
    init(from: Point, to: Point, startColor: UIColor, endColor: UIColor) {
        self.init()
        setupGradient(from: from, to: to, startColor: startColor, endColor: endColor)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient(from: .leading, to: .trailing, startColor: .red, endColor: .green)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupGradient(from: Point, to: Point, startColor: UIColor, endColor: UIColor) {
        self.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = from.point
        gradientLayer.endPoint = to.point
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
