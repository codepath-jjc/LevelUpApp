//
//  Quest.swift
//  LevelUp
//
//  Created by jason on 11/9/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class Quest: NSObject {
    var objectId: String?
    var title: String?
    var notes: String?
    var icon: URL?
    var tags: [String]?
    var archived: Bool = false
    var frequency = 1
    var dictionary: NSDictionary?
    
    init(_ dictionary: NSDictionary) {

        self.dictionary = dictionary
        title  = dictionary["title"] as? String
    }
    
}
