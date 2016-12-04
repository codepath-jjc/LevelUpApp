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
    var quest: Quest!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelTapped(_ sender: Any) {
    }
    
    @IBAction func onSaveTapped(_ sender: Any) {
    }
    

}
