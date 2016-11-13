//
//  Extensions.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/11/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addDashedBorder(color: UIColor, width: CGFloat = 2.0) {
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        layer.addSublayer(shapeLayer)
    }
    
}
