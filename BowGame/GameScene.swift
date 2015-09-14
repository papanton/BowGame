//
//  GameScene.swift
//  Test
//
//  Created by ZhangYu on 9/5/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    private var player1 = PlayerFactory.getPlayer("player1")
    private var player2 = PlayerFactory.getPlayer("player2")
    private var playerTurn:Int = 1 /* variable determining whose turn is to play.  */
    var sheet = ShootAnimation()
    private var sprite_1 = SKSpriteNode()
    private var sprite_2 = SKSpriteNode()
    
    
    func initworld()
    {
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self
        let backgroundTexture =  SKTexture(imageNamed:BackgroundImage)
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: self.frame.size)
        background.zPosition = -100;
        background.position = CGPointMake(size.width*0.5,  size.height*0.5)
        
        settingsButton()
        self.addChild(background)
        
        player1.healthbar.position = CGPointMake(size.width*0.05 , size.height * 0.8)
        self.addChild(player1.healthbar)
        player2.healthbar.position = CGPointMake(size.width*0.95 - player2.healthbar.frame.size.width, size.height * 0.8)
        self.addChild(player2.healthbar)
        
        
    }
    
    /*
    Function adding the two players in the scene in their respective positions
    */
    func addPlayers()
    {
        player1.position = CGPointMake(size.width*0.15, size.height/5);
        self.addChild(player1)
        player1.hidden = true
        
        player2.position = CGPointMake((size.width*0.85), size.height/5);
        self.addChild(player2)
        player2.hidden = true
        
        
//        animation
        sprite_1 = SKSpriteNode(texture: sheet.Shoot_01())
        sprite_1.position = CGPointMake(size.width * 0.15, size.height / 5);
        sprite_1.size = CGSize(width: 100, height: 80)
        addChild(sprite_1)
        
        
        sprite_2 = SKSpriteNode(texture: sheet.Shoot_01())
        sprite_2.position = CGPointMake(size.width * 0.85, size.height / 5);
        sprite_2.size = CGSize(width: 100, height: 80)
        sprite_2.xScale = -1.0
        addChild(sprite_2)
        
    }
    override func didMoveToView(view: SKView) {
        initworld()
        addPlayers()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        /*
        Impulse vector value must be taken from the finger drag values. Depending on the magnitude of the impulse vector the duration of the arrow delay will be calculated for the animations.
        
        */
        
        
        var impulseVector =  CGVectorMake(7, 10)
        for touch in (touches as! Set<UITouch>) {
            let touch = touches.first as! UITouch
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)
            
            /*
            Checking if first touch was on settings button. Returning on main menu if so.
            */
            
            if(touchedNode.name == "settings"){
                let settingsScene = StartGameScene(size: size)
                settingsScene.scaleMode = scaleMode
                let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
                view?.presentScene(settingsScene,transition: transitionType)            }
            else {
            if (playerTurn == 1){
                self.playerTurn = 0
                
                //               animation
                var shoot = SKAction.animateWithTextures(sheet.Shoot(), timePerFrame: 0.04)
                sprite_1.runAction(shoot)
                
                delay(0.64) {
                    self.player1.shoot(impulseVector, position: CGPointMake(self.size.width * 0.13, self.size.height/5))
                    self.arrowLandDelay(2, impulse: impulseVector)
                }
            }
            if (playerTurn == 2){
                //temp for testing purposes impulseVector2.
                var impulseVector2 =  CGVectorMake(-8, 10)

                self.playerTurn = 0
                
                var shoot = SKAction.animateWithTextures(sheet.Shoot(), timePerFrame: 0.04)
                sprite_2.runAction(shoot)
                
                delay(0.64) {
                    self.player2.shoot(impulseVector2, position: CGPointMake(self.size.width*0.87,self.size.height/5))
                    self.arrowLandDelay(1, impulse: impulseVector)
                }
            }
        }
        }

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
    
   /*Funciton updating the angle and posiiton of the arrow during flight */
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
        var player: Player!
        var arrow: Arrow!
        if contact.bodyA.categoryBitMask == CollisonHelper.PlayerMask{
            player = contact.bodyA.node as! Player
            arrow = contact.bodyB.node as! Arrow
        }
        if contact.bodyB.categoryBitMask == CollisonHelper.PlayerMask{
            player = contact.bodyB.node as! Player
            arrow = contact.bodyA.node as! Arrow
        }
        if(arrow.host != player){
            player.shot(arrow)
        }
    }
    /*Function to determine the duration of time needed to expire before next arrow is shot.  */
    func arrowLandDelay(var nextPlayer:Int, impulse:CGVector){
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            self.playerTurn = nextPlayer
            // here code perfomed with delay
            
        })
        
    }
    
    
    func settingsButton(){
        
        let settings = SKSpriteNode(imageNamed: InGameSettingButton )
        settings.position = CGPointMake(size.width*0.95,size.height*0.95)
        settings.name = "settings"
        settings.size = CGSize(width: 16, height: 16)
        addChild(settings)
        
    }
}
