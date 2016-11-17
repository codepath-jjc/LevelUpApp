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
    var objectId: String?
    var questId: String?
    var title: String?
    var notes: String?
    var deadline: Date?
    var completed: Bool = false
    var dictionary: NSDictionary!
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
    }
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
    }
    
}
