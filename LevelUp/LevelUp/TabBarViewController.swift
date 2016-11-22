//
//  TabBarViewController.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/12/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import UserNotifications

enum Page: Int {
    case profile, milestone, activityTimeline, quest
    
    func simpleDescription() -> String {
        switch self {
        case .profile:
            return "Profile"
        case .quest:
            return "Quest"
        case .milestone:
            return "Milestone"
        case .activityTimeline:
            return "Activity Timeline"
        }
    }
}

class TabBarViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileButtonView: UIView!
    @IBOutlet weak var questButtonView: UIView!
    @IBOutlet weak var milestoneButtonView: UIView!
    @IBOutlet weak var activityTimelineButtonView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var milestoneImage: UIImageView!
    @IBOutlet weak var milestoneLabel: UILabel!
    
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var questImage: UIImageView!
    @IBOutlet weak var questLabel: UILabel!
    
    var profileViewController: ProfileViewController!
    var milestoneViewController: MilestoneViewController!
    var activityTimelineViewController: ActivityTimelineViewController!
    var newQuestViewController: NewQuestViewController!
    var viewControllers = [UIViewController]()
    var page: Page! {
        willSet {
            unselectAll()
            
            switch newValue.rawValue {
            case Page.profile.rawValue:
                setSelected(image: profileImage, text: profileLabel)
            case Page.milestone.rawValue:
                setSelected(image: milestoneImage, text: milestoneLabel)
            case Page.activityTimeline.rawValue:
                setSelected(image: activityImage, text: activityLabel)
            case Page.quest.rawValue:
                setSelected(image: questImage, text: questLabel)
            default:
                break
            }
            
            if page != nil {
                contentView.subviews.first?.removeFromSuperview()
                childViewControllers.first?.removeFromParentViewController()
            }
            
            let vc = viewControllers[newValue.rawValue]
            addChildViewController(vc)
            vc.view.frame = contentView.frame
            contentView.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileViewController.navigationDelegate = self
        viewControllers.append(profileViewController)

        milestoneViewController = storyboard.instantiateViewController(withIdentifier: "MilestoneViewController") as! MilestoneViewController
        milestoneViewController.navigationDelegate = self
        viewControllers.append(milestoneViewController)
        
        activityTimelineViewController = storyboard.instantiateViewController(withIdentifier: "ActivityTimelineViewController") as! ActivityTimelineViewController
        activityTimelineViewController.navigationDelegate = self
        viewControllers.append(activityTimelineViewController)
        
        newQuestViewController = storyboard.instantiateViewController(withIdentifier: "NewQuestViewController") as! NewQuestViewController
        newQuestViewController.navigationDelegate = self
        viewControllers.append(newQuestViewController)

        page = Page.profile
        setSelected(image: profileImage, text: profileLabel)
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            // Just an example of how to use notifications
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = Notifications.schedule(title: "Running Time!", body: "Yo you should be running and stuff", trigger: trigger)
            // You can bookmark the request if you need it again maybe?
        } else {
            // Fallback on earlier versions
        }
    }

    
    func unselect(image: UIImageView, text: UILabel){
        colorImage(image: image, color: AppColors.SecondaryTextColor)
        text.textColor = AppColors.SecondaryTextColor
    }
    
    func setSelected(image: UIImageView, text: UILabel){
        colorImage(image: image, color: AppColors.PrimaryAccentColor)
        text.textColor = AppColors.PrimaryAccentColor
    }
    
    func unselectAll(){
        unselect(image: profileImage, text: profileLabel)
        unselect(image: milestoneImage, text: milestoneLabel)
        unselect(image: activityImage, text: activityLabel)
        unselect(image: questImage, text: questLabel)
    }
    
    func colorImage(image: UIImageView, color:UIColor)  {
        image.image = image.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        image.tintColor = color
    }
    
    @IBAction func onChangeTab(_ sender: UITapGestureRecognizer) {
        let tabButton = sender.view
        
        if tabButton == profileButtonView {
            page = Page.profile
        } else if tabButton == milestoneButtonView {
            page = Page.milestone
        } else if tabButton == activityTimelineButtonView {
            page = Page.activityTimeline
        } else if tabButton == questButtonView {
            page = Page.quest
        }
        
    }
    
    
}

extension TabBarViewController: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
    }
}
