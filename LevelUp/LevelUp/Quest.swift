//
//  Quest.swift
//  LevelUp
//
//  Created by jason on 11/9/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse

class Quest: ModelBase {
    
   override class var tableName : String {return "Quests001"}
   override  class var ParseKeys: [String] { return [
        "title"
    ]}    
    
    var title: String?
    var notes: String?
    var icon: URL?
    var tags: [String]?
    var archived: Bool = false
    var frequency = 1
  
    // Override this:
    override func loadFromDictionary(_ dictionary: [String: Any]){
        if let _title =  dictionary["title"] as? String  {
            title  = _title
        }
    }
    
    
    func save(){
        
    }
    
}
