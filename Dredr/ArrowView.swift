//
//  ArrowView.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/8/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

@IBDesignable
class ArrowView: UIView {
    @IBInspectable var isFacingUp: Bool = true
    @IBInspectable var pullCoefficient: CGFloat = 0 {
        didSet {
            pullCoefficient = max(min(pullCoefficient, 1.0), 0.0)
            if pullCoefficient != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        let animationCenterPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        let maxLineLength = CGFloat(20)
        
        let lightIndex: CGFloat = 225
        let darkIndex: CGFloat = 156
        
        let colorIndex = lightIndex - (lightIndex - darkIndex) * pullCoefficient
        let lineColor = UIColor(red: colorIndex / 256, green: colorIndex / 256, blue: colorIndex / 256, alpha: 1.0)
        lineColor.setStroke()
        
        if pullCoefficient <= 0.5 {
            let lineLength = maxLineLength * CGFloat(pullCoefficient) / 0.5
            let path = UIBezierPath()
            let startPoint = CGPoint(x: animationCenterPoint.x - lineLength / 2, y: animationCenterPoint.y)
            let endPoint = CGPoint(x: animationCenterPoint.x + lineLength / 2, y: animationCenterPoint.y)
            
            path.moveToPoint(startPoint)
            path.addLineToPoint(endPoint)
            path.lineWidth = 2
            path.lineCapStyle = kCGLineCapRound
            
            path.stroke()
            
        } else {
            let maxAngle = 30 * 180 / M_PI
            let maxoffSet = maxLineLength / 2 * CGFloat(tan(maxAngle)) * (isFacingUp ? 1 : -1)
            
            let startPoint = CGPoint(x: animationCenterPoint.x - maxLineLength / 2, y: animationCenterPoint.y)
            let endPoint = CGPoint(x: animationCenterPoint.x + maxLineLength / 2, y: animationCenterPoint.y)
            let midPoint = CGPoint(x: animationCenterPoint.x, y: animationCenterPoint.y - maxoffSet * (pullCoefficient - 0.5) / 0.5)
            
            let path = UIBezierPath()
            path.moveToPoint(startPoint)
            path.addLineToPoint(midPoint)
            path.moveToPoint(midPoint)
            path.addLineToPoint(endPoint)
            path.lineWidth = 2
            path.lineCapStyle = kCGLineCapRound
            path.stroke()
        }
    }
    

}
