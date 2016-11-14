//
//  ModelBase.swift
//  LevelUp
//
//  Created by jason on 11/13/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse

class ModelBase: NSObject {

    
    class var tableName : String {return "ModelBase"}
    class var ParseKeys: [String] { return []}

    
    var dictionary = [String: Any]()
    var _parseObject: PFObject?
    
    var objectId: String?

    
    
    
    init(_ _dictionary: [String: Any]) {
        
        self.dictionary = _dictionary
        _parseObject =  PFObject(className: type(of: self).tableName)
        _parseObject?.setDictionary(_dictionary)
        
        super.init()
        setVarsFromDictionary()
    }
    
    
    convenience init(parseObject: PFObject) {
        
        // Getting our values from our parse object
        var _dictionary = [String: Any]()
        
        for key in type(of: self).ParseKeys {
            if let value =  parseObject.object(forKey: key)  {
                _dictionary[key] = value
            }
        }
        
        self.init( _dictionary )
        
    }
    
    
    func setVarsFromDictionary(){}
    
    func save( success: @escaping () -> (), failure: @escaping () -> ()) {
        // Do stuff here before saving like saving images..
        // TODO: Maybe auto save files...
        actualSave(success:success, failure:failure)
    }
    
    func actualSave( success: @escaping () -> (), failure: @escaping () -> ()) {
        let pfQuest = PFObject(className: Quest.tableName)
        
        pfQuest.setDictionary(self.dictionary)
        pfQuest.saveInBackground(block: {
            (successStatus: Bool, error: Error?) -> () in
            if (successStatus) {
                success()
            } else {
                failure()
            }
        })
    }
    
    func cleanupDic() {
        // TODO: implement function to clean up dictionary to convert UIImage
        // into PF File
    }
    
    
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

    
    
}


extension PFObject {
    
    func setDictionary(_ dictionary: [String: Any]) {
        for (key, _) in dictionary {
            if let   val = dictionary[key] as? UIImage {
                let imageData = UIImagePNGRepresentation(val)
                let pfFile = PFFile(name:"image.png", data:imageData!)
                self.setValue(pfFile , forKey: key )

                
            } else {
                self.setValue(dictionary[key]! , forKey: key )
            }
        }
    }
    
}
