//
//  TutorialViewController.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/11/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var yConstraint: NSLayoutConstraint!
    @IBOutlet weak var xConstraint: NSLayoutConstraint!
    @IBOutlet weak var createQuestButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var createQuestBtn: UIButton!
    var snapBehaviour:UISnapBehavior!
    var animator:UIDynamicAnimator!

    @IBOutlet weak var createQuestbottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createQuestButton.layer.borderWidth = 1.0
        createQuestButton.layer.cornerRadius = 5.0
        createQuestButton.layer.borderColor = UIColor(red:0.38, green:0.90, blue:0.52, alpha:1.0).cgColor
                        
        
        animator = UIDynamicAnimator(referenceView: self.view)
        print(xConstraint.constant)
        descLabel.layoutIfNeeded()
        descLabel.setNeedsLayout()
        
        
        snapBehaviour = UISnapBehavior(item: descLabel, snapTo: CGPoint(x: xConstraint.constant, y: yConstraint.constant))
        
        
        snapBehaviour = UISnapBehavior(item: descLabel, snapTo: CGPoint(x: descLabel.bounds.maxX, y: descLabel.bounds.maxY))
        
    //snapBehaviour = UISnapBehavior(item: descLabel, snapTo:        descLabel.bounds.origin)
        
        
        print(xConstraint.constant)

        snapBehaviour.damping = 0.3
        animator.addBehavior(snapBehaviour)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("prep")
        
        self.createQuestbottomConstraint.constant = -30
        self.view.layoutIfNeeded()
        
        
        //        topConstraint.constant = 0
        UIView.animate(withDuration: Double(2.5), animations: {
            // self.createQuestBottomConstraint.constant = 35
            //self.createQuestBottomConstraint.
            print("animating")
            
            self.createQuestbottomConstraint.constant = 35
            
            self.view.layoutIfNeeded()
        })
        
        
    }
    

}
