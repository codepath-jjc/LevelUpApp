//
//  ModelBase.swift
//  LevelUp
//
//  Created by jason on 11/13/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse


// TODO: maybe just base it all off of Parse objects....

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
        setVarsFromDictionary()
    }
    
    
    required convenience init(parseObject: PFObject) {
        // Getting our values from our parse object
        var _dictionary = [String: Any]()
        
        for key in type(of: self).ParseKeys {
            if let value =  parseObject.object(forKey: key)  {
                _dictionary[key] = value
            }
        }
        self.init( _dictionary )
    }
    
    
    func setVarsFromDictionary(){}
    
    func save( success: @escaping () -> (), failure: @escaping () -> ()) {

        // Do stuff here before saving..
        actualSave(success:success, failure:failure)
    }
    
    // Maybe just do super.save
    func actualSave( success: @escaping () -> (), failure: @escaping () -> ()) {
        let pfQuest = PFObject(className: Quest.tableName)
        
        pfQuest.setDictionary(self.dictionary)
        pfQuest.saveInBackground(block: {
            (successStatus: Bool, error: Error?) -> () in
            if (successStatus) {
                self.objectId = pfQuest.objectId
                print("--saved: objectId: \(self.objectId)")
                success()
            } else {
                failure()
            }
        })
    }
        
    
    class func all<T: ModelBase>(_ success: @escaping ([T]) ->(), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: T.tableName)
        
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if let error = error {
                failure(error)
                return
            }
            
            guard let objects = objects else {
                success([])
                return
            }
            
            let models = objects.map{ T(parseObject: $0 ) }
            success(models)
        }
    }
    
}


extension PFObject {
    
    func setDictionary(_ dictionary: [String: Any]) {
        for (key, _) in dictionary {
            if let   val = dictionary[key] as? UIImage {
                let imageData = UIImagePNGRepresentation(val)
                let pfFile = PFFile(name:"image.png", data:imageData!)
                self.setValue(pfFile , forKey: key )

                
            } else {
                self.setValue(dictionary[key]! , forKey: key )
            }
        }
    }
    
}
