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
    
    static let className = "QuestTest3"
    var pfObject: PFObject?
    var title: String?
    var image: UIImage?
    
    var imageFile: PFFile?
    var dictionary = [String: Any]()
    
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
        title = dictionary["title"] as? String
        image = dictionary["image"] as? UIImage
        
    }
    
    // Returns the upcoming milestone for this quest
    func upcomingMilestone() -> Milestone? {
        // TODO
        return Milestone(dictionary: [String:Any]())
    }
    
}

