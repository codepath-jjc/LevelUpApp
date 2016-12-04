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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveTapped(_ sender: Any) {
        // TODO
    }
    

}
