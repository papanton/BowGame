//
//  Ground.swift
//  BowGame
//
//  Created by Jiawei Song on 9/13/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class Ground: SKNode {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(size:CGSize,position: CGPoint) {
        super.init()
        self.position = position
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = CollisonHelper.GroundMask
//        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
//        self.physicsBody?.collisionBitMask = CollisonHelper.ArrowMask
    }
}
