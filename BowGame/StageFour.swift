//
//  StageFour.swift
//  BowGame
//
//  Created by Zhiyang Lu on 11/10/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class StageFour: StageGameScene
{
    override func addBoss()
    {
        let bossposition = CGPointMake(self.size.width * 2 * 0.9, self.size.height / 6)
        self.boss = Boss(name: "firstboss", scene: self, UI: self.UI, world: self.world, position: bossposition)
        boss.add2Scene()
    }
    
    override func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:"snowbg")
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: CGSizeMake(self.frame.width * 2, self.frame.height))
        background.zPosition = -100;
        background.position = CGPointMake(size.width,  size.height*0.5)
        self.world.addChild(background)
    }
    override func addObstacle() {
        for(var i = 0; i < 6; i++){
            let ice = Icebox(position: CGPointMake(size.width/2, 150+CGFloat(i * 50)))
            self.world.addChild(ice)
        }
        let ground = SuperIcebox(position: CGPointMake(size.width, 40), ice_size: CGSizeMake(size.width*2, 30))
            self.world.addChild(ground)
        let ice = SuperIcebox(position: CGPointMake(size.width, 70), ice_size: CGSizeMake(30, 130))
        self.world.addChild(ice)
    }
    override func addGround()
    {
        let groundTexture = SKTexture(imageNamed: "snow_ground")
        let ground : Ground = Ground(texture: groundTexture, size: CGSizeMake(size.width * 2, size.height / 4), position: CGPointMake(size.width, 0))
        self.world.addChild(ground)
        
        
        let collisionframe = CGRectInset(frame, -frame.width*0.2, -frame.height*0.5)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: collisionframe)
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = CollisonHelper.ArrowMask
    }
    override func restartGame() {
        let gameScene = StageFour(size: self.size, mainmenu: self.mainmenu, localPlayer: "temp", multiPlayerON: false, selectionScene : self.selectionScene, stage: self.stage)
        //let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Down, duration: 0.5)
        view?.presentScene(gameScene,transition: transitionType)
        self.removeFromParent()
    }

}
