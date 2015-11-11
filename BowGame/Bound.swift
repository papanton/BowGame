//
//  Bound.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/25/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit
class Bound: SKSpriteNode, Shotable {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(texture: SKTexture, size:CGSize,position: CGPoint) {
        super.init(texture: texture, color: SKColor.clearColor(), size: size)
        self.position = position
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = 0x0
    }
    
    func shot(attack : Attacker)->Bool
    {
        if let arrow = attack as? Arrow {
            arrow.stop()
        }
        return true
    }
}
