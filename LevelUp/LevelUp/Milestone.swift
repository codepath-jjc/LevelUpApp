//
//  Milestone.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/10/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse

class Milestone: NSObject {
    
    static let className = "MilestoneTest6"
    var pfObject: PFObject?
    var questId: String?
    var title: String?
    var notes: String?
    var deadline: Date?
    var completed: Bool?
    var dictionary = [String: Any]()
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
        
        title = pfObject["title"] as? String
        notes = pfObject["notes"] as? String
        completed = pfObject["completed"] as? Bool
        
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
    }
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        if let user =  LevelUpClient.sharedInstance.user() {
            self.dictionary["user"] = user
        }
        
        title = dictionary["title"] as? String
        notes = dictionary["notes"] as? String
        completed = dictionary["completed"] as? Bool
    }
    
}
