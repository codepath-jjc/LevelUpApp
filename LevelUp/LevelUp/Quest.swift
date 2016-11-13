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
    
    static let tableName = "Questz23"
    var objectId: String?
    var title: String?
    var notes: String?
    var icon: URL?
    var tags: [String]?
    var archived: Bool = false
    var frequency = 1
    var dictionary: NSDictionary?
    var _parseObject: PFObject?
    
    
    
    
    init(_ _dictionary: NSDictionary) {

        self.dictionary = _dictionary
        _parseObject =  PFObject(className: Quest.tableName)
        _parseObject?.setDictionary(_dictionary)
        
        super.init()
        loadFromDictionary(_dictionary)
        
        
    }
    
    
    convenience init(parseObject: PFObject) {
        // Getting our values from our parse object
        let keysArray = parseObject.dictionaryWithValues(forKeys: QuestKeys)
        var _dictionary = [String: Any]()
        print("keysArray")
        for (key, value) in keysArray {
            print(key, "value", value)
            _dictionary[key] = parseObject[key]
        }
        print("keysArray----")

        self.init(_dictionary as NSDictionary)
    }
    
    // Override this:
    func loadFromDictionary(_ dictionary: NSDictionary){
        
        print("dict", dictionary["title"]! )
        // self.parseObject = parseObject
        if let _title =  dictionary["title"] as? String {
            title  = _title
        }
        
        
        let name: AnyClass! = object_getClass(dictionary["title"])
        print(name)

        print("title", title)
    }
    
    
    
    
    func save(){
        
    }
    
}
