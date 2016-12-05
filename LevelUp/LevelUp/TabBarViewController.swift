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
    
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var tabBarHeightConstraint: NSLayoutConstraint!
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
    
    
    // COSNTRAINTS
    
    // 80 - > 0
    @IBOutlet weak var tabBarBottomConstraint: NSLayoutConstraint!
    
    // 6
    @IBOutlet weak var questBaslineConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityBaslineConstraint: NSLayoutConstraint!
    @IBOutlet weak var milestoneBaslineConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileBaslineConstraint: NSLayoutConstraint!
    // CONSTRAINTS
    
    var profileViewController: ProfileViewController!
    var milestoneViewController: MilestoneViewController!
    var activityTimelineViewController: ActivityTimelineViewController!
    var newQuestViewController: NewQuestViewController!
    var viewControllers = [UIViewController]()
    var originalTabBarHeight: CGFloat!
    var page: Page! {
        willSet {
            unselectAll()
            tabBarHidden = false
            
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
    var tabBarHidden: Bool = false {
        didSet {
            
            if tabBarHidden {
                tabBarHeightConstraint.constant = 0
                tabBarView.isHidden = true
            } else {
                tabBarHeightConstraint.constant = originalTabBarHeight
                tabBarView.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalTabBarHeight = tabBarHeightConstraint.constant
        
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
        }
    }
    
    
    /*
 
     // 80 - > 0
     @IBOutlet weak var tabBarBottomConstraint: NSLayoutConstraint!
     
     // 6
     @IBOutlet weak var questBaslineConstraint: NSLayoutConstraint!
     
     @IBOutlet weak var activityBaslineConstraint: NSLayoutConstraint!
     @IBOutlet weak var milestoneBaslineConstraint: NSLayoutConstraint!
     @IBOutlet weak var profileBaslineConstraint: NSLayoutConstraint!
     
     
    */
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarBottomConstraint.constant = -80
        
        self.questBaslineConstraint.constant = -50
        self.activityBaslineConstraint.constant = -50
        self.milestoneBaslineConstraint.constant = -50
        self.profileBaslineConstraint.constant = -50
        
        
        self.view.layoutIfNeeded()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

        var start = 0.3
        UIView.animate(withDuration: start, delay: 0.0, options: .curveEaseInOut,  animations: {
            
            print("animating tab bar ")
            
            self.tabBarBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            
            self.questBaslineConstraint.constant = -50
            
          
            
            
        })
        
        
        UIView.animate(withDuration: 0.2, delay: start, options: .curveEaseInOut,  animations: {
            self.questBaslineConstraint.constant = 6
            self.questButtonView.alpha = 1
            self.view.layoutIfNeeded()
        })
        // Stack animations a little bit
        start += 0.05
        UIView.animate(withDuration: 0.2, delay: start, options: .curveEaseInOut,  animations: {
            self.activityBaslineConstraint.constant = 6
                    self.view.layoutIfNeeded()
        })
        
        start += 0.05
        UIView.animate(withDuration: 0.2, delay: start, options: .curveEaseInOut,  animations: {
            self.milestoneBaslineConstraint.constant = 6
            self.view.layoutIfNeeded()
        })
        
        start += 0.05
        UIView.animate(withDuration: 0.2, delay: start, options: .curveEaseInOut,  animations: {
            self.profileBaslineConstraint.constant = 6
            self.view.layoutIfNeeded()
        })
        
        
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
