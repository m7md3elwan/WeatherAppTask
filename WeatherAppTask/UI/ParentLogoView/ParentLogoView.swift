//
//  ParentLogoView.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/10/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import UIKit

class ParentLogoView: UIView {
    
    // MARK: Constants
    struct constants {
       static var animationDuration: TimeInterval = 1
        static var logoWidth: Double = 200
        static var logoHeight: Double = 90
        static var logoToTitleOffset: Double = 16
    }
    
    // MARK: Properties
    var leftPath: UIBezierPath = {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 93.33, y: 28.52))
        bezierPath.addCurve(to: CGPoint(x: 57.65, y: 1.17), controlPoint1: CGPoint(x: 93.33, y: 28.52), controlPoint2: CGPoint(x: 89.82, y: -6.8))
        bezierPath.addCurve(to: CGPoint(x: 36.02, y: 35.93), controlPoint1: CGPoint(x: 25.49, y: 9.15), controlPoint2: CGPoint(x: 36.02, y: 35.93))
        bezierPath.addCurve(to: CGPoint(x: 0.93, y: 57.01), controlPoint1: CGPoint(x: 36.02, y: 35.93), controlPoint2: CGPoint(x: 7.95, y: 26.81))
        bezierPath.addCurve(to: CGPoint(x: 29, y: 90.06), controlPoint1: CGPoint(x: -6.09, y: 87.21), controlPoint2: CGPoint(x: 29, y: 90.06))
        bezierPath.addLine(to: CGPoint(x: 93.33, y: 90.06))
        bezierPath.addLine(to: CGPoint(x: 93.33, y: 80.37))
        bezierPath.addCurve(to: CGPoint(x: 75.78, y: 62.71), controlPoint1: CGPoint(x: 93.33, y: 80.37), controlPoint2: CGPoint(x: 85.09, y: 71))
        bezierPath.addCurve(to: CGPoint(x: 61.75, y: 38.78), controlPoint1: CGPoint(x: 67.61, y: 55.42), controlPoint2: CGPoint(x: 57.92, y: 49.97))
        bezierPath.addCurve(to: CGPoint(x: 93.33, y: 28.52), controlPoint1: CGPoint(x: 69.93, y: 14.85), controlPoint2: CGPoint(x: 93.33, y: 28.52))
        bezierPath.close()
        return bezierPath
    }()
    
    var rightPath: UIBezierPath = {
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 106.67, y: 28.52))
        bezier2Path.addCurve(to: CGPoint(x: 142.35, y: 1.17), controlPoint1: CGPoint(x: 106.67, y: 28.52), controlPoint2: CGPoint(x: 110.18, y: -6.8))
        bezier2Path.addCurve(to: CGPoint(x: 163.98, y: 35.93), controlPoint1: CGPoint(x: 174.51, y: 9.15), controlPoint2: CGPoint(x: 163.98, y: 35.93))
        bezier2Path.addCurve(to: CGPoint(x: 199.07, y: 57.01), controlPoint1: CGPoint(x: 163.98, y: 35.93), controlPoint2: CGPoint(x: 192.05, y: 26.81))
        bezier2Path.addCurve(to: CGPoint(x: 171, y: 90.06), controlPoint1: CGPoint(x: 206.09, y: 87.21), controlPoint2: CGPoint(x: 171, y: 90.06))
        bezier2Path.addLine(to: CGPoint(x: 106.67, y: 90.06))
        bezier2Path.addLine(to: CGPoint(x: 106.67, y: 80.37))
        bezier2Path.addCurve(to: CGPoint(x: 124.22, y: 62.71), controlPoint1: CGPoint(x: 106.67, y: 80.37), controlPoint2: CGPoint(x: 114.91, y: 71))
        bezier2Path.addCurve(to: CGPoint(x: 138.25, y: 38.78), controlPoint1: CGPoint(x: 132.39, y: 55.42), controlPoint2: CGPoint(x: 142.08, y: 49.97))
        bezier2Path.addCurve(to: CGPoint(x: 106.67, y: 28.52), controlPoint1: CGPoint(x: 130.07, y: 14.85), controlPoint2: CGPoint(x: 106.67, y: 28.52))
        bezier2Path.close()
        return bezier2Path
    }()
    
    var textLayer: CATextLayer = {
        let myTextLayer = CATextLayer()
        myTextLayer.string = "Parent Weather \n Application"
        myTextLayer.fontSize = 20
        myTextLayer.alignmentMode = "center"
        myTextLayer.backgroundColor = UIColor.clear.cgColor
        myTextLayer.foregroundColor = UIColor.logoStrokeColor.cgColor
        myTextLayer.frame = CGRect(x: 0, y: constants.logoHeight + constants.logoToTitleOffset, width: constants.logoWidth, height: constants.logoHeight)
        myTextLayer.opacity = 0
        return myTextLayer
    }()
    
    func caShapeLayer(from bezierPath: UIBezierPath) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = bezierPath.cgPath
        layer.strokeEnd = 0
        layer.lineWidth = 2
        layer.strokeColor = UIColor.logoStrokeColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        return layer
    }
    
    func show(animated: Bool) {

        let leftShape = caShapeLayer(from: leftPath)
        let rightShape = caShapeLayer(from: rightPath)
        
        layer.addSublayer(leftShape)
        layer.addSublayer(rightShape)
        layer.addSublayer(textLayer)

        let layers: [CALayer] = [leftShape, rightShape, textLayer]

        guard animated == true else {
            
            layers.enumerated().forEach{ offset, layer in
                if let shapeLayer = layer as? CAShapeLayer {
                    shapeLayer.fillColor = UIColor.logoFillColor.cgColor
                }
            }
            
            layers.enumerated().forEach{offset, layer in
                layer.opacity = 1
            }
            return
        }
        
        layers.enumerated().forEach { offset, layer in
            
            var animation = CABasicAnimation()
            
            if layer is CAShapeLayer {
                animation = CABasicAnimation(keyPath: "strokeEnd")
            } else {
                animation = CABasicAnimation(keyPath: "opacity")
            }
            
            animation.beginTime = constants.animationDuration * CFTimeInterval(offset)
            animation.toValue = 1
            animation.duration = constants.animationDuration
            animation.fillMode = kCAFillModeForwards
            
            let group = CAAnimationGroup()
            group.animations = [animation]
            group.isRemovedOnCompletion = false
            group.duration = CFTimeInterval(layers.count + 1) * constants.animationDuration + 1
            group.repeatCount = .infinity
            group.fillMode = kCAFillModeForwards

            layer.add(group, forKey: "logoAnimation")
        }
        
    }
    
}
