//
//  Obstacle.swift
//  BowGame
//
//  Created by Jiawei Song on 9/20/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class Obstacle: SKSpriteNode, Shotable {
  
    private var type: String!
    private var collisionTimes: Int!
    private var damage : Int!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    init(name: String, size: CGSize, damage: Int) {
        let texture = SKTexture(imageNamed: name)
        self.type = name
        self.damage = damage
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
        self.collisionTimes = 0
        self.addPhysicsBody()
    }
    
    private func addPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.size.width-35, self.size.height))
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask | CollisonHelper.ShotableMask
        self.physicsBody?.collisionBitMask = CollisonHelper.ArrowMask | CollisonHelper.ShotableMask
    }
    
    func getDamage()-> Int
    {
        return damage
    }
    
    func shot(arrow :Arrow)
    {
        arrow.slowDown()
        self.physicsBody?.dynamic = true
        
    }
    
    func shot(shotable: Shotable)
    {
        self.collisionTimes = self.collisionTimes + 1
        if(self.collisionTimes == 2) {
            
            let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1.5 * Double(NSEC_PER_SEC))),dispatch_get_main_queue()){
                self.runAction(fadeout, completion: {
                    self.removeFromParent()})
                }
            }
    }
    
}
