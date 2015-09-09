//
//  GameScene.swift
//  Test
//
//  Created by ZhangYu on 9/5/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    var player = PlayerFactory.getPlayer()
    func initworld()
    {
        backgroundColor = SKColor.whiteColor()
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self
    }
    override func didMoveToView(view: SKView) {
        initworld()
        player.position = CGPointMake(size.width*0.15, size.height/5);
        self.addChild(player)
        var enemy = PlayerFactory.getPlayer()
        enemy.position = CGPointMake((size.width*0.85), size.height/5);
        self.addChild(enemy)

    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            player.shoot(CGVectorMake(8 , 10), scene: self)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        for child in (self.children) {
            if child is Arrow{
                var arrow = child as! Arrow
                arrow.update()
            }
        }
    }
    func didBeginContact(contact: SKPhysicsContact)
    {
        NSLog("get hurt")
        var player: Player
        if contact.bodyA.categoryBitMask == CollisonHelper.PlayerMask {
            player = contact.bodyA.node as! Player
            player.shot()
        }
        if contact.bodyB.categoryBitMask == CollisonHelper.PlayerMask {
            player = contact.bodyB.node as! Player
            player.shot()
        }
    }
}
