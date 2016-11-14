//
//  Milestone.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/10/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse

class Milestone: ModelBase {
    
    override class var tableName : String {return "Milestones005"}
    override  class var ParseKeys: [String] { return [
        "questId",
        "notes",
        "completed"
        ]}
    var questId: String?
    var date: Date?
    var completed: Bool = false
    var icon: PFFile?
    var title: String?
    var notes: String?
    
   
    
}
