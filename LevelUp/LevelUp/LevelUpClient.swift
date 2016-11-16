//
//  LevelUpClient.swift
//  LevelUp
//
//  Created by jason on 11/10/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse

class LevelUpClient: NSObject {

    static let sharedInstance =  LevelUpClient()
    
    func sync(model: AnyObject, success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        let quest = model as? Quest
        let milestone = model as? Milestone
        
        if let quest = quest {
            
        }
        
        if let milestone = milestone {
            
        }
    }
    
    func quests(success: @escaping ([Quest]) -> (), failure: @escaping (Error?) -> ()) {
        
    }
    
    func milestones(success: @escaping ([Milestone]) -> (), failure: @escaping (Error?) -> ()) {
        
    }

}


