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
    
    // This is a mutating function - the input Quest and Milestone WILL be updated
    func sync(quest: inout Quest, success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        
        if let questPfObject = quest.pfObject {
            // Update the PFObject on the quest and save in background
            questPfObject.setDictionary(quest.dictionary)
            questPfObject.saveInBackground(block: {
                (successStatus: Bool, error: Error?) -> Void in
                if successStatus {
                    success()
                } else {
                    failure(error)
                }
            })
        } else {
            // Create - since it must not exist on Parse
            var questPFObject = PFObject(className: Quest.className)
            questPFObject.setDictionary(quest.dictionary)
            
            // Save
            questPFObject.saveInBackground {
                (successStatus: Bool, error: Error?) -> Void in
                if successStatus {
                    success()
                } else {
                    failure(error)
                }
            }
            quest.pfObject = questPFObject
        }
    }
    
    // This is a mutating function - the input Quest and Milestone WILL be updated
    func sync(milestone: inout Milestone, success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        
        if let milestonePfObject = milestone.pfObject {
            // Update
            milestonePfObject.setDictionary(milestone.dictionary)
            milestonePfObject.saveInBackground(block: {
                (successStatus: Bool, error: Error?) -> Void in
                if successStatus {
                    success()
                } else {
                    failure(error)
                }
            })

        } else {
            // Create - since it must not exist on Parse
            var milestonePFObject = PFObject(className: Milestone.className)
            milestonePFObject.setDictionary(milestone.dictionary)
            
            // Save
            milestonePFObject.saveInBackground {
                (successStatus: Bool, error: Error?) -> Void in
                if (successStatus) {
                    success()
                } else {
                    failure(error)
                }
            }
            milestone.pfObject = milestonePFObject
        }
    }
    
    // Refresh local object from Parse
    func fetch(quest: inout Quest) {
        try? quest.pfObject?.fetch()
    }
    
    func fetch(milestone: inout Milestone) {
        try? milestone.pfObject?.fetch()
    }
    
    func quests(success: @escaping ([Quest]) -> (), failure: @escaping (Error?) -> ()) {
        let query = PFQuery(className: Quest.className)
        query.findObjectsInBackground(block: {
            (pfObjects: [PFObject]?, error: Error?) -> () in
            if let pfObjects = pfObjects {
                var quests = [Quest]()
                for pfObject in pfObjects {
                    quests.append(Quest(pfObject: pfObject))
                }
                
                success(quests)
            } else {
                failure(error)
            }
        })
    }
    
    func milestones(success: @escaping ([Milestone]) -> (), failure: @escaping (Error?) -> ()) {
        let query = PFQuery(className: Milestone.className)
        query.findObjectsInBackground(block: {
            (pfObjects: [PFObject]?, error: Error?) -> () in
            if let pfObjects = pfObjects {
                var milestones = [Milestone]()
                for pfObject in pfObjects {
                    milestones.append(Milestone(pfObject: pfObject))
                }
                
                success(milestones)
            } else {
                failure(error)
            }
        })
    }

}


