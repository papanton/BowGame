//
//  StageTwo.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/23/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class StageTwo: StageGameScene {

    override func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:"forestbg")
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: CGSizeMake(self.frame.width * 2, self.frame.height))
        background.zPosition = -100;
        background.position = CGPointMake(size.width,  size.height*0.5)
        self.world.addChild(background)
        
        let decorate = SKSpriteNode(texture: SKTexture(imageNamed: "Sign_1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        decorate.position = CGPointMake(30, self.size.height / 6 + decorate.size.height / 2)
        self.world.addChild(decorate)
        
    }
    
    
    override func addGround()
    {
        let groundTexture = SKTexture(imageNamed: "forest_ground")
        let ground : Ground = Ground(texture: groundTexture, size: CGSizeMake(size.width * 2, size.height / 3), position: CGPointMake(size.width, 0))
        let ground2 : Ground = Ground(texture: SKTexture(imageNamed: "forest_land3"), size: CGSizeMake(228 * 0.8, 152 * 0.8), position: CGPointMake(size.width * 1.5, self.size.height / 6 + 152 * 0.2))
        ground2.zPosition = -2
        self.world.addChild(ground2)
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
        self.boss = Boss(name: "fighterboss1", scene: self, UI: self.UI, world: self.world, position: bossposition)
        boss.add2Scene()
    }

    override func addObstacle(){
        let position1 = CGPointMake(self.size.width * 0.5, size.height * 2/3)
        let position2 = CGPointMake(self.size.width * 0.8, size.height/2)
        let position3 = CGPointMake(self.size.width * 1.2, size.height/4)
        addLand(position1)
        addLand(position2)
        addLand(position3)
    }
    func addLand(position : CGPoint)
    {
        let island : Ground = Ground(texture: SKTexture(imageNamed: "forest_land1"), size: CGSizeMake(232 / 2, 84 / 2), position: position)
        MovementWrapper.addMovement(island, movements: [CGVectorMake(0, frame.height * 3/4 - island.position.y), CGVectorMake(0, -frame.height/2), CGVectorMake(0, -frame.height/4 + island.position.y)], duration: 3)
        self.world.addChild(island)
    }
    
    override func addArrowPanel()
    {
        super.addArrowPanel()
        panel.setArrowNum(5, bomb: 0, flappy: 5, split: 0, ignore: 0)
    }
    
    
    override func restartGame() {
        let gameScene = StageTwo(size: self.size, mainmenu: self.mainmenu, localPlayer: "temp", multiPlayerON: false, selectionScene : self.selectionScene, stage:self.stage)
        let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        view?.presentScene(gameScene,transition: transitionType)
        self.removeFromParent()
    }
}
