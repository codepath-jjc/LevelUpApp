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
