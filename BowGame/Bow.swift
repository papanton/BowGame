//
//  Bow.swift
//  Test
//
//  Created by ZhangYu on 9/7/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import UIKit
import SpriteKit
class Bow: SKSpriteNode {
    func shoot(velocity: CGVector, arrow: Arrow,scene : SKScene)
    {
        arrow.go(velocity)
    }
}
