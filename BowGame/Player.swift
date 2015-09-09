//
//  Player.swift
//  Test
//
//  Created by ZhangYu on 9/7/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import UIKit
import SpriteKit
class PlayerFactory{
    static func getPlayer() -> Player
    {
        return Player()
    }
}
class Player: SKSpriteNode
{
    var totalHealth:Float = 100
    var currentHealth:Float = 100
    var healthbar:SKShapeNode = SKShapeNode(rect: CGRectMake(0, 0, 120, 10))
    var scalePara:Float = 1
    private init() {
        let spriteColor = SKColor.blackColor()
        let spriteSize = CGSize(width: 50.0, height: 50.0)
        let texture = SKTexture(imageNamed: "Player2")
        super.init(texture: texture, color: spriteColor, size: spriteSize)
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisonHelper.PlayerMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = 0x0
        
        healthbar.fillColor = SKColor.greenColor()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

 /*   required init?(coder aDecoder: NSCoder) {
        self.bow = aDecoder.decodeObjectForKey("BOW") as!  Bow
        super.init(coder: aDecoder)
    }
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.bow, forKey: "BOW")
        super.encodeWithCoder(aCoder)
    }*/
    func shoot(impulse: CGVector , scene : SKScene)
    {
        var bow = Bow()
        var arrow = Arrow()
        scene.addChild(arrow)
        bow.shoot(impulse, arrow: arrow, scene: scene)
        
    }
    func shot(damage:Float)
    {
        self.color = randomColor()
        
        //decrease player's health
        currentHealth -= damage
        currentHealth = currentHealth < 0 ? 0 : currentHealth
        if(currentHealth <= 30){
            healthbar.fillColor = SKColor.redColor()
        }else if(currentHealth <= 60){
            healthbar.fillColor = SKColor.orangeColor()
        }
        healthbar.xScale = CGFloat(currentHealth / totalHealth)
        
    }
    
    func randomCGFloat() -> CGFloat {
        println()
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    func randomColor() -> UIColor {
        let r = randomCGFloat()
        let g = randomCGFloat()
        let b = randomCGFloat()
        
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
