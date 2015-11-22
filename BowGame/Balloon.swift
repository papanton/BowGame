//
//  Balloon.swift
//  BowGame
//
//  Created by ZhangYu on 11/16/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class Balloon: Obstacle
{
    var mOriginPosition: CGPoint!
    var mObstacles = [Obstacle]()
    var isBlowed = false
    private let BallonSize = CGSizeMake(40, 70)
    func decorate(ob: Obstacle)
    {
        mObstacles.append(ob)
    }
    init(position: CGPoint, movements: [CGVector])
    {
        super.init(name: "Balloon", damage: 0, position: position, size: BallonSize)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = 0x0
        mOriginPosition = position
        MovementWrapper.addMovement(self, movements: movements, duration: 1)
        addResetAction()
    }
    private func addResetAction()
    {
        let sequence = [SKAction.waitForDuration(1.0), SKAction.runBlock(resetPositionIfOutBound)]
        runAction(SKAction.repeatActionForever(SKAction.sequence(sequence)) )
    }
    private func resetPositionIfOutBound()
    {
        if position.y > parent?.scene?.size.height{
            position = mOriginPosition
        }
        
    }
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    override func shot(attacker : Attacker)->Bool
    {
        if let arrow = attacker as? Arrow{
            if !isBlowed{
                isBlowed = true
                SoundEffect.getInstance().playBallonBurst()
                MovementWrapper.removeMovement(self)
                arrow.tryStop()
                releaseObstacles()
                removeFromParent()
            }
        }
        return true;
    }
    private func releaseObstacles()
    {
        let curScene = parent
        for ob in mObstacles{
            releaseObstacle(ob, curScene: curScene)
        }
    }
    private func releaseObstacle(ob: Obstacle, curScene: SKNode?)
    {
        let obPos = ob.position
        ob.position = position
        curScene?.addChild(ob)
        ob.runAction(SKAction.moveTo(obPos, duration: 1))
    }
}
