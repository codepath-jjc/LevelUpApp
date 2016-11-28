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
    
    static let className = "QuestTest4"
    var pfObject: PFObject?
    var title: String?
    var image: UIImage?
    
    var imageFile: PFFile?
    var dictionary = [String: Any]()
    
    var frequency: String?
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
        
        title = pfObject.object(forKey: "title") as? String
        
        dictionary = [String: Any]()
        if let title = title {
            dictionary["title"] = title
        }
        
        if let imageFile =  pfObject.object(forKey: "image") as? PFFile {
            self.imageFile = imageFile
        }
        
        frequency = pfObject.object(forKey: "frequency") as? String
        
        if let frequency = frequency {
            dictionary["title"] = frequency
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
    
    init(dictionary: [String: Any]) {
        
        self.dictionary = dictionary
        if let user =  LevelUpClient.sharedInstance.user() {
            self.dictionary["user"] = user
        }
        
        frequency = dictionary["frequency"] as? String
        title = dictionary["title"] as? String
        image = dictionary["image"] as? UIImage
        
    }
    
    // Returns the upcoming milestone for this quest
    func upcomingMilestone() -> Milestone? {
        // TODO
        return Milestone(dictionary: [String:Any]())
    }
    
}

