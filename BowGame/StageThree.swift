//
//  StageThree.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/23/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class StageThree: StageGameScene {

    override func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:"snowbg")
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: CGSizeMake(self.frame.width * 2, self.frame.height))
        background.zPosition = -100;
        background.position = CGPointMake(size.width,  size.height*0.5)
        
        let decorate = SKSpriteNode(texture: SKTexture(imageNamed: "Sign_4"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        decorate.position = CGPointMake(30, self.size.height / 6 + decorate.size.height / 2)
        
        self.world.addChild(background)
        self.world.addChild(decorate)
        
    }
    
    override func addGround()
    {
        let groundTexture = SKTexture(imageNamed: "snow_ground")
        let ground : Ground = Ground(texture: groundTexture, size: CGSizeMake(size.width * 2, size.height / 3), position: CGPointMake(size.width, 0))
        self.world.addChild(ground)

        
        let collisionframe = CGRectInset(frame, -frame.width*0.2, -frame.height*0.5)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: collisionframe)
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = CollisonHelper.ArrowMask
    }
    
    override func addBoss()
    {
        let bossposition = CGPointMake(self.size.width * 2 * 0.9, self.size.height / 6)
        self.boss = Boss(name: "whiteboss", scene: self, UI: self.UI, world: self.world, position: bossposition)
        boss.add2Scene()
    }
    
    
    override func addObstacle()
    {
        let position1 = CGPointMake(self.size.width * 0.4, size.height / 6 + 25)
        let position2 = CGPointMake(self.size.width * 0.8, size.height / 6 + 75)
        let position3 = CGPointMake(self.size.width * 1.2, size.height / 6 + 25)
        let position4 = CGPointMake(self.size.width * 1.5, size.height / 6 + 50)
        
        addComponent(position1)
        addComponent(position2)
        addComponent(position3)
        addComponent(position4)
    }
    
    func addComponent(position : CGPoint)
    {
        let island : Ground = Ground(texture: SKTexture(imageNamed: "snow_land"), size: CGSizeMake(232 / 2, 84 / 2), position: position)
        self.world.addChild(island)
        let canon = Canon()
        canon.position = CGPointMake(island.position.x, island.position.y + island.size.height / 2 + canon.size.height / 2)
        self.world.addChild(canon)
        delay(Double(arc4random_uniform(10) % 4)){
            canon.startFire()
        }
    }
    
    override func restartGame() {
        let gameScene = StageEight(size: self.size, mainmenu: self.mainmenu, localPlayer: "temp", multiPlayerON: false, selectionScene : self.selectionScene, stage: self.stage)
        //let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Down, duration: 0.5)
        view?.presentScene(gameScene,transition: transitionType)
        self.removeFromParent()
    }
    
    
    override func addArrowPanel()
    {
        super.addArrowPanel()
        panel.setArrowNum(10, bomb: 10, flappy: 0, split: 0, ignore: 0)
    }

}
