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
    @IBOutlet weak var questNameTableView: UITableView!
    
    var hasPlaceholder = true
    var quest:Quest? {
        didSet {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        notesTextView.addDashedBorder()
        
        chooseImageLabel.clipsToBounds = true
        chooseImageLabel.layer.cornerRadius = 5.0
        
        doneButton.layer.borderWidth = 1.0
        doneButton.layer.cornerRadius = 5.0
        doneButton.layer.borderColor = UIColor(red:0.38, green:0.90, blue:0.52, alpha:1.0).cgColor
        
        notesTextView.delegate = self
    }
    
    @IBAction func onChooseImage(_ sender: UITapGestureRecognizer) {
    }

    
    @IBAction func onDone(_ sender: Any) {
        // TODO create milestone
        navigationDelegate?.page = Page.profile
    }
    
    @IBAction func onCancel(_ sender: Any) {
        navigationDelegate?.page = Page.profile
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
