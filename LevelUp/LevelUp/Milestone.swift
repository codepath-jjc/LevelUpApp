//
//  Milestone.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/10/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class Milestone: NSObject {
    var objectId: String?
    var questId: String?
    var date: Date?
    var completed: Bool = false
    var icon: URL?
    var title: String?
    var notes: String?
    var dictionary: NSDictionary?
    
    init(_ dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        
    }
    
}
