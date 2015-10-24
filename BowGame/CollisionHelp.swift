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
    private func getAttacker(contact :SKPhysicsContact)->Attacker?
    {
        var attacker : Attacker?
        if contact.bodyA.categoryBitMask == CollisonHelper.ArrowMask{
            attacker = contact.bodyA.node as? Attacker
        }
        if contact.bodyB.categoryBitMask == CollisonHelper.ArrowMask {
            attacker = contact.bodyB.node as? Attacker
        }
        if attacker == nil{
            if (contact.bodyA.categoryBitMask | CollisonHelper.ArrowMask) != 0{
                attacker = contact.bodyA.node as? Attacker
            }
            if (contact.bodyB.categoryBitMask | CollisonHelper.ArrowMask) != 0 {
                attacker = contact.bodyB.node as? Attacker
            }
        }
        return attacker;
    }
    /*private func getShotable(contact: SKPhysicsContact)-> (shotableA:Shotable?, shotableB:Shotable?)
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
    }*/
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
        
        let attacker = getAttacker(contact)
        let shotable = getShotable(contact)
        if(attacker != nil && shotable != nil){
           /* if(shotable.shotableA != nil) {
                shotable.shotableA!.shot(attacker!)
            }
            else if(shotable.shotableB != nil) {
                shotable.shotableB!.shot(attacker!)
            }*/
          //  println(shotable)
            
            if shotable!.shot(attacker!) {
                attacker!.afterAttack()
            }
            
        }
        /*if(shotable.shotableA != nil && shotable.shotableB != nil) {
            shotable.shotableA?.shot(z!)
            shotable.shotableB?.shot(shotable.shotableA!)
        }*/
    }

}