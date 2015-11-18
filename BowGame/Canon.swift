//
//  Canon.swift
//  BowGame
//
//  Created by ZhangYu on 10/21/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import SpriteKit

class Canon: SKSpriteNode, Shotable
{
    private let CanonSize = CGSizeMake(35,25)
    init() {
        let texture = SKTexture(imageNamed: "Canon")
        super.init(texture: texture, color: UIColor.clearColor(), size: CanonSize )
        position = CGPointMake(position.x, position.y + self.size.height / 2)
        addPhysicsBody(texture)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //init physicsBody to the obstacle
    private func addPhysicsBody(texture :SKTexture )
    {
        self.physicsBody = SKPhysicsBody(texture: texture, size: CanonSize)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
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
        for _ in 1 ... 5{
            firesequeue.append(fireaction)
            firesequeue.append(SKAction.waitForDuration(0.5))
        }
        return firesequeue
    }
    
    func fire()
    {
        let bomb = CanonBomb(pos: position)
        SoundEffect.getInstance().playCannon()
        parent?.addChild(bomb)
        delay(0.6){
            bomb.removeFromParent()
        }
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
    
    func shot(attacker :Attacker)->Bool
    {
        
        if let bomb = attacker as? Bomb{
            bomb.stop()
            let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
            runAction(fadeout, completion: {
                self.removeFromParent()
            })
            return true
        }
        return false
    }
}
private class CanonBomb : Obstacle
{
    init(pos : CGPoint)
    {
        super.init(name: CanonStone, damage: 0, position: pos, size: CGSizeMake(20, 20))
        physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        physicsBody?.collisionBitMask = 0x0
        physicsBody?.dynamic = true
        physicsBody?.affectedByGravity = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func isAlive() -> Bool {
        return parent != nil
    }
}