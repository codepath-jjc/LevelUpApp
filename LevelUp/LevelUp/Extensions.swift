//
//  Extensions.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/11/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import Foundation
import UIKit
import Parse

extension UIView {
    
    func addDashedBorder(color: UIColor = AppColors.SecondaryTextColor, width: CGFloat = 2.0) {
        
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

extension PFObject {
    
    func setDictionary(_ dictionary: [String: Any]) {
        for (key, value) in dictionary {
            if !(key is String) {
                continue
            }
            if let imageLarge = value as? UIImage {
                let image = UIImage.resizeImageSize(image: imageLarge)
                let imageData = UIImagePNGRepresentation(image)
                let pfFile = PFFile(name:"image.png", data:imageData!)
                self.setValue(pfFile , forKey: key )
            } else if let frequency = value as? Frequency {
                self.setValue(frequency.rawValue, forKey: key)
            }
            else {
                self.setValue(value , forKey: key )
            }
        }
    }
    
}



extension UIImage {
    // Maybe do this in UIImage extention
    // XXX: todo fix this: with proper aspect ratio
    static func resizeImageSize(image:UIImage) -> UIImage
    {
        var actualHeight:Float = Float(image.size.height)
        var actualWidth:Float = Float(image.size.width)
        
        let maxHeight:Float = 180.0 //your choose height
        let maxWidth:Float = 180.0  //your choose width
        
        var imgRatio:Float = actualWidth/actualHeight
        let maxRatio:Float = maxWidth/maxHeight
        
        if (actualHeight > maxHeight) || (actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio)
            {
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else
            {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let rect:CGRect =
            CGRect(x: 0, y: 0, width: Int(actualWidth), height: Int(actualHeight))
        
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:NSData = UIImageJPEGRepresentation(img, 1.0)! as NSData
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData as Data)!
    }
    
}

extension Array where Element:Quest {
    
    func indexOf(quest: Quest?) -> Int {
        if quest == nil { return -1 }
        
        for (i, item) in self.enumerated() {
            if ((item as Quest).title == quest!.title ?? "") {
                return i
            }
        }
        return -1
    }
}
