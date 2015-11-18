//
//  StageFive.swift
//  BowGame
//
//  Created by Zhiyang Lu on 11/10/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class StageFive: StageGameScene {
    
    var mBossBlackHole : BossBlackHole!
    override func addObstacle()
    {
        addBlackHole()
    }
    func addBlackHole()
    {
        let points = [CGPointMake(300, 300), CGPointMake(100,200), CGPointMake(400,50), CGPointMake(500,100), CGPointMake(250,200), CGPointMake(550,200), CGPointMake(600,300),CGPointMake(400,300)]
        let bossIndex = Int(arc4random_uniform(UInt32(points.count)) + 1)
        for i in 1...points.count-1{
            if i == bossIndex {
                mBossBlackHole = BossBlackHole(position: points[i], dest: randomPoint())
                world.addChild(mBossBlackHole)
                let bossposition = CGPointMake(mBossBlackHole.mDestination.x, self.size.height / 6)
                self.boss = Boss(name: "firstboss", scene: self, UI: self.UI, world: self.world, position: bossposition)
                mBossBlackHole.setBoss(boss)
                boss.add2Scene()
                boss.hideBoss()
            }else{
                let bh = BlackHole(position: points[i], dest: randomPoint())
                world.addChild(bh)
            }
        }
        
        /*for i in 1...10{
            let x = i * 100
            let y = sin(Double(i)/5 * M_PI) * 300
            let point = CGPointMake(CGFloat(x), CGFloat(y))
            let bh = BlackHole(position: point, dest: randomPoint())
            world.addChild(bh)

        }*/
    }
    /*override func addBoss()
    {
        let bossposition = CGPointMake(self.size.width * 2 * 0.9, self.size.height / 6)
        self.boss = Boss(name: "firstboss", scene: self, UI: self.UI, world: self.world, position: bossposition)
        boss.add2Scene()
    }*/
    private func randomPoint() -> CGPoint
    {
        let dx = arc4random_uniform(UInt32((scene?.size.width)!) - 200) + UInt32((scene?.size.width)!) + 100
        let dy = arc4random_uniform(UInt32((scene?.size.height)!) - 250)+200
        return CGPointMake(CGFloat(dx), CGFloat(dy))
    }
    override func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:"MoonBackground")
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: CGSizeMake(self.frame.width * 2, self.frame.height))
        
        background.zPosition = -100;
        background.position = CGPointMake(size.width,  size.height*0.5)
        //background.size = world.frame.size
        self.world.addChild(background)
        
        self.BGM = 2
    }
    override func addGround(){}
}
