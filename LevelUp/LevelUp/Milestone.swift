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
    
    static let className = "Milestone-Test"
    var pfObject: PFObject?
    var questId: String?
    var title: String?
    var notes: String?
    var deadline: Date?
    var completed: Bool?
    var dictionary: NSDictionary!
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
        
        title = pfObject["title"] as? String
        notes = pfObject["notes"] as? String
        completed = pfObject["completed"] as? Bool
        
        dictionary = NSDictionary()
        if let title = title {
            dictionary.setValue(title, forKey: "title")
        }
        
        if let notes = notes {
            dictionary.setValue(notes, forKey: "notes")
        }
        
        if let completed = completed {
            dictionary.setValue(completed, forKey: "completed")
        }
    }
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        title = dictionary["title"] as? String
        notes = dictionary["notes"] as? String
        completed = dictionary["completed"] as? Bool
    }
    
}
