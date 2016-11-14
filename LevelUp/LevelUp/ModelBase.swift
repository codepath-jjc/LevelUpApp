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
