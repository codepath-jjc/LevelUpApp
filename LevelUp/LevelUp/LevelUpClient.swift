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
    
    
    static var cachedQuests: [Quest]? {
        didSet {
            guard cachedQuests != nil else {return}
            
            for cachedQuest in cachedQuests! {
                LevelUpClient.sharedInstance.fetchIcon(quest: cachedQuest, success: {
                    (image: UIImage) -> () in
                    cachedQuest.image = image
                }, failure: {
                    (error: Error) -> () in
                    //
                })
            }
        }
    }
    static var cachedMilestones: [Milestone]?
    static var __points = 1
    
    func fetchIcon(quest: Quest, success: @escaping (UIImage) -> (), failure: @escaping (Error)->() ) {
        
        if let loadedIcon = quest.image {
            success(loadedIcon)
        } else {
            // XXX: if this is not defined, it should go to an else but that doesnt work in swift?..
            if let userImageFile = quest.imageFile {
                
                userImageFile.getDataInBackground(block: { (imageData:Data?, error:Error?) in
                    
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            quest.image = image
                            success((image)!)
                        }
                    } else {
                        failure((error)!)
                    }
                    
                })
            }
            if quest.imageFile == nil {
                var imageIndex = 0
                if quest.imageFallback == nil {
                
                } else {
                    imageIndex = quest.imageFallback!
                }
                if let image = Quest.images[imageIndex] {
                    success(image)
                }
                
            }
        }
    }
    
    
    func user() -> PFUser?{
        let currentUser = PFUser.current()
        
        
        if let currentUser = currentUser  {
            
            currentUser.setValue(0, forKey: "points")
            currentUser.saveInBackground()
            
            return currentUser
            // Do stuff with the user
            
        }
        
        return nil
    }
    
    func getPoints() -> Int {
        return LevelUpClient.__points
     //   try? LevelUpClient.sharedInstance.user()!.fetch()
       // return LevelUpClient.sharedInstance.user()!["points"] as! Int
    }
    
    
    func addPoints(points: Int){
        LevelUpClient.__points += points
        // LevelUpClient.sharedInstance.user()!.incrementKey("points", byAmount: points as NSNumber)
         // LevelUpClient.sharedInstance.user()!.saveInBackground()
    }
    
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
            let questPFObject = PFObject(className: Quest.className)
            questPFObject.setDictionary(quest.dictionary)
            
            
            // XXX: this is not ideal since we will not get the progress indicator
            // TODO(Jason): Implement save progressively
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
            milestonePfObject.setDictionary(milestone.dictionary )
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
            let milestonePFObject = PFObject(className: Milestone.className)
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
        query.whereKey("user", equalTo: LevelUpClient.sharedInstance.user()!)
        
        query.findObjectsInBackground(block: {
            (pfObjects: [PFObject]?, error: Error?) -> () in
            if let pfObjects = pfObjects {
                var quests = [Quest]()
                for pfObject in pfObjects {
                    quests.append(Quest(pfObject: pfObject))
                }
                
                LevelUpClient.cachedQuests = quests
                success(quests)
            } else {
                
                failure(error)
            }
        })
    }
    
    func milestones(success: @escaping ([Milestone]) -> (), failure: @escaping (Error?) -> ()) {
        let query = PFQuery(className: Milestone.className)
        query.whereKey("user", equalTo: LevelUpClient.sharedInstance.user()!)

        query.findObjectsInBackground(block: {
            (pfObjects: [PFObject]?, error: Error?) -> () in
            if let pfObjects = pfObjects {
                var milestones = [Milestone]()
                for pfObject in pfObjects {
                    let milestone = Milestone(pfObject: pfObject)
                    if let id = milestone.questId {
                        milestone.quest = LevelUpClient.cachedQuests?.find(questId: id)
                    }
                    milestones.append(milestone)
                }
                
                LevelUpClient.cachedMilestones = milestones
                success(milestones)
            } else {
                failure(error)
            }
        })
    }

}


