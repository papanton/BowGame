//
//  Interfaces.swift
//  BowGame
//
//  Created by ZhangYu on 10/20/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

protocol Attacker
{
    func afterAttack( )
    func getDamage( ) -> Int
    func tryStop( )
    func stop( )
    func isFrom(player : Player)->Bool
    func isAlive()->Bool
}

protocol Shotable
{
    func shot(attack :Attacker)->Bool
}

protocol ClickObersever
{
    func onClick()
}

class MovementWrapper
{
    static func addMovement(node: SKSpriteNode, movements : [CGVector], duration : NSTimeInterval)
    {
       // let dy = CGFloat(arc4random_uniform(UInt32((scene?.size.height)!)/3) + 30)
        var action = [SKAction]()
        for movement in movements{
            action.append(SKAction.moveBy(movement, duration: duration))
        }
    node.runAction(SKAction.repeatActionForever(SKAction.sequence(action)), withKey: "MovementWrapper")
    }
    static func removeMovement(node: SKSpriteNode)
    {
        node.removeActionForKey("MovementWrapper")
    }
}
