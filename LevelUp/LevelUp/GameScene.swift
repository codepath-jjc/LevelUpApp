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
    
    let spark = SKEmitterNode(fileNamed: "Spark")

    let rain = SKEmitterNode(fileNamed: "Rain")

    
    var frozen = false
    
    
    var playerDirection:CGFloat = 1.0
    var playerSpeed:CGFloat = 5.0
    let MAX_POOP = 10
    // 1
    let atlas = SKTextureAtlas(named: "lilmonsters.atlas")

    //
    var poops = 0
    let player = SKSpriteNode(imageNamed: "egg")
    let morphaAlas = SKTextureAtlas(named: "morph.atlas")
    let eggAtlas = SKTextureAtlas(named: "egg.atlas")

    let poopAtlas = SKTextureAtlas(named: "turd.atlas")

    
    var backBtn: SKLabelNode!
    
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
        scoreLabel.position = CGPoint(x: 20  + scoreLabel.frame.width/2, y: self.frame.size.height - (10 +  scoreLabel.frame.height ))

        // Back btn
        backBtn = SKLabelNode(text: "Back")
        
        backBtn.fontColor = AppColors.PrimaryAccentColor
        backBtn.fontSize = 20
        backBtn.name = "backbtn"
        backBtn.fontName = "AmericanTypewriter-Bold"
        
        backgroundLayer?.addChild(backBtn)
        
        backBtn.position = CGPoint(x: 20  + backBtn.frame.width/2, y: 20)

        
        //
        
        backgroundColor = AppColors.DARKDARKBROWN
        // 3
        player.position = CGPoint(x: size.width * 0.45, y: size.height * 0.5)
        player.name = "player"
        // 4
        backgroundLayer?.addChild(player)
        flare?.name = "playerflare"
        flare?.isHidden = true
        
        
        
        spark?.isHidden = true
        
        rain?.isHidden = true
        
        
        player.addChild(flare!)
        player.addChild(spark!)

        
        player.zPosition = 2
        
        // POOPS on timer
        
        
        // POOP TIMER
        
      
        
        // EGG!!!
        
        if LevelUpClient.morphLevel == 0 {
            loadMorphLevel0()
        }
        
        
      
        if LevelUpClient.morphLevel == 1 {
            loadMorphLevel1()
        }
        
        if LevelUpClient.morphLevel == 2 {
            loadMorphLevel2()
        }
        
        
     
        
        
    }
    
    
    func startPoopingTimer(){
        
        var poopTimer = 4.0
        if(LevelUpClient.morphLevel > 1){
            poopTimer = 80
        }
        
        print("poopTimer",poopTimer)
        
        let wait = SKAction.wait(forDuration: poopTimer) //change countdown speed here
        let block = SKAction.run({
            [unowned self] in
            print("POOP TIMER")
            self.addPoop()
            
        })
        let sequence = SKAction.sequence([wait,block])
        
        run(SKAction.repeatForever(sequence), withKey: "countdown")

    }
    
    
    
    func addPoop(){
   
        if (poops > MAX_POOP) {
            return
        }
        poops += 1

        self.shakeScreen()

        
        // ADD POOP
        let poop = SKSpriteNode(imageNamed: "poop.png")

        
        /////////
        let m1 = poopAtlas.textureNamed("sprite_0.png")
        let m2 = poopAtlas.textureNamed("sprite_1.png")
        let m3 = poopAtlas.textureNamed("sprite_2.png")
        let m4 = poopAtlas.textureNamed("sprite_3.png")
        let m5 = poopAtlas.textureNamed("sprite_4.png")

        
        let textures = [m1, m2, m3, m4, m5]
        
        
        let morphAniamtion = SKAction.animate(with: textures, timePerFrame: 0.15)
        poop.run(SKAction.repeatForever(morphAniamtion))
        
        poop.name = "poop"
        let poopX =  random(min: size.width * 0.2, max:  size.width * 0.8)
        let poopY =  random(min: size.height * 0.1, max:  size.height * 0.45)
        
        poop.position = CGPoint(x: poopX, y: poopY)
        
        backgroundLayer?.addChild(poop)

    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func updatePlayer(){
        
        if frozen  {
            return
        }
        if LevelUpClient.morphLevel >= 1 {
            var playerX = player.position.x
            playerX = playerX +  playerDirection * playerSpeed
            //print("positionX", playerX)
            player.position = CGPoint(x:  playerX, y: player.position.y)
            
            if(playerX >=  self.size.width * 0.85  || playerX <= self.size.width * 0.1){ //(backgroundLayer?.frame.size.width)!){
                playerDirection *= -1.0
            }
            
        }
        
        
    }
    override func update(_ currentTime: TimeInterval) {
        
        
        self.updatePlayer()

    }
    
    
    fileprivate func shakeScreen(_ duration:Float = 0.45) {
        let shakeAction = GameScene.shake(self.backgroundLayer!.position, duration: duration);
        self.backgroundLayer!.run(shakeAction);
    }
    

    
    func loadMorphLevel1(){
        startPoopingTimer()

        LevelUpClient.morphLevel = 1
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
    }
    
    func loadMorphLevel2(){
        startPoopingTimer()

        LevelUpClient.morphLevel = 2
        /////////
        let m1 = morphaAlas.textureNamed("morph1.png")
        let m2 = morphaAlas.textureNamed("morph2.png")
        
        
        let textures = [m1, m2]
        
        
        let morphAniamtion = SKAction.animate(with: textures, timePerFrame: 0.15)
        player.run(SKAction.repeatForever(morphAniamtion))
        
    }
    
    func loadMorphLevel0(){
        
        
        /////////
        let m1 = eggAtlas.textureNamed("sprite_0.png")
        let m2 = eggAtlas.textureNamed("sprite_1.png")
        
        
        let textures = [m1, m2]
        
        
        let morphAniamtion = SKAction.animate(with: textures, timePerFrame: 0.15)
        player.run(SKAction.repeatForever(morphAniamtion))
        
    }
    
    func showSpark(){
        frozen = true
        self.spark?.isHidden = false
        self.spark?.zPosition = 5
        
        let ballAction = SKAction.wait(forDuration: TimeInterval(0.3));
        self.run(ballAction, completion: { () -> Void in
            //self.resetEverything()
            print("action ran")
            self.frozen = false
            self.spark?.isHidden = true
            
        });
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)

        print("TOUCH")
        
        if backBtn.contains(location) {
            closedDelegate?.closedPressed?()
            
        }
        
        
        
        ///////////////
        if  player.contains(location) {
            print("TOUCH PET")
            
            // TRANFORM:
            
            if(LevelUpClient.__points >= 20 && LevelUpClient.morphLevel == 1){
                loadMorphLevel2()
                showSpark()
            }
            
            if(LevelUpClient.morphLevel == 0){
                loadMorphLevel1()
                showSpark()
            }

            
            
            //   node.isHidden = true
            self.flare?.isHidden = false
            
            
            let ballAction = SKAction.wait(forDuration: TimeInterval(2.0));
            self.run(ballAction, completion: { () -> Void in
                //self.resetEverything()
                print("action ran")
                self.flare?.isHidden = true
                
            });
            
        }
        
        // loop over POOP
        var clearedPoop = false
        backgroundLayer?.enumerateChildNodes(withName: "poop") { node, stop in
            
            
            if  !clearedPoop && node.contains(location) && node.isHidden == false {
                clearedPoop = true
                node.isHidden = true
                self.poops -= 1
                node.removeFromParent()
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
