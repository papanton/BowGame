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
    private func getShotable(contact: SKPhysicsContact)-> Shotable?
    {
        var shotable: Shotable?
        if contact.bodyA.categoryBitMask == CollisonHelper.ShotableMask {
            shotable = contact.bodyA.node as? Shotable
        }
        if contact.bodyB.categoryBitMask == CollisonHelper.ShotableMask {
            shotable = contact.bodyB.node as? Shotable
        }
       return shotable
    }
    func didBeginContact(contact: SKPhysicsContact)
    {
        
        var arrow: Arrow? = getArrow(contact)
        var shotable: Shotable? = getShotable(contact)
        if(arrow != nil){
            if(shotable != nil) {
                shotable!.shot(arrow!)
            }
        }
    }

}