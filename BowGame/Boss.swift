//
//  Boss.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/14/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class Boss : NSObject{
    
    private var name : String!
    private var health : Health!
    private var bossnode : BossNode!
    private var mWorld: SKNode!
    private var mUI: SKNode!
    private var mScene : SKScene!
    private var bossposition : CGPoint!
    
    init(name : String, scene : SKScene, UI : SKNode, world : SKNode, position : CGPoint)
    {
        super.init()
        
        self.name = name
        self.mScene = scene
        self.mUI = UI
        self.mWorld = world
        self.bossposition = position
        bossnode = BossNode(name: name, mBoss: self)
        health = Health(name: name, UIsize: mScene.size)
    }
    
    func add2Scene(){
        bossnode.position = CGPointMake(bossposition.x, bossposition.y + bossnode.size.height / 2)
        mWorld.addChild(bossnode)
        mUI.addChild(health.healthbar)
        mUI.addChild(health.healthframe)
    }
    
    func shot(arrow : Arrow)->Bool
    {
        print("shoot boss")
        self.health.decreaseHealth(Float(arrow.getDamage()))
        arrow.stop()
        
        return true;
    }
}

private class Health {
    var totalHealth : Float!
    var currentHealth : Float!
    var healthbar: SKShapeNode!
    var healthframe:SKSpriteNode!
    
    init(name : String, UIsize : CGSize)
    {
        if(name == "firstboss")
        {
            totalHealth = 100
            currentHealth = 100
            
            //init healthbar frame
            let healthframetexture = SKTexture(imageNamed: HealthBarFrame)
            let size = CGSizeMake(280, 40)
            healthframe = SKSpriteNode(texture: healthframetexture, color: SKColor.clearColor(), size: size)
            healthframe.position = CGPointMake(UIsize.width / 2, UIsize.height - healthframe.size.height)
            
            //init healthbar
            healthbar = SKShapeNode(rect: CGRectMake(0, 0, 230, 13))
            healthbar.fillColor = SKColor.greenColor()
            healthbar.lineWidth = 0
            healthbar.position = CGPointMake(UIsize.width / 2 - healthbar.frame.width / 2, UIsize.height - healthframe.size.height - healthbar.frame.height * 0.7)
        }
        
    }
    
    private func addHealth(val : Float)
    {
        currentHealth = currentHealth + val
        currentHealth = (currentHealth < 0) ? 0 :currentHealth
        currentHealth = totalHealth < currentHealth ? totalHealth:currentHealth
        updateHealthBar()
    }
    private func decreaseHealth(val : Float)
    {
        currentHealth = currentHealth - val
        currentHealth = (currentHealth < 0) ? 0 :currentHealth
        currentHealth = totalHealth < currentHealth ? totalHealth:currentHealth
        updateHealthBar()
    }
    private func updateHealthBar()
    {
        if(currentHealth <= totalHealth * 0.3){
            healthbar.fillColor = SKColor.redColor()
        }else if(currentHealth <= totalHealth * 0.6){
            healthbar.fillColor = SKColor.orangeColor()
        }else{
            healthbar.fillColor = SKColor.greenColor()
        }
        
        let decreaseSize = SKAction.scaleXTo(CGFloat(currentHealth / totalHealth), duration: 0.25)
        healthbar.runAction(decreaseSize)
    }

    
}

private class BossNode: SKSpriteNode, Shotable {
    
    
    var bosstexture : SKTexture!
    var bosssize : CGSize!
    var mWorld : SKNode!
    var mScene : SKScene!
    var mBoss : Boss!
    init(name : String, mBoss : Boss)
    {
        self.mBoss = mBoss
        if(name == "firstboss")
        {
            bosssize = CGSizeMake(120, 130)
            bosstexture = SKTexture(imageNamed: Boss1)
        }
        
        super.init(texture: bosstexture, color: SKColor.clearColor(), size: bosssize)
        addPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func addPhysicsBody()
    {
        self.physicsBody = SKPhysicsBody(texture: bosstexture, size: bosssize)
        self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = 0x0

    }
    
    func shot(attacker: Attacker) -> Bool {
        
        if let arrow = attacker as? Arrow{
            return mBoss.shot(arrow)
        }
        return true
    }
}
