//
//  BlackHole.swift
//  BowGame
//
//  Created by ZhangYu on 10/21/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class BlackHole: Obstacle
{
    static var sNumShotBlackHole = 0
    var mIsShot = false
    var mDestination: CGPoint!
    init(position: CGPoint, dest: CGPoint, isBoss: Bool)
    {
        super.init(name: "BackHole1", damage: 0, position: position, size : CGSizeMake(60, 60))
        var backhole1 = SKTexture(imageNamed: "BackHole1")
        var backhole2 = SKTexture(imageNamed: "BackHole2")
        if (isBoss) {
          
             backhole1 = SKTexture(imageNamed: "BackHole1T")
             backhole2 = SKTexture(imageNamed: "BackHole2T")
        }
        
        physicsBody?.affectedByGravity = false
      
        let animation = SKAction.animateWithTextures([backhole1,backhole2], timePerFrame: 0.2)
        let newanimation = SKAction.repeatActionForever(animation)
        mDestination = dest
        runAction(newanimation)
        //BlackHole.sReAppearTasks.maxConcurrentOperationCount = 1
    }
    static func reset()
    {
        sNumShotBlackHole = 0
    }
    private func disableCollision()
    {
        mIsShot = true
        self.physicsBody?.categoryBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
        self.physicsBody?.collisionBitMask = 0

    }
    private func enableCollision()
    {
        mIsShot = false
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask | CollisonHelper.ShotableMask
        self.physicsBody?.collisionBitMask = CollisonHelper.ArrowMask | CollisonHelper.ShotableMask
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func shot(attack: Attacker) -> Bool {
        if !mIsShot && attack is Arrow{
            disableCollision()
            let arrow = attack as! Arrow
            arrow.runAction(SKAction.sequence(arrowAbsorbActions(arrow)))
            runAction(SKAction.sequence(blackDisappearActions()))
            SoundEffect.getInstance().playBlackHole()
            reAppear(arrow)
        }
        return false
    }
    private func arrowAbsorbActions(arrow : Arrow)->[SKAction]
    {
        return [SKAction.runBlock({arrow.physicsBody?.dynamic = false}), SKAction.moveTo(position, duration: 0.5), SKAction.scaleTo(0, duration: 1),SKAction.runBlock({arrow.removeFromParent()}),SKAction.runBlock({self.reAdd(arrow, pos: self.mDestination)})]
    }
    private func blackDisappearActions()->[SKAction]{
        return [SKAction.waitForDuration(0.5), SKAction.scaleTo(0, duration: 1)]
    }
    private func arrowReappearActions(arrow : Arrow)->[SKAction]
    {
        var sequence = [SKAction]()
        sequence.append(SKAction.scaleTo(1, duration: 1))
        sequence.append(SKAction.runBlock({self.reshoot(arrow)}))
        return sequence
    }
    private func blackReappearActions()->[SKAction]
    {
        let origin = position
        var sequence = [SKAction]()
        sequence.appendContentsOf([SKAction.runBlock({self.position = self.mDestination}), SKAction.scaleTo(1, duration: 1)])// reappear
        sequence.appendContentsOf([SKAction.waitForDuration(0.5), SKAction.scaleTo(0, duration: 1)])//disappear
        sequence.appendContentsOf([SKAction.runBlock({self.position = origin}), SKAction.scaleTo(1, duration: 1)])//reappear to original position
        //sequence.append( SKAction.runBlock({self.enableCollision()}) )
        return sequence
    }
    private func reAppear(arrow : Arrow)
    {
        let curnum = BlackHole.sNumShotBlackHole++
        delay(1.5 + 3.5 * Double(curnum)){
            self.runAction(SKAction.sequence(self.blackReappearActions()), completion: {
                --BlackHole.sNumShotBlackHole
                self.enableCollision()
            })
            arrow.runAction(SKAction.sequence(self.arrowReappearActions(arrow)))
            SoundEffect.getInstance().playBlackHole()
        }
    }

    private func reAdd(arrow : Arrow, pos : CGPoint)
    {
        arrow.position = pos
        arrow.zRotation = CGFloat(-M_PI/2)
        arrow.physicsBody?.velocity.dx = 0
        arrow.physicsBody?.velocity.dy = 0
        parent?.addChild(arrow)
    }
    private func reshoot(arrow : Arrow)
    {
        delay(0.1){
            arrow.physicsBody?.dynamic = true
            //arrow.zRotation = CGFloat(-M_PI/2)
            arrow.go(CGVectorMake(0, -5), position: arrow.position)
            arrow.zRotation = CGFloat(-M_PI/2)
        }
    }
    
}
class BossBlackHole : BlackHole
{
    var mBoss: Boss!
    func setBoss(boss: Boss){
        mBoss = boss
        //mBoss.bossposition = mDestination
    }
    
    private override func blackReappearActions()->[SKAction]
    {
        let showBoss = SKAction.runBlock(mBoss.showBoss)
        let hideBoss = SKAction.runBlock(mBoss.hideBoss)
        var res = [showBoss]
        res.appendContentsOf(super.blackReappearActions())
        res.append(hideBoss)
        return res
    }
}
