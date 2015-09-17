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
    static let PlayerMask: UInt32 = 0x1 << 1
    static let GroundMask: UInt32 = 0x1 << 2
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
    private func getPlayer(contact: SKPhysicsContact)-> Player?
    {
        var player: Player?
        if contact.bodyA.categoryBitMask == CollisonHelper.PlayerMask {
            let playerNode = contact.bodyA.node as! PlayerNode
            player = playerNode.getPlayer()
        }
        if contact.bodyB.categoryBitMask == CollisonHelper.PlayerMask {
            let playerNode = contact.bodyB.node as! PlayerNode
            player = playerNode.getPlayer()
        }
       return player
    }
    func didBeginContact(contact: SKPhysicsContact)
    {
        
        var arrow: Arrow? = getArrow(contact)
        var player: Player? = getPlayer(contact)
        if(arrow != nil){
            if(player == nil || !arrow!.isFrom(player!)){
                arrow!.stop()
            }
            if(player != nil && !arrow!.isFrom(player!)) {
                player!.shot(arrow!)
            }
        }
    }

}