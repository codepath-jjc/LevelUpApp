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
        let questsQuery = PFQuery(className: Quest.tableName)
        
        questsQuery.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if let error = error {                
                failure(error)
            } else {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) quests.")
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
        let pfQuest = PFObject(className: Quest.tableName)
        
       // pfQuest.dictionaryWithValues(forKeys: <#T##[String]#>)
//        print("STrING?", quest.dictionary["title"])
        pfQuest.setDictionary(quest.dictionary)
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
        /*
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
        */
    }
    
}


