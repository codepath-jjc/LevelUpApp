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
        
        unselectAll()
        if tabButton == profileButtonView {
            page = Page.profile
            setSelected(image: profileImage, text: profileLabel)
        } else if tabButton == milestoneButtonView {
            page = Page.milestone
            setSelected(image: milestoneImage, text: milestoneLabel)
        } else if tabButton == activityTimelineButtonView {
            page = Page.activityTimeline
            setSelected(image: activityImage, text: activityLabel)
        } else if tabButton == questButtonView {
            page = Page.quest
            setSelected(image: questImage, text: questLabel)
        }
        
    }
    
    
}
