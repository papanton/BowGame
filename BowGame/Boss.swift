//
//  Boss.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/14/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class Boss : NSObject, Shotable{
    
    private var name : String!
    private var health : Health!
    private var bossnode : BossNode!
    private var mWorld: SKNode!
    private var mUI: SKNode!
    private var mScene : SKScene!
    private var bossposition : CGPoint!
    
    //current boss name choice:
    //firstboss, whiteboss2
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
        GameController.getInstance().setBoss(self)
    }
    func isDead() -> Bool {
        return health.currentHealth <= 0
    }
    func add2Scene(){
        bossnode.position = CGPointMake(bossposition.x, bossposition.y + bossnode.size.height / 2)
        mWorld.addChild(bossnode)
        mUI.addChild(health.healthbar)
        mUI.addChild(health.healthframe)
    }
    
    func shot(attacker : Attacker)->Bool
    {
        self.health.decreaseHealth(Float(attacker.getDamage()))
        print("shoot boss health = \(health.currentHealth)")
        attacker.stop()
        SoundEffect.getInstance().playBossScream()
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
            totalHealth = 60
            currentHealth = 60
        }else if(name == "whiteboss2")
        {
            totalHealth = 100
            currentHealth = 100
        }else if(name == "beeboss")
        {
            totalHealth = 80
            currentHealth = 80
        }else if(name == "fighterboss1")
        {
            totalHealth = 80
            currentHealth = 80
        }else if(name == "whiteboss")
        {
            totalHealth = 80
            currentHealth = 80
        }
        
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
        var newanimation : SKAction!
        if(name == "firstboss"){
            bosssize = CGSizeMake(224 * 0.7, 169 * 0.7)
            bosstexture = SKTexture(imageNamed: Boss1)
        }else if(name == "whiteboss2"){
            bosssize = CGSizeMake(230 * 0.6, 231 * 0.6)
            bosstexture = SKTexture(imageNamed: "whiteboss2")
        }else if(name == "beeboss"){
            bosssize = CGSizeMake(200 * 0.7, 250 * 0.7)
            bosstexture = SKTexture(imageNamed: "beeboss")
            let beetexture1 : SKTexture = SKTexture(imageNamed: "beeboss2")
            let animation = SKAction.animateWithTextures([bosstexture,beetexture1], timePerFrame: 0.2)
            newanimation = SKAction.repeatActionForever(animation)
        }else if(name == "fighterboss1"){
            bosssize = CGSizeMake(296 * 0.6, 263 * 0.6)
            bosstexture = SKTexture(imageNamed: "fighterboss1")
        }else if(name == "whiteboss"){
            bosssize = CGSizeMake(310 * 0.5, 310 * 0.5)
            bosstexture = SKTexture(imageNamed: "whiteboss")
        }
        
        super.init(texture: bosstexture, color: SKColor.clearColor(), size: bosssize)
        if(name == "beeboss")
        {
            self.runAction(newanimation)
        }
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
        if attacker.isAlive(){
            var sequence = [SKAction]()
            for i in 1...3{
                sequence.append(SKAction.rotateByAngle(CGFloat(M_PI) / CGFloat(3*i), duration: 0.1))
                sequence.append(SKAction.rotateByAngle(-CGFloat(M_PI) / CGFloat(3*i), duration: 0.1))
            }
            //let action = SKAction.repeatActionForever(SKAction.sequence(sequence))
            runAction(SKAction.sequence(sequence))
            
            return mBoss.shot(attacker)
        }
        return false
    }
}
