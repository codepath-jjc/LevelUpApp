//
//  ModelBase.swift
//  LevelUp
//
//  Created by jason on 11/13/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse

class ModelBase: NSObject {

    
    
    class var tableName : String {return "ModelBase"}
    
    class var ParseKeys: [String] { return [
        "title"
        ]}

        
    
    var dictionary = [String: Any]()
    var _parseObject: PFObject?
    
    var objectId: String?

    
    
    
    init(_ _dictionary: [String: Any]) {
        
        self.dictionary = _dictionary
        _parseObject =  PFObject(className: type(of: self).tableName)
        _parseObject?.setDictionary(_dictionary)
        
        super.init()
        loadFromDictionary(_dictionary)
    }
    
    
    convenience init(parseObject: PFObject) {
        
        // Getting our values from our parse object
        var _dictionary = [String: Any]()
        
        for key in type(of: self).ParseKeys {
            if let value =  parseObject.object(forKey: key)  {
                _dictionary[key] = value
            }
        }
        
        self.init( _dictionary )
        
    }
    
    
    func loadFromDictionary(_ dictionary: [String: Any]){
        
    }
    
}


extension PFObject {
    
    func setDictionary(_ dictionary: [String: Any]) {
        for (key, val) in dictionary {
            print("key", key, val)
            let name: AnyClass! = object_getClass(val)
            print("type?", name)
            //self.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
            self.setValue(dictionary[key]! , forKey: key )
        }
    }
    
}
