//
//  Quest.swift
//  LevelUp
//
//  Created by jason on 11/9/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse

class Quest: NSObject {
    
    static let className = "Quest-Test"
    var pfObject: PFObject?
    var title: String?
    var icon: UIImage?
    var dictionary: NSDictionary!
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
        
        title = pfObject["title"] as? String
        
        dictionary = NSDictionary()
        if let title = title {
            dictionary.setValue(title, forKey: "title")
        }
    }
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        title = dictionary["title"] as? String
    }
    
}

//class ModelWithImage: ModelBase {
//
//    var icon: PFFile?
//    var iconImage:UIImage?
//
//
//
//    // Fetching the icon image:
//    func fetchIcon(  success: @escaping (UIImage) -> (), failure: @escaping (Error)->() ) {
//
//        if let loadedIcon = iconImage {
//            success(loadedIcon)
//        } else {
//            if let userImageFile = icon {
//
//                userImageFile.getDataInBackground(block: { (imageData:Data?, error:Error?) in
//
//                    if error == nil {
//                        if let imageData = imageData {
//                            let image = UIImage(data:imageData)
//                            self.iconImage = image
//                            success((image)!)
//                        }
//                    } else {
//                        failure((error)!)
//                    }
//
//                })
//            }
//        }

