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

    override init(size: CGSize, mainmenu: StartGameScene, localPlayer: String, multiPlayerON: Bool) {
        super.init(size: size, mainmenu:mainmenu, localPlayer: localPlayer, multiPlayerON: multiPlayerON)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:"snowbg")
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: CGSizeMake(self.frame.width * 2, self.frame.height))
        background.zPosition = -100;
        background.position = CGPointMake(size.width,  size.height*0.5)
        self.world.addChild(background)
        
        print(background.frame.width)
        print(background.frame.height)
        
    }
    
    override func addGround()
    {
        let groundTexture = SKTexture(imageNamed: "snow_ground")
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
        self.boss = Boss(name: "whiteboss2", scene: self, UI: self.UI, world: self.world, position: bossposition)
        boss.add2Scene()
    }

    
    override func addObstacle() {
        let startposition = CGPointMake(self.size.width * 0.7, self.size.height / 6)
        let obsize = CGPointMake(50, 50)

        
        
        for(var i = 0; i < 6; i++){
            if(i == 0 || i == 5){
                let stone1 = stone(position: CGPointMake(startposition.x + CGFloat(i) * obsize.x, startposition.y))
                let stone2 = stone(position: CGPointMake(startposition.x + CGFloat(i) * obsize.x, startposition.y + 50))
                self.world.addChild(stone2)
                self.world.addChild(stone1)
            }else{
                let ice = Icebox(position: CGPointMake(startposition.x + CGFloat(i) * obsize.x, 300))
                self.world.addChild(ice)
            }
        }
    }



}
