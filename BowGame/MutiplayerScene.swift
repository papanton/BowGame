//
//  MutiplayerScene.swift
//  BowGame
//
//  Created by ZhangYu on 10/17/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit
class MutiplayerScene: GameScene
{
    
    
    override func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:"forestbg")
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
        
        let ground3size = CGSizeMake(327 * 0.8, 136 * 0.8)
        let ground3 = Ground(texture: SKTexture(imageNamed: "snow_ground3"), size: ground3size, position: CGPointMake(580 + ground3size.width / 2, size.height / 6 + ground3size.height / 2))
        self.world.addChild(ground3)
        
        
        let collisionframe = CGRectInset(frame, -frame.width*0.2, -frame.height*0.5)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: collisionframe)
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = CollisonHelper.ArrowMask
    }
    
    override func addObstacle() {
        addComponent1()
        addComponent3()
    }
    
    private func addComponent1()
    {
        let start = CGPointMake(382 + 25, self.size.height / 6 + 87)
        let box1 = woodbox(position: start)
        let box2 = woodbox(position: CGPointMake(start.x + 100, start.y))
        let box3 = woodbox(position: CGPointMake(start.x + 50, start.y))
        let box4 = woodbox(position: CGPointMake(start.x + 50, start.y + 50))

        self.world.addChild(box1)
        self.world.addChild(box2)
        self.world.addChild(box3)
        self.world.addChild(box4)
    }
    
    private func addComponent3()
    {
        let start = CGPointMake(650 + 25, self.size.height / 6 + 136 * 0.8)
        let box1 = woodbox(position: start)
        let box2 = woodbox(position: CGPointMake(start.x + 100, start.y))
        self.world.addChild(box1)
        self.world.addChild(box2)
        
    }


    
    
    override func leftControllerOnTouchBegin()
    {
        if self.rounds % 2 == 1{
            super.leftControllerOnTouchBegin()
        }
    }
    override  func rightControllerOnTouchBegin()
    {
        if self.rounds % 2 == 0{
            super.rightControllerOnTouchBegin()
        }
    }
    override func controllerShoot(position: CGPoint)
    {
        if(rounds % 2 == 1)
        {
            controllers.moveLeftController(position)
        }else{
            controllers.moveRightController(position)
        }
    }
    override func controllerOnTouchEnded()
    {
        if(self.rounds % 2 == 1)
        {
            controllers.resetLeftController()
        }
        if(self.rounds % 2 == 0)
        {
            controllers.resetRightController()
        }
    }
}
