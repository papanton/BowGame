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
    
    static func getPlayer(var name : String, sceneSize :CGSize) -> Player
    {
        var sheet = ShootAnimation.getInstance()
        name = name.lowercaseString;
        var playerNode = PlayerNode( texture: sheet.Shoot_01())
        var health = Health()
        var position : CGPoint!
        var xScale : CGFloat = 0.4
        var shootPosition : CGPoint!
        if(name == "player1"){
            health.healthbar.position = CGPointMake(sceneSize.width*0.05 , sceneSize.height * 0.8)
            health.healthframe.position = CGPointMake(sceneSize.width*0.05 , sceneSize.height * 0.8)
            playerNode.position = CGPointMake(sceneSize.width*0.15, sceneSize.height/5)
            position = CGPointMake(playerNode.position.x + 10.0,playerNode.position.y + 11.0)
            shootPosition = CGPointMake(sceneSize.width * 0.13, sceneSize.height/5)
        }
        
        if(name == "player2"){
            health.healthbar.position = CGPointMake(sceneSize.width*0.95 - health.healthbar.frame.size.width, sceneSize.height * 0.8)
            health.healthframe.position = CGPointMake(sceneSize.width*0.95 - health.healthbar.frame.size.width, sceneSize.height * 0.8)
            playerNode.position = CGPointMake((sceneSize.width*0.85), sceneSize.height/5)
            playerNode.xScale = -1.0
            position = CGPointMake(playerNode.position.x + 10.0,playerNode.position.y + 11.0)
            shootPosition = CGPointMake(sceneSize.width*0.87,sceneSize.height/5)
            xScale = -xScale
            
        }
        var player = Player(health: health, playerNode: playerNode)
        player.mShootPosition = shootPosition
        player.mBlood!.xScale = xScale
        player.mBlood!.position = position
        player.mBlood!.yScale = 0.4
        playerNode.mPlay = player
        return player
    }
}


class Player : NSObject
{
    private var mHealth:Health!
    private var mPlayerNode : PlayerNode!
    private var scalePara:Float = 1
    private var mScene: SKScene!
    private var mBlood = SKEmitterNode(fileNamed: "blood.sks")
    private var mShootPosition :CGPoint!
    private var power : Int = 0
    
    func add2Scene(scene: SKScene)
    {
        mScene = scene
        mScene.addChild(mPlayerNode)
        mHealth.add2Scene(scene)
    }
    private init(health: Health, playerNode : PlayerNode)
    {
        mHealth = health
        mPlayerNode = playerNode
    }
    func shoot(impulse: CGVector , scene : SKScene)
    {
        
        let shoot = SKAction.animateWithTextures(ShootAnimation.getInstance().Shoot(), timePerFrame: 0.04)
        mPlayerNode.runAction(shoot)
        let bow = Bow()
        let arrow = ArrowFactory.createArrow(self)
        
        delay(0.64) {
            self.mPlayerNode.scene?.addChild(arrow);
        //        scene.addChild(arrow)
            bow.shoot(impulse, arrow: arrow, scene: scene, position: self.mShootPosition)
        }
        
    }
    func shot(arrow : Arrow)->Bool
    {
        print("shoot player")
        if !arrow.isFrom(self){
            var xScale : CGFloat!
            var position : CGPoint!
            self.mHealth.getHurt(Float(arrow.getDamage()))
            bleed()
            SoundEffect.getInstance().playScream()
            arrow.stop()
            return true
        }
        return false
    }
    
    /*func shot(shotable: Shotable) {
        if let obstacle = shotable as? Obstacle {
            self.mHealth.getHurt(Float(obstacle.getDamage()))
            bleed()
            SoundEffect.getInstance().playScream()
        }
    }*/
    
    
    func healed(val : Float){
        self.mHealth.recover(val)
    }
    func powerup(val : Int){
        self.power += val
    }
    func getPower() -> Int{
        return self.power
    }
    func hurted(val : Float){
        self.mHealth.getHurt(val)
    }
    
    func isDead() -> Bool {
        
        return self.mHealth.currentHealth <= 0
    }


    func bleed()
    {
        var blood = SKEmitterNode(fileNamed: "blood.sks")
        blood!.xScale = mBlood!.xScale
        blood!.position = mBlood!.position
        blood!.yScale = mBlood!.yScale
        mPlayerNode.parent?.addChild(blood!)
        let fadeout:SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        blood!.runAction(fadeout, completion: {
            blood!.removeFromParent()
        })
        
    }
    
    /* function to delay |input| time */
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

}


private class Health
{
    var totalHealth:Float = 100
    var currentHealth:Float = 100
    var healthbar:SKShapeNode = SKShapeNode(rect: CGRectMake(0, 0, 120, 10))
    var healthframe:SKShapeNode = SKShapeNode(rect: CGRectMake(0, 0, 120, 10))
    init()
    {
        healthbar.fillColor = SKColor.greenColor()
        healthbar.lineWidth = 0
        healthframe.fillColor = SKColor.clearColor()
        healthframe.lineWidth = 3
        healthframe.strokeColor = SKColor.blackColor()
    }
    func add2Scene(scene: SKScene)
    {
        scene.addChild(healthbar)
        scene.addChild(healthframe)

    }
    private func updateHealthBar()
    {
        if(currentHealth <= 30){
            healthbar.fillColor = SKColor.redColor()
        }else if(currentHealth <= 60){
            healthbar.fillColor = SKColor.orangeColor()
        }else{
            healthbar.fillColor = SKColor.greenColor()
        }
        
        let decreaseSize = SKAction.scaleXTo(CGFloat(currentHealth / totalHealth), duration: 0.25)
        healthbar.runAction(decreaseSize)
//        healthbar.xScale = CGFloat(currentHealth / totalHealth)
    }
    private func addHealth(val : Float)
    {
        currentHealth += val
        currentHealth = (currentHealth < 0) ? 0 :currentHealth
        currentHealth = totalHealth < currentHealth ? totalHealth:currentHealth
        updateHealthBar()
    }
    func getHurt(val : Float)
    {
        addHealth(-val)
    }
    func recover(val : Float)
    {
        addHealth(val)
    }
}
        
private class PlayerNode: SKSpriteNode, Shotable
{
    private let mPlayerSize = CGSize(width: 100.0, height: 80.0)
    var mPlay : Player!
    private func addPhysicsBody()
    {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 20.0, height: 80.0), center: CGPointMake(-20, 0))
        //SKPhysicsBody(rectangleOfSize: CGSize(width: 20.0, height: 80.0))

        self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = 0x0
    
    }
    private init(texture : SKTexture?) {
      //  self.playerName = name
       // let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: SKColor.clearColor(),  size: mPlayerSize)
        addPhysicsBody()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func shot(attacker :Attacker)->Bool
    {
        if let arrow = attacker as? Arrow{
            return mPlay.shot(arrow)
        }
        return true
    }
    
 /*   required init?(coder aDecoder: NSCoder) {
        self.bow = aDecoder.decodeObjectForKey("BOW") as!  Bow
        super.init(coder: aDecoder)
    }
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.bow, forKey: "BOW")
        super.encodeWithCoder(aCoder)
    }*/
}
