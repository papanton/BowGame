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
        physicsBody?.dynamic = false
        let backhole1 = SKTexture(imageNamed: "BackHole1")
        let backhole2 = SKTexture(imageNamed: "BackHole2")
        let animation = SKAction.animateWithTextures([backhole1,backhole2], timePerFrame: 0.2)
        let newanimation = SKAction.repeatActionForever(animation)
        runAction(newanimation)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
