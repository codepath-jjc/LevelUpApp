//
//  Quest.swift
//  LevelUp
//
//  Created by jason on 11/9/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse

class Quest: ModelBase {
    
   override class var tableName : String {return "Quests003"}
   override  class var ParseKeys: [String] { return [
        "title"
    ]}    
    
    var title: String?
    var notes: String?
    var icon: PFFile?
    
    private var iconImage:UIImage?
    
    var tags: [String]?
    var archived: Bool = false
    var frequency = 1
  
    // Override this:
    override  func loadFromDictionary(){
        if let _title =  dictionary["title"] as? String  {
            title  = _title
        }
    
        // Depending in what format we are given the icon.
        // We always put it inside a PFFile
        if let _icon = dictionary["icon"] as? PFFile {
            icon = _icon
        } else if let _image = dictionary["icon"] as? UIImage {
            let imageData = UIImagePNGRepresentation(_image)
            icon = PFFile(name:"image.png", data:imageData!)
            dictionary["icon"] = icon // kinda sketchy..
            iconImage = _image // since it wont be online, lets just set it
        }
    }
    
    // Fetching the icon image:
    func fetchIcon(  success: @escaping (UIImage) -> (), failure: @escaping (Error)->() ) {
        
        if let loadedIcon = iconImage {
                success(loadedIcon)
        } else {
            if let userImageFile = icon {
                // TODO: make fxn:
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
    
 
    // TODO: add progress.. call.. but for multiple images?
    override func save( success: @escaping () -> (), failure: @escaping () -> ()) {
        
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
