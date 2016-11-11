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
        // TODO grab quests from parse or local storage
        
        var quests = [Quest]()
        
        let quest1 = [
            "title": "Writting",
            "image": "url"
        ]
        
        let quest2 = [
            "title": "Music",
            "image": "url"
        ]
        
        quests.append(Quest(quest1 as NSDictionary) )
        quests.append(Quest(quest2 as NSDictionary) )

        success(quests)
    }
    
    func milestones(_ success: @escaping ([Milestone]) -> (), failure: @escaping (Error) -> ()) {
        // TODO grab milestones from parse or local storage

    }
    
    func saveQuest(_ quest: Quest, success: @escaping (Quest) -> (), failure: @escaping (Error?) -> ()) {
        let pfQuest = PFObject(className: "Quest")
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
