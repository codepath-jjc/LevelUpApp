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
    var scoreLabel :SKLabelNode!

    var closedDelegate: GameSceneControllerCellDelegate?
    
    let flare = SKEmitterNode(fileNamed: "Flare")
    
    var playerDirection:CGFloat = 1.0
    var playerSpeed:CGFloat = 5.0
   
    // 1
    let atlas = SKTextureAtlas(named: "lilmonsters.atlas")

    let player = SKSpriteNode(imageNamed: "petbase.png")
    let morphaAlas = SKTextureAtlas(named: "morph.atlas")

    override func didMove(to view: SKView) {
        // 2

        // Holds eve
        backgroundLayer = SKSpriteNode();
        self.addChild(backgroundLayer!);

        
        // Our score board!
        let points = LevelUpClient.__points
        scoreLabel = SKLabelNode(text: "Power Level: \(points)")
        
        scoreLabel.fontColor = AppColors.PrimaryAccentColor
        scoreLabel.fontSize = 20
        scoreLabel.name = "score"
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        
        backgroundLayer?.addChild(scoreLabel)
        scoreLabel.position = CGPoint(x: 20  + scoreLabel.frame.width/2, y: self.frame.size.height - 60)

     
        
        let m1 = atlas.textureNamed("sprite_0.png")
        let m2 = atlas.textureNamed("sprite_1.png")
        let m3 = atlas.textureNamed("sprite_2.png")
        
     /*
        let m1 = atlas.textureNamed("pet1.png")
        let m2 = atlas.textureNamed("pet2.png")
        let m3 = atlas.textureNamed("pet3.png")
*/
        
        let textures = [m1, m2, m3]
        
        
        
        let meleeAnimation = SKAction.animate(with: textures, timePerFrame: 0.095)
        
        player.run(SKAction.repeatForever(meleeAnimation))
        
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
        let location = touches.first!.location(in: self)

        print("TOUCH")
        
        
        
        /////////
        let m1 = morphaAlas.textureNamed("morph1.png")
        let m2 = morphaAlas.textureNamed("morph2.png")
        
        
        let textures = [m1, m2]
        
        
        
        let morphAniamtion = SKAction.animate(with: textures, timePerFrame: 0.15)
        
        player.run(SKAction.repeatForever(morphAniamtion))
        
        
        if scoreLabel.contains(location) {
            closedDelegate?.closedPressed?()

        }
        
        ///////////////
        
        backgroundLayer?.enumerateChildNodes(withName: "player") { node, stop in
            
            
           
            if node.contains(location) && node.isHidden == false {
                print("TOUCH PET")
              //  self.shakeScreen()
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
