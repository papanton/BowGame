//
//  Arrow.swift
//  Test
//
//  Created by ZhangYu on 9/8/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import UIKit
import SpriteKit
class Arrow: SKSpriteNode {
    
    private var damage :Int!
    private var host : Player!
    private var isFlying = true
    func getDamage()-> Int
    {
        return damage;
    }
    func getHost()-> Player
    {
        return host
    }
    func stop()
    {
        isFlying = false
        physicsBody = nil
        let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 2.0)
        runAction(fadeout, completion: {
            self.removeFromParent()})
    }
    func isFrom(player : Player)->Bool
    {
        return player == self.host;
    }
    init(player : Player) {
        var spriteSize = CGSize(width: 30.0, height: 10.0)
        let texture = SKTexture(imageNamed: ArrowImage)
        damage = 30
        host = player
        super.init(texture: texture, color: SKColor.clearColor(), size: spriteSize)
        addPhysicsBody()
    }
    private func addPhysicsBody()
    {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size);
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.collisionBitMask = 0x0
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func go(impulse : CGVector, position : CGPoint){
        if(impulse.dx < 0) {
            self.xScale = -1
        }
        self.position = position
        physicsBody!.applyImpulse(impulse)
       // self.physicsBody?.applyForce(CGVectorMake(100, 100))
        //physicsBody!.velocity = velocity
        //let action1 = SKAction.rotateByAngle(CGFloat(M_PI), duration:5)
        //let action2 = SKAction.moveToX(scene.size.width, duration: 1)
        // arrow.runAction(SKAction.repeatActionForever(action1))
        //arrow.runAction(action2)
       
    }
    func update()
    {
        if isFlying {
            let val = (physicsBody!.velocity.dy) / (physicsBody!.velocity.dx)
            self.zRotation = atan(val)
        }
    }
    /*   required init?(coder aDecoder: NSCoder) {
    self.bow = aDecoder.decodeObjectForKey("BOW") as!  Bow
    super.init(coder: aDecoder)
    }
    override func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.bow, forKey: "BOW")
    super.encodeWithCoder(aCoder)
    }*/
}
