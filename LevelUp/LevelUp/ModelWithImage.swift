//
//  ModelWithImage.swift
//  LevelUp
//
//  Created by jason on 11/14/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse

class ModelWithImage: ModelBase {

    var icon: PFFile?
    var iconImage:UIImage?

    
    // Maybe do this in UIImage extention
    // XXX: todo fix this: with proper aspect ratio
    func resizeImage(image:UIImage) -> UIImage
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
    
    
    
    override  func setVarsFromDictionary(){

        
        // Depending in what format we are given the icon.
        // We always put it inside a PFFile
        if let _icon = dictionary["icon"] as? PFFile {
            icon = _icon
        } else if let largeImage = dictionary["icon"] as? UIImage {
            
            let _image = resizeImage(image: largeImage)
            
            let imageData = UIImagePNGRepresentation(_image)
            icon = PFFile(name:"image.png", data:imageData!)
            dictionary["icon"] = icon // kinda sketchy..
            iconImage = _image // since it wont be online, lets just set it
        }
    }
    
    
}
