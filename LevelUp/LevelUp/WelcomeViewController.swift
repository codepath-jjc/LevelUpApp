//
//  WelcomeViewController.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/11/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class WelcomeViewController: UIViewController {

    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
       // NSURL(f)
        
        let url = URL(string: Bundle.main.path(forResource: "intro2", ofType: "mp4")!)
        //let fileURL = NSURL(string: "/Users/jasonbautista/playground/LevelUpApp/LevelUp/LevelUp/intro2.mp4")
        
        
        
        
            let player = AVPlayer(url: url! )
            let playerController = AVPlayerViewController()
            
            playerController.player = player
            self.addChildViewController(playerController)
            self.view.addSubview(playerController.view)
            playerController.view.frame = self.view.frame
            
            player.play()
    
        //showQuestInfo
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }

}
