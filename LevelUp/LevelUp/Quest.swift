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
    
    static let className = "QuestTest10"
    var pfObject: PFObject?
    var imageFile: PFFile?
    var title: String? {
        didSet {
            dictionary["title"] = title
        }
    }
    var image: UIImage? {
        didSet {
            dictionary["image"] = image
        }
    }
    var frequency: Frequency? {
        didSet {
            dictionary["frequency"] = frequency?.rawValue
        }
    }
    var notes: String? {
        didSet {
            dictionary["notes"] = notes
        }
    }
    var archived: Bool! {
        didSet {
            dictionary["archived"] = archived
        }
    }
    // Time of Day to Set Reminders
    var dueTime: Date? {
        didSet {
            dictionary["dueTime"] = dueTime
        }
    }
    var dictionary = [String: Any]()
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
        
        title = pfObject.object(forKey: "title") as? String
        
        if let imageFile =  pfObject.object(forKey: "image") as? PFFile {
            self.imageFile = imageFile
        }
        
        let frequencyInt = pfObject.object(forKey: "frequency") as? Int
        if let frequencyInt = frequencyInt {
            frequency = Frequency(rawValue: frequencyInt)
        }
        
        notes = pfObject.object(forKey: "notes") as? String
        archived = pfObject.object(forKey: "archived") as? Bool ?? false
        dueTime = pfObject.object(forKey: "dueTime") as? Date

        // Update dictionary since DidSet will not be called in initalizer
        dictionary["title"] = title
        dictionary["image"] = image
        dictionary["frequency"] = frequency
        dictionary["notes"] = notes
        dictionary["archived"] = archived
        dictionary["dueTime"] = dueTime
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
        dueTime = dictionary["dueTime"] as? Date
    }
    
    // Returns the upcoming milestone for this quest
    func upcomingMilestone(success: @escaping (Milestone) -> (), failure: @escaping (Error?) -> ()) {
        LevelUpClient.sharedInstance.milestones(success: {
            (milestones: [Milestone]) -> () in
            var upcomingMilestone: Milestone?
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
    
    func createMilestone() {
        
        let date = Date(timeIntervalSinceNow: 0)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let milestoneTitle = "\(title ?? "") - \(formatter.string(from: date))"
        var milestone = Milestone(dictionary: ["title": milestoneTitle, "completed": false, "questId": pfObject?.objectId ?? ""])
        
        var alertNotes = notes ?? ""
        if alertNotes.isEmpty {
            alertNotes = "Try working on \(title ?? "") today :)"
        }
        
        let calendar = Calendar.current
        let dateToUse = dueTime ?? Date()
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dateToUse)

        if frequency == .daily {
            if #available(iOS 10.0, *) {
                dateComponents.day = dateComponents.day! + 1
                milestone.deadline = calendar.date(from: dateComponents)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                _ = Notifications.schedule(title: milestoneTitle, body: alertNotes, trigger: trigger, identifier: pfObject?.objectId ?? "")
            }
        } else {
            if #available(iOS 10.0, *) {
                dateComponents.day = dateComponents.day! + 7
                milestone.deadline = calendar.date(from: dateComponents)

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                _ = Notifications.schedule(title: milestoneTitle, body: alertNotes, trigger: trigger, identifier: pfObject?.objectId ?? "")
            }
        }
        
        LevelUpClient.sharedInstance.sync(milestone: &milestone, success: {
            
        }, failure: {
            (error: Error?) -> () in
            print(error?.localizedDescription ?? "Error syncing milestone")
        })
    }
    
}

