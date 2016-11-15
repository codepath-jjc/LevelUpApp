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

    
    
    // Fetching the icon image:
    func fetchIcon(  success: @escaping (UIImage) -> (), failure: @escaping (Error)->() ) {
        
        if let loadedIcon = iconImage {
            success(loadedIcon)
        } else {
            if let userImageFile = icon {
                
                userImageFile.getDataInBackground(block: { (imageData:Data?, error:Error?) in
                    
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            self.iconImage = image
                            success((image)!)
                        }
                    } else {
                        failure((error)!)
                    }
                    
                })
            }
        }
    }
    
    
    override  func setVarsFromDictionary(){

        
        // Depending in what format we are given the icon.
        // We always put it inside a PFFile
        if let _icon = dictionary["icon"] as? PFFile {
            icon = _icon
        } else if let largeImage = dictionary["icon"] as? UIImage {
            
            let _image = UIImage.resizeImageSize(image: largeImage)
            
            let imageData = UIImagePNGRepresentation(_image)
            icon = PFFile(name:"image.png", data:imageData!)
            dictionary["icon"] = icon // kinda sketchy..
            iconImage = _image // since it wont be online, lets just set it
        }
    }
    
    
    // XXX: TODO(Jason): Seems we dont have to worry about saving iamges first,
    // the other call will take care of it for us.
    
    
    // TODO: add progress.. call.. but for multiple images?
    override func save( success: @escaping () -> (), failure: @escaping () -> ()) {
        
        _parseObject?.setDictionary(dictionary)
        
        // Maybe not save the image every time? unless different and not saved
        if let imageFile = icon {
            
            imageFile.saveInBackground({
                (succeeded: Bool, error: Error?) -> Void in
                // Handle success or failure here ...
                if succeeded {
                    self.actualSave(success: success, failure: failure)
                } else {
                    failure()
                }
                }, progressBlock: {
                    (percentDone: Int32) -> Void in
                    // Update your progress spinner here. percentDone will be between 0 and 100.
                    print(percentDone)
            })
            
        }
        
    }
    
    
}
