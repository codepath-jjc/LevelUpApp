//
//  TabBarViewController.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/12/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

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
    var profileViewController: ProfileViewController!
    var milestoneViewController: MilestoneViewController!
    var activityTimelineViewController: ActivityTimelineViewController!
    var newQuestViewController: NewQuestViewController!
    var viewControllers = [UIViewController]()
    var page: Page! {
        willSet {
            if page != nil {
                contentView.subviews.first?.removeFromSuperview()
                childViewControllers.first?.removeFromParentViewController()
            }
            
            let vc = viewControllers[newValue.rawValue]
            addChildViewController(vc)
            contentView.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        viewControllers.append(profileViewController)

        milestoneViewController = storyboard.instantiateViewController(withIdentifier: "MilestoneViewController") as! MilestoneViewController
        viewControllers.append(milestoneViewController)
        
        activityTimelineViewController = storyboard.instantiateViewController(withIdentifier: "ActivityTimelineViewController") as! ActivityTimelineViewController
        viewControllers.append(activityTimelineViewController)
        
        newQuestViewController = storyboard.instantiateViewController(withIdentifier: "NewQuestViewController") as! NewQuestViewController
        viewControllers.append(newQuestViewController)

        page = Page.profile
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
