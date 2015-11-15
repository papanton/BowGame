
//
//  StageSix.swift
//  BowGame
//
//  Created by Zhiyang Lu on 11/10/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit
class StageSix: StageGameScene
{
    override func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:"MoonBackground")
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: CGSizeMake(self.frame.width * 2, self.frame.height))
        
        background.zPosition = -100;
        background.position = CGPointMake(size.width,  size.height*0.5)
        //background.size = world.frame.size
        self.world.addChild(background)
    }
    override func addObstacle(){
        addRock(CGPointMake(self.size.width * 1.1, size.height - 100))
    }
    func addRock(position : CGPoint)
    {
        let rock : Rock = Rock(position: position)
        self.world.addChild(rock)
    }
    override func addGround(){}
}
