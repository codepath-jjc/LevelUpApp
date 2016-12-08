//
//  GameScene.swift
//  LevelUp
//
//  Created by jason on 12/8/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import SpriteKit



@objc protocol  GameSceneControllerCellDelegate  {
    @objc optional func closedPressed()
    
}


class GameScene: SKScene , SKPhysicsContactDelegate{
    
    
    var backgroundLayer: SKSpriteNode?

    var closedDelegate: GameSceneControllerCellDelegate?
    
    let flare = SKEmitterNode(fileNamed: "Flare")
    
    var playerDirection:CGFloat = 1.0
    var playerSpeed:CGFloat = 5.0
   
    // 1
    let player = SKSpriteNode(imageNamed: "pet1")
    
    override func didMove(to view: SKView) {
        // 2

        // Holds eve
        backgroundLayer = SKSpriteNode();
        self.addChild(backgroundLayer!);

        
     
        backgroundColor = SKColor.black
        // 3
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        player.name = "player"
        // 4
        backgroundLayer?.addChild(player)
        flare?.name = "playerflare"
        flare?.isHidden = true
        player.addChild(flare!)
       player.zPosition = 2
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        var playerX = player.position.x
        playerX = playerX +  playerDirection * playerSpeed
        //print("positionX", playerX)
        player.position = CGPoint(x:  playerX, y: player.position.y)
 
        if(playerX >=  self.size.width * 0.85  || playerX <= self.size.width * 0.1){ //(backgroundLayer?.frame.size.width)!){
            playerDirection *= -1.0
        }
        

    }
    
    
    fileprivate func shakeScreen(_ duration:Float = 0.3) {
        let shakeAction = GameScene.shake(self.backgroundLayer!.position, duration: duration);
        self.backgroundLayer!.run(shakeAction);
    }
    

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TOUCH")
        
        closedDelegate?.closedPressed?()
        
        let location = touches.first!.location(in: self)
        
        backgroundLayer?.enumerateChildNodes(withName: "player") { node, stop in
            
            if node.contains(location) && node.isHidden == false {
                print("TOUCH PET")
                self.shakeScreen()
             //   node.isHidden = true
                self.flare?.isHidden = false
                
                
                
                let ballAction = SKAction.wait(forDuration: TimeInterval(2.0));
                self.run(ballAction, completion: { () -> Void in
                    //self.resetEverything()
                        print("action ran")
                    self.flare?.isHidden = true

                });
                
                
               // stop.memory = true
            }
        }

    }
    
    
    // Shake function borrowed from - http://stackoverflow.com/questions/20889860/a-camera-shake-effect-for-spritekit
    class func shake(_ initialPosition:CGPoint, duration:Float, amplitudeX:Int = 12, amplitudeY:Int = 3) -> SKAction {
        let startingX = initialPosition.x
        let startingY = initialPosition.y
        let numberOfShakes = duration / 0.015
        var actionsArray:[SKAction] = []
        for index in 1...Int(numberOfShakes) {
            let newXPos = startingX + CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
            let newYPos = startingY + CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
            actionsArray.append(SKAction.move(to: CGPoint(x: newXPos, y: newYPos), duration: 0.015))
        }
        actionsArray.append(SKAction.move(to: initialPosition, duration: 0.015))
        return SKAction.sequence(actionsArray)
    }
    
    
    
}

// sprites 
// movement
