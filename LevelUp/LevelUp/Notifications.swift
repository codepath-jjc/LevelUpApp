//
//  Notifications.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/21/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject {

    @available(iOS 10.0, *)
    class func schedule(title: String, body: String, trigger: UNNotificationTrigger) -> UNNotificationRequest  {

        authorize()
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger) // Schedule the notification.
        center.add(request)
        
        return request
    }
    
    @available(iOS 10.0, *)
    class func authorize() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
        }
    }
}
