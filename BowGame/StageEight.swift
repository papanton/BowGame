
//
//  StageEight.swift
//  BowGame
//
//  Created by Zhiyang Lu on 11/10/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class StageEight: StageGameScene {
    
    
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
        
        let ground2size = CGSizeMake(311, 87)
        let ground2 = Ground(texture: SKTexture(imageNamed: "snow_ground3"), size: ground2size, position: CGPointMake(382 + ground2size.width / 2, size.height / 6 + ground2size.height / 2))
        self.world.addChild(ground2)
        
        let ground3size = CGSizeMake(327, 136)
        let ground3 = Ground(texture: SKTexture(imageNamed: "snow_ground3"), size: ground3size, position: CGPointMake(580 + ground3size.width / 2, size.height / 6 + ground3size.height / 2))
        self.world.addChild(ground3)
        
        
        let collisionframe = CGRectInset(frame, -frame.width*0.2, -frame.height*0.5)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: collisionframe)
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = CollisonHelper.ArrowMask
    }
    
    override func addBoss()
    {
        let bossposition = CGPointMake(self.size.width * 2 * 0.9, self.size.height / 6)
        self.boss = Boss(name: "whiteboss2", scene: self, UI: self.UI, world: self.world, position: bossposition)
        boss.add2Scene()
    }
    
    
    override func addObstacle() {
        addComponent1()
        addComponent2()
        addComponent3()
    }
    
    private func addComponent1()
    {
        let start = CGPointMake(382 + 25, self.size.height / 6 + 87)
        let box1 = woodbox(position: start)
        let box2 = woodbox(position: CGPointMake(start.x + 100, start.y))
        let box3 = woodbox(position: CGPointMake(start.x + 50, start.y + 50))
        self.world.addChild(box1)
        self.world.addChild(box2)
        self.world.addChild(box3)
    }
    
    private func addComponent2()
    {
        for(var i = 0; i < 3; i++){
            let ice = Icebox(position: CGPointMake(self.size.width * 2 - 25, self.size.height / 6 + CGFloat(i * 50)))
            self.world.addChild(ice)
        }
        
        let start = CGPointMake(self.size.width * 2 - 325, self.size.height / 6)
        for(var i = 0; i < 3; i++){
            let ice1 = Icebox(position: CGPointMake(start.x + CGFloat(i * 25), start.y + CGFloat(i * 50)))
            let ice2 = Icebox(position: CGPointMake(start.x + CGFloat(i * 25) + 50, start.y + CGFloat(i * 50)))
            self.world.addChild(ice1)
            self.world.addChild(ice2)
        }
        for(var i = 0; i < 5; i++){
            let box = woodbox(position: CGPointMake(start.x + 75 + CGFloat(i * 50), start.y + 150))
            self.world.addChild(box)
        }
    }
    
    private func addComponent3()
    {
        let start = CGPointMake(650 + 25, self.size.height / 6 + 136)
        let box1 = woodbox(position: start)
        let box2 = woodbox(position: CGPointMake(start.x + 150, start.y))
        self.world.addChild(box1)
        self.world.addChild(box2)
        
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
        panel.setArrowNum(10, bomb: 5, flappy: 0, split: 2, ignore: 1)
    }

}
