//
//  PetViewController.swift
//  LevelUp
//
//  Created by jason on 12/8/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

import SpriteKit


class PetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let skView = SKView(frame: self.view.frame)
        let scene = GameScene(size: view.bounds.size)
        skView.presentScene(scene)
        view.addSubview(skView)
        
        
        
        // Do any additional setup after loading the view.
    }

  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override var prefersStatusBarHidden : Bool {
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
