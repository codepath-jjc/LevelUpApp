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
                if let objects = objects {
                    for object in objects {
                        quests.append(  Quest(parseObject: object as PFObject))
                    }
                    success(quests)
                } else {
                    success([])
                }
            }
        }
    }
    
    func milestones(_ success: @escaping ([Milestone]) -> (), failure: @escaping (Error) -> ()) {
        
            var milestones = [Milestone]()
            PFQuery(className: Milestone.tableName).findObjectsInBackground {
                (objects: [PFObject]?, error: Error?) -> Void in                
                if let error = error {
                    failure(error)
                } else {
                    if let objects = objects {
                        for object in objects {
                            milestones.append(  Milestone(parseObject: object as PFObject))
                        }
                        success(milestones)
                    } else {
                        success([])
                    }
                }
            }
            
            
            
     
    }
    

    
    
}


