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
import EventKit

class Quest: NSObject {
    
    static let className = "QuestTest13"
    static let images = [UIImage(named: "0000"), UIImage(named: "0001"), UIImage(named: "0002"), UIImage(named: "0003") , UIImage(named: "0004"), UIImage(named: "0006"), UIImage(named: "0007"), UIImage(named: "0008")]
    var pfObject: PFObject?
    var imageFile: PFFile?
    var milestone: Milestone?
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
    

    var imageFallback: Int? {
        didSet {
            dictionary["imageFallback"] = imageFallback
        }
    }
    
    
    
    var dictionary = [String: Any]()
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
        
        title = pfObject.object(forKey: "title") as? String
        
        if let imageFile =  pfObject.object(forKey: "image") as? PFFile {
            self.imageFile = imageFile
        } else {
            
        }
        
        let frequencyInt = pfObject.object(forKey: "frequency") as? Int
        if let frequencyInt = frequencyInt {
            frequency = Frequency(rawValue: frequencyInt)
        }
        
        notes = pfObject.object(forKey: "notes") as? String
        archived = pfObject.object(forKey: "archived") as? Bool ?? false
        dueTime = pfObject.object(forKey: "dueTime") as? Date
        imageFallback = pfObject.object(forKey: "imageFallback") as? Int
        
        
        // Update dictionary since DidSet will not be called in initalizer
        dictionary["imageFallback"] = imageFallback
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
        imageFallback = Int(arc4random_uniform(7) )
        self.dictionary["imageFallback"] = imageFallback
        archived = (dictionary["archived"] as? Bool) ?? false
        dueTime = dictionary["dueTime"] as? Date
        milestone = dictionary["milestone"] as? Milestone
        self.dictionary.removeValue(forKey: "milestone")
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
        formatter.dateFormat = "M.d.YY"
        var milestoneTitle = "\(title ?? "") - "
        var milestone = Milestone(dictionary: ["title": milestoneTitle, "completed": false, "questId": pfObject?.objectId ?? "", "quest": self])
        
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
                milestoneTitle += "\(formatter.string(from: milestone.deadline!))"
                milestone.title = milestoneTitle
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                _ = Notifications.schedule(title: milestoneTitle, body: alertNotes, trigger: trigger, identifier: pfObject?.objectId ?? "")
            }
        } else {
            if #available(iOS 10.0, *) {
                dateComponents.day = dateComponents.day! + 7
                milestone.deadline = calendar.date(from: dateComponents)
                milestoneTitle += "\(formatter.string(from: milestone.deadline!))"
                milestone.title = milestoneTitle

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                _ = Notifications.schedule(title: milestoneTitle, body: alertNotes, trigger: trigger, identifier: pfObject?.objectId ?? "")
            }
        }
        
        Events.save(title: milestoneTitle, date: milestone.deadline!)

        
        LevelUpClient.sharedInstance.sync(milestone: &milestone, success: {
            
        }, failure: {
            (error: Error?) -> () in
            print(error?.localizedDescription ?? "Error syncing milestone")
        })
    }
    
}

