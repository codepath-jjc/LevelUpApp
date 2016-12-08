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

        // REMEMBER:
        // ADD THIS  FILE TO THE Project -> Build Phase
        // COPY BUNDLE RESOURCES
        let fileURL = NSURL(fileURLWithPath:  Bundle.main.path(forResource: "intro2", ofType: "mp4")!)
        
        let player = AVPlayer(url: fileURL as URL )
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = self.view.frame
        playerController.showsPlaybackControls = false
      //  player.addObserver(self, forKeyPath: "actionAtItemEnd", options: [], context: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                         object: player.currentItem)

        
        
        player.play()
    
        
        //showQuestInfo
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    func playerDidFinishPlaying(note:NSNotification){
        print("finished")
        self.performSegue(withIdentifier: "showQuestInfo", sender: self)
    }
    
    
    /*
    func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutableRawPointer) {
        if keyPath == "actionAtItemEnd"{
            //
            print("FINISH")
        }
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }

}
