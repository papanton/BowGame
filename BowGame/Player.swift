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
    static func getPlayer(var name : String) -> Player
    {
        name = name.lowercaseString;
        if(name == "player1"){
            return Player(name: PlayerImage1)
        }
        if(name == "player2"){
            return Player(name: PlayerImage2)
        }
        return Player(name : "")
    }
}
class Player: SKSpriteNode
{
    private let mPlayerSize = CGSize(width: 50.0, height: 50.0)

    var totalHealth:Float = 100
    var currentHealth:Float = 100
    var healthbar:SKShapeNode = SKShapeNode(rect: CGRectMake(0, 0, 120, 10))
    var scalePara:Float = 1
    
    private func addPhysicsBody()
    {
        self.physicsBody =
        SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisonHelper.PlayerMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = 0x0
        
        healthbar.fillColor = SKColor.greenColor()
    
    }
    private init(name : String) {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: SKColor.clearColor(),  size: mPlayerSize)
        addPhysicsBody()
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
    func shoot(impulse: CGVector , position: CGPoint)
    {
        var bow = Bow()
        var arrow = Arrow(player: self)
        self.scene?.addChild(arrow);
//        scene.addChild(arrow)
        
        bow.shoot(impulse, arrow: arrow, scene: self.scene!, position: position)
        
        
    }
    func shot(arrow : Arrow)
    {
        self.color = randomColor()
        currentHealth -= Float(arrow.damage)
        currentHealth = currentHealth < 0 ? 0 : currentHealth
        if(currentHealth <= 30){
            healthbar.fillColor = SKColor.redColor()
        }else if(currentHealth <= 60){
            healthbar.fillColor = SKColor.orangeColor()
        }
        healthbar.xScale = CGFloat(currentHealth / totalHealth)
    }
    
    func randomCGFloat() -> CGFloat {
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
