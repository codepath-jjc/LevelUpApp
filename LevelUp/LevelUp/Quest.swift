//
//  Quest.swift
//  LevelUp
//
//  Created by jason on 11/9/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

class Quest: NSObject {
    
    static let className = "QuestTest8"
    var pfObject: PFObject?
    var title: String?
    var image: UIImage?
    var imageFile: PFFile?
    var frequency: Frequency?
    var notes: String?
    var archived: Bool! {
        didSet {
            dictionary["archived"] = archived
        }
    }
    var dictionary = [String: Any]()
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
        
        title = pfObject.object(forKey: "title") as? String
        
        dictionary = [String: Any]()
        if let title = title {
            dictionary["title"] = title
        }
        
        if let imageFile =  pfObject.object(forKey: "image") as? PFFile {
            self.imageFile = imageFile
        }
        
        let frequencyInt = pfObject.object(forKey: "frequency") as? Int
        if let frequencyInt = frequencyInt {
            dictionary["frequency"] = Frequency(rawValue: frequencyInt)
        }
        
        notes = pfObject.object(forKey: "notes") as? String
        if let notes = notes {
            dictionary["notes"] = notes
        }
        
        archived = pfObject.object(forKey: "archived") as? Bool ?? false
    }
    
    init(dictionary: [String: Any]) {
        
        self.dictionary = dictionary
        if let user =  LevelUpClient.sharedInstance.user() {
            self.dictionary["user"] = user
        }
        
        let frequencyInt = dictionary["frequency"] as? Int
        if let frequencyInt = frequencyInt {
            frequency = Frequency(rawValue: frequencyInt)
        }
        
        title = dictionary["title"] as? String
        notes = dictionary["notes"] as? String
        image = dictionary["image"] as? UIImage
        archived = (dictionary["archived"] as? Bool) ?? false
    }
    
    // Returns the upcoming milestone for this quest
    func upcomingMilestone(success: @escaping (Milestone) -> (), failure: @escaping (Error?) -> ()) {
        LevelUpClient.sharedInstance.milestones(success: {
            (milestones: [Milestone]) -> () in
            var upcomingMilestone: Milestone?
            // TODO Refactor
            for milestone in milestones {
                if milestone.questId == self.pfObject?.objectId {
                    if upcomingMilestone != nil  && milestone.deadline != nil {
                        let comparison = upcomingMilestone!.deadline?.compare(milestone.deadline!)
                        if comparison == ComparisonResult.orderedDescending {
                            upcomingMilestone = milestone
                        }
                    }
                    upcomingMilestone = milestone
                }
            }
            if let upcomingMilestone = upcomingMilestone {
                success(upcomingMilestone)
            }
        }, failure: {
            (error: Error?) -> () in
            failure(error)
            print(error?.localizedDescription ?? "Error loading upcoming milestones")
        })
    }
    
    func createMilestones(frequency: Frequency) {
        let date = Date(timeIntervalSinceNow: 0)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let milestoneTitle = "\(title ?? "") - \(formatter.string(from: date))"
        var milestone = Milestone(dictionary: ["title": milestoneTitle, "completed": false])
        if frequency == .daily {
            if #available(iOS 10.0, *) {                
                // Just an example of how to use notifications
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = Notifications.schedule(title: milestoneTitle, body: notes ?? "Practice!!", trigger: trigger)
                // You can bookmark the request if you need it again maybe?
            }
        } else {
            if #available(iOS 10.0, *) {
                // Just an example of how to use notifications
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = Notifications.schedule(title: milestoneTitle, body: notes ?? "Practice!", trigger: trigger)
                // You can bookmark the request if you need it again maybe?
            }
        }
        
        LevelUpClient.sharedInstance.sync(milestone: &milestone, success: {
            
        }, failure: {
            (error: Error?) -> () in
            print(error?.localizedDescription ?? "Error syncing milestone")
        })
    }
    
}

