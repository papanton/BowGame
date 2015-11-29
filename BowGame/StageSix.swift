
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
    var mBlackHoleballoon : Balloon!
    override func addObstacle()
    {
        addIceBallons()
        addBlackHoleBallons()
    }
    func addIceBallons()
    {
        let ice = SuperIcebox(position: CGPointMake(size.width/2, 40), ice_size: CGSizeMake(200, 20))
        let balloon = Balloon(position: CGPointMake(self.size.width/2, 0),  movements: [CGVectorMake(40,40),CGVectorMake(-40,40)])
        balloon.decorate(ice)
        self.world.addChild(balloon)

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
    override func addBoss()
    {
        let bosshole = BossBlackHole(position: CGPointMake(size.width - 50,size.height/2 - 50), dest: randomPoint())
        let bossposition = CGPointMake(bosshole.mDestination.x, self.size.height / 6)
        self.boss = Boss(name: "firstboss", scene: self, UI: self.UI, world: self.world, position: bossposition)
        bosshole.setBoss(boss)
        boss.add2Scene()
        boss.hideBoss()
        mBlackHoleballoon.decorate(bosshole)
    }
    func addBlackHoleBallons()
    {
        mBlackHoleballoon = Balloon(position: CGPointMake(size.width * 2/3, 0),  movements: [CGVectorMake(50,70),CGVectorMake(-50,70)])

        let points = [CGPointMake(size.width-100, size.height/2 + 120),CGPointMake(size.width-200, size.height/2 + 50), CGPointMake(size.width - 100, size.height/2 + 25), CGPointMake(size.width, size.height/2 + 50),  CGPointMake(size.width-150, size.height/2 - 50)]
        for point in points{
            let bh = BlackHole(position: point, dest: randomPoint())
            mBlackHoleballoon.decorate(bh)
        }
        world.addChild(mBlackHoleballoon)
    }
    private func randomPoint() -> CGPoint
    {
        let dx = arc4random_uniform(UInt32((scene?.size.width)!) - 200) + UInt32((scene?.size.width)!) + 100
        let dy = arc4random_uniform(UInt32((scene?.size.height)!) - 250)+200
        return CGPointMake(CGFloat(dx), CGFloat(dy))
    }
    override func addGround(){}
    override func restartGame() {
        let gameScene = StageSix(size: self.size, mainmenu: self.mainmenu, localPlayer: "temp", multiPlayerON: false, selectionScene : self.selectionScene, stage: self.stage)
        //let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Down, duration: 0.5)
        view?.presentScene(gameScene,transition: transitionType)
        self.removeFromParent()
    }
}
