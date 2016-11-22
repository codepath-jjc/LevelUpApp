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
    @IBOutlet weak var chooseImageLabel: UILabel!
    @IBOutlet weak var questNameTableView: UITableView!
    var imageView = UIImageView()
    var hasPlaceholder = true
    var quests = [Quest]()
    var quest:Quest? {
        didSet {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        LevelUpClient.sharedInstance.quests(success: {
            (quests: [Quest]) -> () in
            self.quests = quests
            self.questNameTableView.reloadData()
        }, failure: {
            (error: Error?) -> () in
            // TODO
        })
        questNameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuestNameCell")

        notesTextView.addDashedBorder()
        
        chooseImageLabel.clipsToBounds = true
        chooseImageLabel.layer.cornerRadius = 5.0
        
        doneButton.layer.borderWidth = 1.0
        doneButton.layer.cornerRadius = 5.0
        doneButton.layer.borderColor = UIColor(red:0.38, green:0.90, blue:0.52, alpha:1.0).cgColor
        
        notesTextView.delegate = self
        questNameTableView.dataSource = self
        questNameTableView.delegate = self
     
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = navigationDelegate
            
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization
                let content = UNMutableNotificationContent()
                content.title = "hello!"
                content.body = "message body"
                content.sound = UNNotificationSound.default() // Deliver the notification in five seconds.
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger) // Schedule the notification.
                center.add(request)
            }
            
            let content = UNMutableNotificationContent()
            content.title = "hello!"
            content.body = "message body"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
            let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger) // Schedule the notification.
            center.add(request)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func onChooseImage(_ sender: UITapGestureRecognizer) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        imagePickerVC.sourceType = .photoLibrary
        
        present(imagePickerVC, animated: true, completion: nil)
    }

    
    @IBAction func onDone(_ sender: Any) {
        let milestone = quest?.upcomingMilestone()
        milestone?.completed = true
        
        if var milestone = milestone {
            LevelUpClient.sharedInstance.sync(milestone: &milestone, success: {
                () -> () in
                // TODO
            }, failure: {
                (error: Error?) -> () in
                // TODO
            })
        }

        navigationDelegate?.page = Page.profile
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        navigationDelegate?.page = Page.profile
    }

}

extension MilestoneViewController: UINavigationControllerDelegate {
    
}

extension MilestoneViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // TODO
        imageView.frame = chooseImageLabel.frame
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = info[UIImagePickerControllerEditedImage] as! UIImage
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        imageView.image = thumbnail
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5.0
        chooseImageLabel.isHidden = true
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(onChooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        view.addSubview(imageView)
        
        dismiss(animated: true, completion: nil)
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
        // Remove placeholder
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // Reinsert placeholder
        if textView.text.isEmpty && !hasPlaceholder {
            textView.text = "Notes"
            hasPlaceholder = true
        }
    }
}
