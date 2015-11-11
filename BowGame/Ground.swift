//
//  Ground.swift
//  BowGame
//
//  Created by Jiawei Song on 9/13/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class Ground: SKSpriteNode, Shotable
{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(texture: SKTexture, size:CGSize,position: CGPoint) {
        super.init(texture: texture, color: SKColor.clearColor(), size: size)
        self.position = position
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = 0x0
    }
    func shot(attack : Attacker)->Bool
    {
        if let arrow = attack as? Arrow {
            arrow.stop()
            SoundEffect.getInstance().playArrowHitObstacle()
        }
        return true
    }
}
