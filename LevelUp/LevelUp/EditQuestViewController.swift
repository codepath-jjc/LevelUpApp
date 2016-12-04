//
//  EditQuestViewController.swift
//  LevelUp
//
//  Created by Joshua Escribano on 12/4/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class EditQuestViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var frequencySegmentControl: UISegmentedControl!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var icon: UIImageView!
    var quest: Quest! {
        didSet {
            view.layoutIfNeeded()
            
            titleTextField.text = quest.title
            descriptionTextView.text = quest.description
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

        icon.layer.cornerRadius = 20
        titleTextField.addDashedBorder()
        descriptionTextView.addDashedBorder()
    }
    
    @IBAction func onCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveTapped(_ sender: Any) {
        // TODO
    }
    

}
