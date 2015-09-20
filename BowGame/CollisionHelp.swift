//
//  CollisionHelp.swift
//  Test
//
//  Created by ZhangYu on 9/8/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import UIKit
import SpriteKit

class CollisonHelper
{
    static let ArrowMask : UInt32 = 0x1 << 0
    static let ShotableMask: UInt32 = 0x1 << 1
   // static let PlayerMask: UInt32 = 0x1 << 1
  //  static let GroundMask: UInt32 = 0x1 << 2
    private static var mInstance : CollisonHelper!
    static func getInstance() ->CollisonHelper
    {
        if mInstance == nil{
            mInstance = CollisonHelper()
        }
        return mInstance!
    }
    private init(){}
    private func getArrow(contact :SKPhysicsContact)->Arrow?
    {
        var arrow : Arrow?
        if contact.bodyA.categoryBitMask == CollisonHelper.ArrowMask{
            arrow = contact.bodyA.node as? Arrow
        }
        if contact.bodyB.categoryBitMask == CollisonHelper.ArrowMask {
            arrow = contact.bodyB.node as? Arrow
        }
        return arrow;
    }
    private func getShotable(contact: SKPhysicsContact)-> (shotableA:Shotable?, shotableB:Shotable?)
    {
        var shotableA: Shotable?
        var shotableB: Shotable?
        if contact.bodyA.categoryBitMask == CollisonHelper.ShotableMask {
            shotableA = contact.bodyA.node as? Shotable
        }
        if contact.bodyB.categoryBitMask == CollisonHelper.ShotableMask {
            shotableB = contact.bodyB.node as? Shotable
        }
       return (shotableA,shotableB)
    }
    func didBeginContact(contact: SKPhysicsContact)
    {
        
        var arrow: Arrow? = getArrow(contact)
        var shotable = getShotable(contact)
        
        
        if(arrow != nil){
            if(shotable.shotableA != nil) {
                shotable.shotableA!.shot(arrow!)
            }
            else if(shotable.shotableB != nil) {
                shotable.shotableB!.shot(arrow!)
            }
        }
        
        if(shotable.shotableA != nil && shotable.shotableB != nil) {
            shotable.shotableA?.shot(shotable.shotableB!)
            shotable.shotableB?.shot(shotable.shotableA!)
        }
    }

}