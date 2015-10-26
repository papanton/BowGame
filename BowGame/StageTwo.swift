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
    
//    override init(size: CGSize, mainmenu: StartGameScene, localPlayer: String, multiPlayerON: Bool) {
//        super.init(size: size, mainmenu:mainmenu, localPlayer: localPlayer, multiPlayerON: multiPlayerON)
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    override func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:"forestbg")
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: CGSizeMake(self.frame.width * 2, self.frame.height))
        background.zPosition = -100;
        background.position = CGPointMake(size.width,  size.height*0.5)
        self.world.addChild(background)
        
        print(background.frame.width)
        print(background.frame.height)
        
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
        let bossposition = CGPointMake(self.size.width * 2 * 0.9, self.size.height / 3)
        self.boss = Boss(name: "beeboss", scene: self, UI: self.UI, world: self.world, position: bossposition)
        boss.add2Scene()
    }
    
    override func addObstacle() {
        let position = CGPointMake(self.size.width * 0.5, size.height - 100)
        addLandWithBox(position)
        addRock(position)
        
        let position2 = CGPointMake(self.size.width * 0.8, size.height - 200)
        addLandWithBox(position2)
        
        let position3 = CGPointMake(self.size.width * 1.1, size.height - 150)
        addLandWithBox(position3)
        addStones(position3)
        
        let position4 = CGPointMake(self.size.width * 1.5, size.height - 80)
        addLandWithBox2(position4)
    }
    
    
    override func addArrowPanel()
    {
        super.addArrowPanel()
        panel.setArrowNum(10, bomb: 1, flappy: 2, split: 2, ignore: 0)
    }
    
    func addLandWithBox(position : CGPoint)
    {
        let island : Ground = Ground(texture: SKTexture(imageNamed: "forest_land1"), size: CGSizeMake(232 / 2, 84 / 2), position: position)
        self.world.addChild(island)
        let box = woodbox(position: CGPointMake(position.x, position.y + 84 / 4))
        self.world.addChild(box)
    }
    func addRock(position : CGPoint)
    {
        let rock : Rock = Rock(position: CGPointMake(position.x, size.height / 6))
        self.world.addChild(rock)
    }
    func addStones(position : CGPoint)
    {
        for(var i = 0; i < 3; i++){
            let Stone = stone(position: CGPointMake(position.x + CGFloat(50 * i), self.size.height/6))
            self.world.addChild(Stone)
        }
    }
    func addLandWithBox2(position : CGPoint)
    {
        let island : Ground = Ground(texture: SKTexture(imageNamed: "forest_land2"), size: CGSizeMake(348 / 2, 84 / 2), position: position)
        self.world.addChild(island)
        let box1 = woodbox(position: CGPointMake(position.x - 25, position.y + 84 / 4))
        let box2 = woodbox(position: CGPointMake(position.x + 25, position.y + 84 / 4))
        self.world.addChild(box1)
        self.world.addChild(box2)
    }
    override func restartGame() {
        let gameScene = StageTwo(size: self.size, mainmenu: self.mainmenu, localPlayer: "temp", multiPlayerON: false, selectionScene : self.selectionScene)
        let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        view?.presentScene(gameScene,transition: transitionType)
        self.removeFromParent()
    }

    

}
