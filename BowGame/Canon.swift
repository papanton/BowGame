//
//  Canon.swift
//  BowGame
//
//  Created by ZhangYu on 10/21/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import SpriteKit

class Canon: SKSpriteNode
{
    init() {
        let name = "Canon"
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSizeMake(50,50) )
        position = CGPointMake(position.x, position.y + self.size.height / 2)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func preFireAction()->SKAction
    {
        return SKAction.rotateByAngle(-CGFloat(M_PI)/3, duration: 1)
    }
    func startFire()
    {
        let action = SKAction.repeatActionForever(fireSequence())
        runAction(action)
    }
    func fireAction()->[SKAction]
    {
        let fireaction = SKAction.runBlock(fire)
        var firesequeue = [SKAction]()
        for _ in 1 ... 10{
            firesequeue.append(fireaction)
            firesequeue.append(SKAction.waitForDuration(0.3))
        }
        return firesequeue
    }
    
    func fire()
    {
        let bomb = Obstacle(name: CanonStone, damage: 0, position: position, size: CGSizeMake(20, 20))
        bomb.physicsBody?.dynamic = true
        bomb.position = position
        //bomb.position.x -= 25 * xScale
        parent?.addChild(bomb)
        bomb.physicsBody?.applyImpulse(CGVectorMake(0, 10))
    }
    func fireSequence()->SKAction
    {
        var sequence = [preFireAction()]
        for action in fireAction(){
            sequence.append(action)
        }
        sequence.append(postFireAction())
        return SKAction.sequence(sequence)
    }
    func postFireAction()->SKAction
    {
        return SKAction.rotateByAngle(CGFloat(M_PI)/3, duration: 1)
    }
    func stop()
    {
    }
}
