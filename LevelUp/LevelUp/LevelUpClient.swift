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
    
    func quests(_ success: @escaping ([Quest]) ->(), failure: @escaping (Error) -> ()){
        
        var quests = [Quest]()
        let questsQuery = PFQuery(className:"Questz")
        
        questsQuery.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if let error = error {                
                failure(error)
            } else {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        
                      
                        quests.append(  Quest(parseObject: object as PFObject))
                    }
                    success(quests)
                } else {
                    success([])
                }

                
                // Log details of the failure
                
            }
        }
        
        //
    }
    
    func milestones(_ success: @escaping ([Milestone]) -> (), failure: @escaping (Error) -> ()) {
        // TODO grab milestones from parse or local storage

    }
    

    func saveQuest(_ quest: Quest, success: @escaping (Quest) -> (), failure: @escaping (Error?) -> ()) {
        let pfQuest = PFObject(className: "Quest")
        
       // pfQuest.dictionaryWithValues(forKeys: <#T##[String]#>)
        // pfQuest.setDictionary(quest.dictionary)
        pfQuest.saveInBackground(block: {
            (successStatus: Bool, error: Error?) -> () in
            if (successStatus) {
                success(quest)
            } else {
                failure(error)
            }
        })
    }
    
    func saveMilestone(_ milestone: Milestone, success: @escaping (Milestone) -> (), failure: @escaping (Error?) -> ()) {
        let pfMilestone = PFObject(className: "Milestone")
        pfMilestone.setDictionary(milestone.dictionary)
        pfMilestone.saveInBackground(block: {
            (successStatus: Bool, error: Error?) -> () in
            if (successStatus) {
                success(milestone)
            } else {
                failure(error)
            }
        })
    }
    
}

extension PFObject {
    
    func setDictionary(_ dictionary: NSDictionary?) {
        guard let dictionary = dictionary else { return }
        
        for (key, val) in dictionary {
            self.add(val, forKey: key as! String)
        }
    }
    
}
