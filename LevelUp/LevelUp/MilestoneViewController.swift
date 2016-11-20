//
//  MilestoneViewController.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/12/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class MilestoneViewController: UIViewController {
    var navigationDelegate: TabBarViewController?

    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var chooseImageLabel: UILabel!
    @IBOutlet weak var questNameLabel: UILabel!
    var quest:Quest? {
        didSet {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        notesTextView.addDashedBorder()
        
        doneButton.layer.borderWidth = 1.0
        doneButton.layer.cornerRadius = 5.0
        doneButton.layer.borderColor = UIColor(red:0.38, green:0.90, blue:0.52, alpha:1.0).cgColor
    }
    
    @IBAction func onDone(_ sender: Any) {
        // TODO create milestone
        navigationDelegate?.page = Page.profile
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        navigationDelegate?.page = Page.profile
    }
    

}
