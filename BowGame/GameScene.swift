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
        
    }
    
    /*
    Function adding the two players in the scene in their respective positions
    */
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
        /*
        Impulse vector value must be taken from the finger drag values. Depending on the magnitude of the impulse vector the duration of the arrow delay will be calculated for the animations.
        
        */
        
        
        var impulseVector =  CGVectorMake(8, 10)
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
            else{
                if (playerTurn == 1){
                    self.playerTurn = 0
                    player1.shoot(impulseVector, scene: self, position: CGPointMake(size.width * 0.17, size.height/5))
                    arrowLandDelay(2, impulse: impulseVector)
                    
                }
                if (playerTurn == 2){
                    //temp for testing purposes impulseVector2.
                    var impulseVector2 =  CGVectorMake(-8, 10)
                    
                    self.playerTurn = 0
                    player2.shoot(impulseVector2, scene:self, position: CGPointMake(size.width*0.82,size.height/5))
                    arrowLandDelay(1, impulse: impulseVector)
                }
            }
        }
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
