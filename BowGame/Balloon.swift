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
    var mObstacles = [Obstacle]()
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
        MovementWrapper.addMovement(self, movements: movements)
    }
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    override func shot(attacker : Attacker)->Bool
    {
        if let arrow = attacker as? Arrow{
            MovementWrapper.removeMovement(self)
            arrow.tryStop()
            releaseObstacles()
            removeFromParent()
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
        ob.runAction(SKAction.moveTo(obPos, duration: 0.7))
    }
}
