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
    class func schedule(title: String, body: String, trigger: UNNotificationTrigger, identifier: String = "") -> UNNotificationRequest  {

        requestAccess()
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger) // Schedule the notification.
        center.add(request)
        
        return request
    }
    
    @available(iOS 10.0, *)
    class func removePendingRequests(withIdentifiers: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: withIdentifiers)
    }
    
    @available(iOS 10.0, *)
    class func requestAccess() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
        }
    }
}
