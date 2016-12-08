//
//  Milestone.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/10/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

class Milestone: NSObject {
    
    static let className = "MilestoneTest11"
    var pfObject: PFObject?
    var imageFile: PFFile?
    var quest: Quest?
    var questId: String? {
        didSet {
            dictionary["questId"] = questId
        }
    }
    var title: String? {
        didSet {
            dictionary["title"] = title
        }
    }
    var image: UIImage? {
        didSet {
            dictionary["image"] = image
        }
    }
    var notes: String? {
        didSet {
            dictionary["notes"] = notes
        }
    }
    var deadline: Date? {
        didSet {
            dictionary["deadline"] = deadline
        }
    }
    var completed: Bool? {
        didSet {
            dictionary["completed"] = completed
        }
    }
    var completedDate: Date? {
        didSet {
            dictionary["completedDate"] = completedDate
        }
    }
    var dictionary = [String: Any]()
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
        
        if let imageFile =  pfObject.object(forKey: "image") as? PFFile {
            self.imageFile = imageFile
        }

        title = pfObject["title"] as? String
        notes = pfObject["notes"] as? String
        questId = pfObject["questId"] as? String
        completed = pfObject["completed"] as? Bool
        completedDate = pfObject["completedDate"] as? Date
        deadline = pfObject["deadline"] as? Date
        
        dictionary =  [String: Any]()
        if let title = title {
            dictionary["title"] = title
        }
        
        if let notes = notes {
            dictionary["notes"] = notes
        }
        
        if let completed = completed {
            dictionary["completed"] = completed
        }
        
        if let questId = questId {
            dictionary["questId"] = questId
        }
        
        image = dictionary["image"] as? UIImage
    }
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        if let user =  LevelUpClient.sharedInstance.user() {
            self.dictionary["user"] = user
        }
        
        title = dictionary["title"] as? String
        notes = dictionary["notes"] as? String
        questId = dictionary["questId"] as? String
        completed = dictionary["completed"] as? Bool
        deadline = dictionary["deadline"] as? Date
        completedDate = dictionary["completedDate"] as? Date
        quest = dictionary["quest"] as? Quest
        self.dictionary.removeValue(forKey: "quest")
    }
    
}
