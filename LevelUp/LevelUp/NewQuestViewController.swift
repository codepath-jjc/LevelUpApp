//
//  NewQuestViewController.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/11/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse

class NewQuestViewController: UIViewController  {

    @IBOutlet weak var frequencySegmentControl: UISegmentedControl!
    @IBOutlet weak var dueTimePicker: UIDatePicker!
    @IBOutlet weak var dueTimeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createQuestButton: UIButton!
    @IBOutlet weak var icon: SelectableImageView!
    
    var navigationDelegate: TabBarViewController?
    var originalTimePickerHeight: CGFloat!
    var isExpandedTimePicker = false
    var disabledButtonColor = UIColor(red:0.17, green:0.40, blue:0.23, alpha:1.0)
    var enabledButtonColor = UIColor(red:0.38, green:0.90, blue:0.52, alpha:1.0)
    var frequency = Frequency.daily
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.setNeedsLayout()
        titleTextField.layoutIfNeeded()
        
        descriptionTextView.setNeedsLayout()
        descriptionTextView.layoutIfNeeded()
        
        let dashColor = UIColor(red:0.60, green:0.61, blue:0.61, alpha:1.0)
        titleTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: dashColor])
        titleTextField.delegate = self
        
        descriptionTextView.delegate = self
        
        createQuestButton.layer.borderWidth = 1.0
        createQuestButton.layer.cornerRadius = 5.0
        createQuestButton.layer.borderColor = disabledButtonColor.cgColor
        
        descriptionTextView.addDashedBorder(color: dashColor)
        titleTextField.addDashedBorder(color: dashColor)

        frequencySegmentControl.addTarget(self, action: #selector(frequencyChanged), for: .valueChanged)
        frequencySegmentControl.tintColor = AppColors.PrimaryAccentColor
        
        icon.delegate = self
        
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        dateComponents.hour = 17
        dueTimePicker.setValue(UIColor(red:0.62, green:0.63, blue:0.64, alpha:1.0), forKeyPath: "textColor")
        dueTimePicker.date = calendar.date(from: dateComponents)!
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTimePickerTap))
        tapRecognizer.delegate = self
        dueTimePicker.isUserInteractionEnabled = true
        dueTimePicker.addGestureRecognizer(tapRecognizer)
        
        originalTimePickerHeight = dueTimeHeightConstraint.constant
        
        Events.requestAccess()
        
        if #available(iOS 10.0, *) {
            Notifications.requestAccess()
        }
        
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    func onTimePickerTap() {
        if isExpandedTimePicker {
            dueTimeHeightConstraint.constant = originalTimePickerHeight
            isExpandedTimePicker = false
        } else {
            dueTimeHeightConstraint.constant = 100
            isExpandedTimePicker = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationDelegate?.tabBarHidden = true
    }
    
    func frequencyChanged() {
        if frequencySegmentControl.selectedSegmentIndex == 0 {
            frequency = .daily
        } else {
            frequency = .weekly
        }
    }
    
    @IBAction func onCancelPress(_ sender: Any) {
        if let navigationDelegate = navigationDelegate {
            navigationDelegate.page = Page.profile
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func onCreatePressed(_ sender: Any) {

    
    
        var dictionary = ["frequency": frequency.rawValue, "title": titleTextField.text ?? "", "notes": descriptionTextView.text, "archived": false, "dueTime": dueTimePicker.date] as [String: Any]
        if let chosenImage = icon.image {
            dictionary["image"] = chosenImage
        }
        
        var newQuest = Quest(dictionary: dictionary)
        navigationDelegate?.profileViewController.quests.insert(newQuest, at: 0)
        LevelUpClient.cachedQuests?.insert(newQuest, at: 0)
        
        LevelUpClient.sharedInstance.sync(quest: &newQuest, success: {
            // TODO
            newQuest.createMilestone()
        }, failure: {
            (error: Error?) -> () in
            // TODO
            print(error?.localizedDescription ?? "New Quest Error")
        })
   
        performSegue(withIdentifier: "showTabBar", sender: self)
    }
    

}

extension NewQuestViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let isEmpty = textField.text?.isEmpty ?? false
        if !isEmpty {
            descriptionTextView.becomeFirstResponder()
        }
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let empty = willBeEmpty(textField: textField, replacementString: string)
        if !empty {
            createQuestButton.isEnabled = true
            createQuestButton.layer.borderColor = enabledButtonColor.cgColor
            createQuestButton.titleLabel?.textColor = enabledButtonColor
        } else {
            createQuestButton.isEnabled = false
            createQuestButton.layer.borderColor = disabledButtonColor.cgColor
            createQuestButton.titleLabel?.textColor = disabledButtonColor
        }
        
        return true
    }
    
    private func willBeEmpty(textField: UITextField, replacementString string: String) -> Bool {
        
        if textField.text?.characters.count == 1 && string.isEmpty {
            return true
        }
        
        return false
    }
    
}

extension NewQuestViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}

extension NewQuestViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
