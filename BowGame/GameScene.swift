//
//  GameScene.swift
//  Test
//
//  Created by ZhangYu on 9/5/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    var player1 = PlayerFactory.getPlayer("player1")
    var player2 = PlayerFactory.getPlayer("player2")
    
    func initworld()
    {
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self
        let backgroundTexture =  SKTexture(imageNamed: "Background")
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: self.frame.size)
        background.zPosition = -100;
        background.position = CGPointMake(size.width*0.5,  size.height*0.5)
        
        self.addChild(background)
        
    }
    func addPlayers()
    {
        player1.position = CGPointMake(size.width*0.15, size.height/5);
        self.addChild(player1)
        player2.position = CGPointMake((size.width*0.85), size.height/5);
        self.addChild(player2)

    }
    override func didMoveToView(view: SKView) {
        initworld()
        addPlayers()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            player1.shoot(CGVectorMake(8 , 10), scene: self)
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
