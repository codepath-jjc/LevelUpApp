//
//  MilestoneViewController.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/12/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import UserNotifications

class MilestoneViewController: UIViewController {
    var navigationDelegate: TabBarViewController?

    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pointsHolder: UIView!
    
    // points crap
    
    var lastPosition:CGFloat = 15
    
    var snapBehaviour:UISnapBehavior!
    var animator:UIDynamicAnimator!
    
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var icon: SelectableImageView!
    @IBOutlet weak var questNameTableView: UITableView!
    var originalTableViewHeight: CGFloat!
    var isExpanded = false
    var hasPlaceholder = true
    var quests = [Quest]()
    var filteredQuests = [Quest]()
    var milestone: Milestone? {
        didSet {
            view.layoutIfNeeded()
            
            if let notes = milestone?.notes {
                if !notes.isEmpty {
                    notesTextView.text = milestone?.notes
                }
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            if let deadline = milestone?.deadline {
                dueDateLabel.text = formatter.string(from: deadline)
            }
        }
    }
    var quest: Quest? {
        didSet {
            guard quest != nil else { return }
            
            view.layoutIfNeeded()
            
            if let image = quest?.image {
                icon.image = image
            }

            if let milestone = quest?.milestone {
                self.milestone = milestone
            } else {
                let _ = quest!.upcomingMilestone(success: {
                    (upcomingMilestone: Milestone) -> () in
                    self.milestone = upcomingMilestone
                }, failure: {
                    (error: Error?) -> () in
                    print(error?.localizedDescription ?? "Error getting upcoming milestone")
                })
            }
            
            frequencyLabel.text = quest!.frequency?.simpleDescription()
            
            if !quests.contains(quest!) {
                quests.append(quest!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if quest == nil {
            LevelUpClient.sharedInstance.quests(success: {
                (quests: [Quest]) -> () in
                self.quests = quests.filter({ (quest: Quest) -> Bool in
                    quest.archived == false
                })
                self.quest = self.quests.first
                self.filteredQuests = self.quests
                self.questNameTableView.reloadData()
            }, failure: {
                (error: Error?) -> () in
                // TODO
            })
        } else {
            self.filteredQuests = [quest!]
        }
        questNameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuestNameCell")

        notesTextView.addDashedBorder()
        
        doneButton.layer.borderWidth = 1.0
        doneButton.layer.cornerRadius = 5.0
        doneButton.layer.borderColor = UIColor(red:0.38, green:0.90, blue:0.52, alpha:1.0).cgColor
        
        notesTextView.delegate = self
        questNameTableView.dataSource = self
        questNameTableView.delegate = self
        questNameTableView.separatorColor = UIColor(red:0.38, green:0.90, blue:0.52, alpha:1.0)
        questNameTableView.tableFooterView = UIView(frame: .zero)
        
        icon.delegate = self
        
        originalTableViewHeight = tableViewHeightConstraint.constant
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pointsHolder.isHidden = true
        pointsLabel.textColor = AppColors.PrimaryAccentColor
        navigationDelegate?.tabBarHidden = true
    }

    @IBAction func onDone(_ sender: Any) {
        milestone?.completed = true
        
        if let image = icon.image {
            milestone?.image = image
        }
        quest?.createMilestone()
        
        if var milestone = milestone {
            if #available(iOS 10.0, *) {
                Notifications.removePendingRequests(withIdentifiers: [quest?.pfObject?.objectId ?? ""])
                milestone.completedDate = Date()
            }
            LevelUpClient.sharedInstance.sync(milestone: &milestone, success: {
                () -> () in
                // TODO
            }, failure: {
                (error: Error?) -> () in
                // TODO
                print(error?.localizedDescription ?? "Error syncing milestone on Done action")
            })
        }

        pointsHolder.backgroundColor = AppColors.DarkGreen
        pointsHolder.alpha = 0.0
        pointsHolder.isHidden = false
        
        pointsHolder.setNeedsLayout()
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut,  animations: {
            self.pointsHolder.alpha = 1
        })
        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: .curveEaseOut,  animations: {
            self.pointsHolder.backgroundColor = UIColor(white: 0, alpha: 0.95)
        })
        
        let points = LevelUpClient.sharedInstance.getPoints() + 24
        LevelUpClient.sharedInstance.addPoints(points: 24)
        print(points)
        
        pointsLabel.text = "Power Level: \(points)"
        
        // Aniamte points in
        self.pointsLabel.setNeedsLayout()
        
        if lastPosition ==  15  {
            lastPosition = 30
        } else {
            lastPosition = 15
        }
        
        animator = UIDynamicAnimator(referenceView: self.view)
        snapBehaviour = UISnapBehavior(item: pointsLabel, snapTo: CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2 - lastPosition))
        snapBehaviour.action = {
            //self.pointsLabel.setNeedsLayout()
        }
        snapBehaviour.damping = 0.15
        animator.addBehavior(snapBehaviour)

        UIView.animate(withDuration: 0.3, delay: 0.13, options: .curveEaseOut,  animations: {
            self.pointsHolder.alpha = 1
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            //text.textColor = AppColors.PrimaryAccentColor
            if let navDelegate = self.navigationDelegate {
                navDelegate.page = Page.profile
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        if let navDelegate = navigationDelegate {
            navDelegate.page = Page.profile
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

}

extension MilestoneViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isExpanded {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.tableViewHeightConstraint.constant = self.originalTableViewHeight
            }, completion: nil)
            isExpanded = false
            
            quest = quests[indexPath.row]
            filteredQuests = [quest!]
        } else {
            tableViewHeightConstraint.constant = 100
            isExpanded = true
            filteredQuests = quests
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}

extension MilestoneViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestNameCell", for: indexPath)
        cell.backgroundColor = UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0)
        cell.textLabel?.textColor = UIColor(red:0.73, green:0.73, blue:0.73, alpha:1.0)
        var caret = ""
        if !isExpanded {
            caret = " ⌄"
        }
        cell.textLabel?.text = filteredQuests[indexPath.row].title! + caret
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredQuests.count
    }
}

extension MilestoneViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if hasPlaceholder {
            textView.text = ""
            hasPlaceholder = false
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
}
