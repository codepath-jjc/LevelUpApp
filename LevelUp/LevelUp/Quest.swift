//
//  Quest.swift
//  LevelUp
//
//  Created by jason on 11/9/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class Quest: NSObject {
    var title: String?
    var icon: URL?

    var dictionary: NSDictionary?

    
    init(_ dictionary: NSDictionary) {

        self.dictionary = dictionary

    }
    
}
