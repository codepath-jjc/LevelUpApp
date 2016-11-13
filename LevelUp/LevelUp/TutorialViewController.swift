//
//  TutorialViewController.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/11/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var createQuestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createQuestButton.layer.borderWidth = 1.0
        createQuestButton.layer.cornerRadius = 5.0
        createQuestButton.layer.borderColor = UIColor(red:0.38, green:0.90, blue:0.52, alpha:1.0).cgColor
    }

}
