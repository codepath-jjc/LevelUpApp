//
//  Quest.swift
//  LevelUp
//
//  Created by jason on 11/9/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse

let QuestKeys = [
    "title",
    "notes"
]

class Quest: NSObject {
    
    static let tableName = "Questz018"
    var objectId: String?
    var title: String?
    var notes: String?
    var icon: URL?
    var tags: [String]?
    var archived: Bool = false
    var frequency = 1
    var dictionary = [String: Any]()
    var _parseObject: PFObject?
    
    
    
    
    init(_ _dictionary: [String: Any]) {

        self.dictionary = _dictionary
        _parseObject =  PFObject(className: Quest.tableName)
        _parseObject?.setDictionary(_dictionary)
        
        super.init()
        loadFromDictionary(_dictionary)
        
        
    }
    
    
    convenience init(parseObject: PFObject) {
        // Getting our values from our parse object

        var _dictionary = [String: Any]()
        print("keysArray")
        for key in QuestKeys {
            
            if let value =  parseObject.object(forKey: key)  {
                print("key", key, "value", value)
                let name: AnyClass! = object_getClass(value)
                print(name)
                _dictionary[key] = value
            }
            
        }
        print("keysArray---- now about to init normal")

        
        self.init(_dictionary )
    }
    
    // Override this:
    func loadFromDictionary(_ dictionary: [String: Any]){
        
        print("dict", dictionary["title"]! )
        // self.parseObject = parseObject
        if let _title =  dictionary["title"] as? String  {
            title  = _title
        }
        
        
        let name: AnyClass! = object_getClass(dictionary["title"])
        // print(name)

       // print("title", title)
    }
    
    
    
    
    func save(){
        
    }
    
}
