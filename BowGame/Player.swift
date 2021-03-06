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
    
    static func getPlayer(var name : String, sceneSize :CGSize, playerposition : CGPoint) -> Player
    {
        let sheet = ShootAnimation.getInstance()
        name = name.lowercaseString;
        let playerNode = PlayerNode(texture: sheet.Shoot_01())
        
        var health : Health!
        var bloodposition : CGPoint!
        var xScale : CGFloat = 0.4
        var shootPosition : CGPoint!
        
        playerNode.position = CGPointMake(playerposition.x, playerposition.y + playerNode.size.height / 2 - 20)
        bloodposition = CGPointMake(playerNode.position.x + 10.0, playerNode.position.y + 11.0)

        
        if(name == "player1"){
            health = Health()
            health.healthframe.position = CGPointMake(sceneSize.width*0.05 + health.healthframe.size.width / 2 , sceneSize.height * 0.85)
            shootPosition = CGPointMake(playerNode.position.x, playerNode.position.y + playerNode.position.y / 2 - 10)
        }
        
        if(name == "player2"){
            health = Health()
            
            health.healthframe.xScale = -1
            health.healthframe.position = CGPointMake(sceneSize.width*0.95 + health.healthframe.size.width / 2, sceneSize.height * 0.85)

            playerNode.xScale = -1.0
            shootPosition = CGPointMake(playerNode.position.x, playerNode.position.y + playerNode.position.y / 2 - 10)
            xScale = -xScale
        }
        
        if(name == "singleplayer"){
            health = DummyHealth()
            shootPosition = CGPointMake(playerNode.position.x, playerNode.position.y + playerNode.position.y / 2 - 10)
        }
        
        
        let player = Player(health: health, playerNode: playerNode)
        player.mShootPosition = shootPosition
        player.mBlood!.xScale = xScale
        player.mBlood!.position = bloodposition
        player.mBlood!.yScale = 0.4
        playerNode.mPlay = player
        GameController.getInstance().addPlayer(player)
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
    private var mWorld: SKNode!
    private var mUI: SKNode!
    private var multiName:String!
    
    func getMultiName() -> String {
        return multiName
    }
    func setMultiName(name:String) {
        self.multiName = name
    }
    func add2Scene(scene: SKScene)
    {
        mScene = scene
        mScene.addChild(mPlayerNode)
        mHealth.add2Scene(scene)
    }
    func add2Scene(scene: SKScene, world: SKNode, UI: SKNode)
    {
        mScene = scene
        mWorld = world
        mUI = UI
        mWorld.addChild(mPlayerNode)
        mHealth.add2Scene(UI)
    }
    private init(health: Health, playerNode : PlayerNode)
    {
        mHealth = health
        mPlayerNode = playerNode
    }
    
    func updateAnimation(position:CGPoint) {
        let sheet = ShootAnimation.getInstance()
        let left_init = CGPointMake(mScene.frame.size.width * 0.2, mScene.frame.size.height / 3)
        let diff = left_init.x - position.x
        
        mPlayerNode.texture = sheet.getTextureByDiff(diff)
    }

    func shoot(impulse: CGVector , scene : SKScene)
    {
        
        let shoot = SKAction.animateWithTextures(ShootAnimation.getInstance().Shoot(), timePerFrame: 0.03)
        mPlayerNode.runAction(shoot)
        let bow = Bow()
        let arrow = ArrowFactory.createArrow(self)
        
        delay(0.03) {
            if(self.mWorld != nil){
                self.mWorld.addChild(arrow)
            }else{
                self.mScene.addChild(arrow)
            }
            bow.shoot(impulse, arrow: arrow, scene: scene, position: self.mShootPosition)
        }
    }
    func shot(attacker :Attacker)->Bool
    {
        if attacker.isAlive(){
            print("shoot player")
            if !attacker.isFrom(self){
                self.mHealth.getHurt(Float(attacker.getDamage()))
                bleed()
                SoundEffect.getInstance().playScream()
                attacker.stop()
                return true
            }
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
        if(self.mHealth.currentHealth <= 0) {
            SoundEffect.getInstance().playPlayerDie()
            return true
        }
        return false
    }


    func bleed()
    {
        let blood = SKEmitterNode(fileNamed: "blood.sks")
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
private class DummyHealth : Health
{
    override func add2Scene(UI: SKNode){
    }
}
        
private class Health
{
    var totalHealth:Float = 30
    var currentHealth:Float = 30
    var healthbar:SKShapeNode = SKShapeNode(rect: CGRectMake(0, 0, 170, 10))
    var healthframe:SKSpriteNode!
    
    init()
    {
        
        healthbar.fillColor = SKColor.greenColor()
        healthbar.lineWidth = 0
        
        let healthframetexture = SKTexture(imageNamed: HealthBarFrame)
        let size = CGSizeMake(210, 30)
        healthframe = SKSpriteNode(texture: healthframetexture, color: SKColor.clearColor(), size: size)
    }
    
    func add2Scene(scene: SKScene)
    {
        scene.addChild(healthbar)
        scene.addChild(healthframe)

    }
    func add2Scene(UI: SKNode){
        healthframe.addChild(healthbar)
        healthbar.position = CGPointMake(-81, -6)
//        UI.addChild(healthbar)
        UI.addChild(healthframe)
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
    private let mPlayerSize = CGSize(width: 100 * 1.5, height: 80 * 1.5)
    var mPlay : Player!
    private func addPhysicsBody()
    {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 30, height: 80), center: CGPointMake(-30, 0))
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
        return mPlay.shot(attacker)
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
