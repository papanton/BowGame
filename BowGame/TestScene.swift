//
//  TestScene.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/23/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class TestScene: StageGameScene {
    
    override init(size: CGSize, mainmenu: StartGameScene, localPlayer: String, multiPlayerON: Bool) {
        super.init(size: size, mainmenu:mainmenu, localPlayer: localPlayer, multiPlayerON: multiPlayerON)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:BackgroundImage)
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: CGSizeMake(self.frame.width * 2, self.frame.height))
        background.zPosition = -100;
        background.position = CGPointMake(size.width,  size.height*0.5)
        self.world.addChild(background)
        
        print(background.frame.width)
        print(background.frame.height)

    }
    
    override func addGround()
    {
        let groundTexture = SKTexture(imageNamed: GroundTexture1)
        let ground : Ground = Ground(texture: groundTexture, size: CGSizeMake(size.width * 2, size.height / 3), position: CGPointMake(0, 0))
        ground.position = CGPointMake(size.width, 0)
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
        self.boss = Boss(name: "firstboss", scene: self, UI: self.UI, world: self.world, position: bossposition)
        boss.add2Scene()
    }
    
    override func addObstacle()
    {
        let startposition = CGPointMake(self.size.width, self.size.height / 6)
        let stone1 = stone(position: CGPointMake(startposition.x, startposition.y))
        let stone2 = stone(position: CGPointMake(startposition.x + 50, startposition.y))
        let stone3 = stone(position: CGPointMake(startposition.x + 100, startposition.y))
        let stone4 = stone(position: CGPointMake(startposition.x + 150, startposition.y))
        let stone5 = stone(position: CGPointMake(startposition.x + 50, startposition.y + 50))
        let stone6 = stone(position: CGPointMake(startposition.x + 150, startposition.y + 50))
        let stone7 = stone(position: CGPointMake(startposition.x + 150, startposition.y + 100))
        
        let box1 = woodbox(position: CGPointMake(startposition.x, startposition.y + 50))
        let box2 = woodbox(position: CGPointMake(startposition.x, startposition.y + 100))
        
        
        self.world.addChild(box1)
        self.world.addChild(box2)
        self.world.addChild(stone1)
        self.world.addChild(stone2)
        self.world.addChild(stone3)
        self.world.addChild(stone4)
        self.world.addChild(stone5)
        self.world.addChild(stone6)
        self.world.addChild(stone7)
        
        addCanon()
        addBlackHole()
        addReflection()

    }
    func addReflection(){
        
        for i in 1 ... 10{
            let ice1 = Icebox(position: CGPointMake(CGFloat(i) * 50, 300))
            let ice2 = Icebox(position: CGPointMake(500, CGFloat(i) * 50))
            ice2.zRotation = CGFloat(M_PI/2)
            world.addChild(ice1)
            world.addChild(ice2)
        }
    }
    override func addBlackHole()
    {
        let bh = BlackHole(position: CGPointMake(400,200))
        world.addChild(bh)
    }
    override func addCanon()
    {
        let canon = Canon()
        canon.position.x = size.width/2
        canon.position.y = 80;
        world.addChild(canon)
        canon.startFire()
    }

    override func addArrowPanel()
    {
        super.addArrowPanel()
        panel.setArrowNum(10, bomb: 3, flappy: 2, split: 2, ignore: 0)
    }
}
