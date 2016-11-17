//
//  Quest.swift
//  LevelUp
//
//  Created by jason on 11/9/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse

class Quest: NSObject {
    
    static let className = "Quest-Test"
    var pfObject: PFObject?
    var title: String?
    var image: UIImage?
    var dictionary: NSDictionary!
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
        
        title = pfObject["title"] as? String
        
        dictionary = NSDictionary()
        if let title = title {
            dictionary.setValue(title, forKey: "title")
        }
        
        // TODO Load Image from PFObject
//        let imageData = UIImagePNGRepresentation(image)
//        let imageFile = PFFile(name:"image.png", data:imageData)
//        
//        var userPhoto = PFObject(className:"UserPhoto")
//        userPhoto["imageName"] = "My trip to Hawaii!"
//        userPhoto["imageFile"] = imageFile
//        userPhoto.saveInBackground()
    }
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        title = dictionary["title"] as? String
        image = dictionary["image"] as? UIImage
    }
    
}

