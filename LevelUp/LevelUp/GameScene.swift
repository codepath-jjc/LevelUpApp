//
//  GameScene.swift
//  LevelUp
//
//  Created by jason on 12/8/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene , SKPhysicsContactDelegate{
    
    
    let flare = SKEmitterNode(fileNamed: "Flare")
    
    var playerDirection:CGFloat = 1.0
    var playerSpeed:CGFloat = 10.0
   
    // 1
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMove(to view: SKView) {
        // 2
        
     
        backgroundColor = SKColor.white
        // 3
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        player.name = "player"
        // 4
        addChild(player)
            flare?.name = "playerflare"
        flare?.isHidden = true
        player.addChild(flare!)
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        var playerX = player.position.x
        playerX = playerX +  playerDirection * playerSpeed
        print("positionX", playerX)
        player.position = CGPoint(x:  playerX, y: player.position.y)
        
        

    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TOUCH")
        
        let location = touches.first!.location(in: self)
        
        self.enumerateChildNodes(withName: "player") { node, stop in
            
            if node.contains(location) && node.isHidden == false {
                print("TOUCH PET")
             //   node.isHidden = true
                self.flare?.isHidden = false
               // stop.memory = true
            }
        }

    }
    
    
}

// sprites 
// movement
