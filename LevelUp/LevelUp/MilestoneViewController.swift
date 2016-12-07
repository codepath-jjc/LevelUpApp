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

    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var icon: SelectableImageView!
    @IBOutlet weak var questNameTableView: UITableView!
    var hasPlaceholder = true
    var quests = [Quest]()
    var milestone: Milestone? {
        didSet {
            view.layoutIfNeeded()
            
            if let image = milestone?.image {
                icon.image = image
            }
            if let notes = milestone?.notes {
                if !notes.isEmpty {
                    notesTextView.text = milestone?.notes
                }
            }
        }
    }
    var quest: Quest? {
        didSet {
            guard quest != nil else { return }
            
            view.layoutIfNeeded()

            let _ = quest!.upcomingMilestone(success: {
                (upcomingMilestone: Milestone) -> () in
                self.milestone = upcomingMilestone
            }, failure: {
                (error: Error?) -> () in
                print(error?.localizedDescription ?? "Error getting upcoming milestone")
            })
            
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
                self.questNameTableView.reloadData()
            }, failure: {
                (error: Error?) -> () in
                // TODO
            })
        }
        questNameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuestNameCell")

        notesTextView.addDashedBorder()
        
        doneButton.layer.borderWidth = 1.0
        doneButton.layer.cornerRadius = 5.0
        doneButton.layer.borderColor = UIColor(red:0.38, green:0.90, blue:0.52, alpha:1.0).cgColor
        
        notesTextView.delegate = self
        questNameTableView.dataSource = self
        questNameTableView.delegate = self
        
        icon.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

        navigationDelegate?.page = Page.profile
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
        quest = quests[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MilestoneViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestNameCell", for: indexPath)
        cell.backgroundColor = UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0)
        cell.textLabel?.textColor = UIColor(red:0.73, green:0.73, blue:0.73, alpha:1.0)
        cell.textLabel?.text = quests[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.count
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
