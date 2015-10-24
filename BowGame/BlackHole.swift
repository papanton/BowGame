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
    init(position: CGPoint)
    {
        super.init(name: "BackHole1", damage: 0, position: position, size : CGSizeMake(70, 70))
        physicsBody?.affectedByGravity = false
        let backhole1 = SKTexture(imageNamed: "BackHole1")
        let backhole2 = SKTexture(imageNamed: "BackHole2")
        let animation = SKAction.animateWithTextures([backhole1,backhole2], timePerFrame: 0.2)
        let newanimation = SKAction.repeatActionForever(animation)
        runAction(newanimation)
    }
    func disableCollision()
    {
        self.physicsBody?.categoryBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
        self.physicsBody?.collisionBitMask = 0

    }
    func enableCollision()
    {
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask | CollisonHelper.ShotableMask
        self.physicsBody?.collisionBitMask = CollisonHelper.ArrowMask | CollisonHelper.ShotableMask
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func shot(attack: Attacker) -> Bool {
        if attack is Arrow{
            let temp = position
            disableCollision()
            let arrow = attack as! Arrow
            absorb(arrow)
            disappear()
            appear(arrow, pos: CGPointMake(((parent?.scene?.size.width)!*2)-100, 300))
            reshootAnimation(arrow)
            delay(3){
               self.disappear()
               self.appear(nil, pos: temp)
            }
        }
        return false
    }
    func absorb(arrow : Arrow)
    {
        arrow.physicsBody?.dynamic = false
        let sequence = [SKAction.moveTo(position, duration: 0.5), SKAction.scaleTo(0, duration: 1)]
        arrow.runAction(SKAction.sequence(sequence), completion: arrow.removeFromParent)
    }
    func disappear()
    {
        let sequence = [SKAction.waitForDuration(0.5), SKAction.scaleTo(0, duration: 1)]
        runAction(SKAction.sequence(sequence))
    }
    func reAdd(arrow : Arrow, pos : CGPoint)
    {
        arrow.position = pos
        parent?.addChild(arrow)
    }
    func reshoot(arrow : Arrow)
    {
        arrow.physicsBody?.dynamic = true
        arrow.go(CGVectorMake(0, -50), position: arrow.position)
    }
    func reshootAnimation(arrow : Arrow)
    {
        let sequence = [SKAction.waitForDuration(3), SKAction.scaleTo(1, duration: 1), SKAction.runBlock({self.reshoot(arrow)}),SKAction.waitForDuration(0.5)]
        arrow.runAction(SKAction.sequence(sequence), completion: enableCollision)
    }
    func appear(arrow : Arrow?, pos : CGPoint)
    {

        var sequence = [SKAction.waitForDuration(2), SKAction.runBlock({self.position = pos}), SKAction.scaleTo(1, duration: 1)]
        if arrow != nil{
            sequence.append(SKAction.runBlock({self.reAdd(arrow!, pos: pos)}))
        }
        runAction(SKAction.sequence(sequence))
    }
}
