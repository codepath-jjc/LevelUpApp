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
    class var ParseKeys: [String] { return []}

    
    var dictionary = [String: Any]()
    var _parseObject: PFObject?
    
    var objectId: String?

    
    
    
    init(_ _dictionary: [String: Any]) {
        
        self.dictionary = _dictionary
        _parseObject =  PFObject(className: type(of: self).tableName)
        _parseObject?.setDictionary(_dictionary)
        
        super.init()
        loadFromDictionary()
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
    
    
    func loadFromDictionary(){}
    
    func save( success: @escaping () -> (), failure: @escaping () -> ()) {
        // Do stuff here before saving like saving images..
        // TODO: Maybe auto save files...
        actualSave(success:success, failure:failure)
    }
    
    func actualSave( success: @escaping () -> (), failure: @escaping () -> ()) {
        let pfQuest = PFObject(className: Quest.tableName)
        
        pfQuest.setDictionary(self.dictionary)
        pfQuest.saveInBackground(block: {
            (successStatus: Bool, error: Error?) -> () in
            if (successStatus) {
                success()
            } else {
                failure()
            }
        })
    }
    
    
}


extension PFObject {
    
    func setDictionary(_ dictionary: [String: Any]) {
        for (key, _) in dictionary {          
            self.setValue(dictionary[key]! , forKey: key )
        }
    }
    
}
