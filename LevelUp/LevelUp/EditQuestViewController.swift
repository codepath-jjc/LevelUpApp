//
//  EditQuestViewController.swift
//  LevelUp
//
//  Created by Joshua Escribano on 12/4/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class EditQuestViewController: UIViewController {
    
    @IBOutlet weak var dueTimeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dueTimePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var frequencySegmentControl: UISegmentedControl!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var icon: SelectableImageView!
    var originalTimePickerHeight: CGFloat!
    var isExpandedTimePicker = false
    var quest: Quest! {
        didSet {
            view.layoutIfNeeded()
            
            titleTextField.text = quest.title
            descriptionTextView.text = quest.notes
            if quest.frequency == Frequency.daily {
                frequencySegmentControl.selectedSegmentIndex = 0
            } else {
                frequencySegmentControl.selectedSegmentIndex = 1
            }
            icon.image = quest.image
            
            if let dueTime = quest.dueTime {
                dueTimePicker.date = dueTime
            } else {
                let calendar = Calendar.current
                var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
                dateComponents.hour = 17
                dueTimePicker.date = calendar.date(from: dateComponents)!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(gestureRecognizer)
        
        titleTextField.addDashedBorder()
        descriptionTextView.addDashedBorder()
        
        titleTextField.delegate = self
        descriptionTextView.delegate = self
        
        icon.delegate = self

        dueTimePicker.setValue(UIColor(red:0.62, green:0.63, blue:0.64, alpha:1.0), forKeyPath: "textColor")
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTimePickerTap))
        tapRecognizer.delegate = self
        dueTimePicker.isUserInteractionEnabled = true
        dueTimePicker.addGestureRecognizer(tapRecognizer)
        
        originalTimePickerHeight = dueTimeHeightConstraint.constant
    }
    
    func onTimePickerTap() {
        if isExpandedTimePicker {
            dueTimeHeightConstraint.constant = originalTimePickerHeight
            isExpandedTimePicker = false
        } else {
            dueTimeHeightConstraint.constant = 100
            isExpandedTimePicker = true
        }
        dueTimePicker.setNeedsUpdateConstraints()
    }
    
    func onTap() {
        titleTextField.endEditing(true)
        descriptionTextView.endEditing(true)
    }
    
    @IBAction func onCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveTapped(_ sender: Any) {
        quest.title = titleTextField.text
        quest.notes = descriptionTextView.text
        quest.image = icon.image
        quest.frequency = Frequency(rawValue: frequencySegmentControl.selectedSegmentIndex)
        quest.dueTime = dueTimePicker.date
        
        var inQuest: Quest = quest
        LevelUpClient.sharedInstance.sync(quest: &inQuest, success: {
            () -> () in
            //
        }, failure: {
            (error: Error?) -> () in
            print(error?.localizedDescription ?? "Error syncing quest")
        })
        
        dismiss(animated: true, completion: nil)
    }

}

extension EditQuestViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let isEmpty = textField.text?.isEmpty ?? false
        if !isEmpty {
            descriptionTextView.becomeFirstResponder()
        }
        
        return false
    }
    
}

extension EditQuestViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}

extension EditQuestViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
