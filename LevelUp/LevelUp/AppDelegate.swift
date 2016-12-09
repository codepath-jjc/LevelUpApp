//
//  AppDelegate.swift
//  LevelUp
//
//  Created by jason on 11/9/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        
        // Setup the config
        let config = ParseClientConfiguration(block: {
            (configuration: ParseMutableClientConfiguration) -> Void in
                configuration.server = "https://levelup-parse.herokuapp.com/"
                configuration.applicationId = "LEVELUP"
        })
        
        // Start parse
        Parse.initialize(with: config)
        
        // Enable auto user!
        PFUser.enableAutomaticUser()
        
      
        
        // Maybe we should use this?
        if let uid = UIDevice.current.identifierForVendor?.uuidString {
            print(uid)
        }
        
        
        // comment  tout these last few lines to show tutorial always
        /*
        if UserDefaults.standard.bool(forKey: "HasLaunched") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
            
            window?.rootViewController = tabBarVC
        } else {
            UserDefaults.standard.setValue(true, forKey: "HasLaunched")
        }
    
        */
        
        // Preload data for demo
        var q1 = Quest(dictionary: ["title": "Music", "notes": "Practice scales and chords"])
        var q2 = Quest(dictionary: ["title": "Writing", "notes": "Write a long paragraph"])
        var q3 = Quest(dictionary: ["title": "Birdwatching", "notes": "Spot some birds at golden gate"])
        var q4 = Quest(dictionary: ["title": "Painting", "notes": "Try oil painting"])
        var q5 = Quest(dictionary: ["title": "Skateboarding", "notes": "Go to Soma West skatepark"])
        var q6 = Quest(dictionary: ["title": "Running", "notes": "Run a 5k"])
        LevelUpClient.sharedInstance.sync(quest: &q1, success: {
            
            var dateString = "2016-12-06" // change to your date format
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var date = dateFormatter.date(from: dateString)
            
            var milestone = Milestone(dictionary: ["title": q1.title!, "questId": "\(q1.pfObject?.objectId!)", "quest": q1, "completed": true, "deadline": date])
            LevelUpClient.sharedInstance.sync(milestone: &milestone, success: {
            }, failure: {
                (error: Error?) -> () in
                //
            })
        }, failure: {
            (error: Error?) -> () in
        })
        LevelUpClient.sharedInstance.sync(quest: &q2, success: {
            var dateString = "2016-12-02" // change to your date format
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var date = dateFormatter.date(from: dateString)
            var milestone = Milestone(dictionary: ["title": q2.title!, "questId": "\(q2.pfObject?.objectId!)", "quest": q2, "completed": true, "deadline": date])
            LevelUpClient.sharedInstance.sync(milestone: &milestone, success: {
            }, failure: {
                (error: Error?) -> () in
                //
            })
        }, failure: {
            (error: Error?) -> () in
        })
        LevelUpClient.sharedInstance.sync(quest: &q3, success: {
            var dateString = "2016-12-03" // change to your date format
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var date = dateFormatter.date(from: dateString)
            var milestone = Milestone(dictionary: ["title": q3.title!, "questId": "\(q3.pfObject?.objectId!)", "quest": q3, "completed": true, "deadline": date])
            LevelUpClient.sharedInstance.sync(milestone: &milestone, success: {
            }, failure: {
                (error: Error?) -> () in
                //
            })
        }, failure: {
            (error: Error?) -> () in
        })
        LevelUpClient.sharedInstance.sync(quest: &q4, success: {
            var dateString = "2016-12-01" // change to your date format
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var date = dateFormatter.date(from: dateString)
            var milestone = Milestone(dictionary: ["title": q4.title!, "questId": "\(q4.pfObject?.objectId!)", "quest": q4, "completed": true, "deadline": date])
            LevelUpClient.sharedInstance.sync(milestone: &milestone, success: {
            }, failure: {
                (error: Error?) -> () in
                //
            })
        }, failure: {
            (error: Error?) -> () in
        })
        LevelUpClient.sharedInstance.sync(quest: &q5, success: {
            var dateString = "2016-12-05" // change to your date format
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var date = dateFormatter.date(from: dateString)
            var milestone = Milestone(dictionary: ["title": q5.title!, "questId": "\(q5.pfObject?.objectId!)", "quest": q5, "completed": true, "deadline": date])
            LevelUpClient.sharedInstance.sync(milestone: &milestone, success: {
            }, failure: {
                (error: Error?) -> () in
                //
            })
        }, failure: {
            (error: Error?) -> () in
        })
        LevelUpClient.sharedInstance.sync(quest: &q6, success: {
            var dateString = "2016-11-29" // change to your date format
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var date = dateFormatter.date(from: dateString)
            var milestone = Milestone(dictionary: ["title": q6.title!, "questId": "\(q6.pfObject?.objectId!)", "quest": q6, "completed": true, "deadline": Date()])
            LevelUpClient.sharedInstance.sync(milestone: &milestone, success: {
            }, failure: {
                (error: Error?) -> () in
                //
            })
        }, failure: {
            (error: Error?) -> () in
        })
        
        
        LevelUpClient.sharedInstance.quests(success: {
            (quests: [Quest]) -> () in
            //
        }, failure: {
            (error: Error?) -> () in
            //
        })
        
        LevelUpClient.sharedInstance.milestones(success: {
            (milestones: [Milestone]) -> () in
            //
        }, failure: {
            (error: Error?) -> () in
            //
        })
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

