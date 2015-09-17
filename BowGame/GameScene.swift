//
//  GameScene.swift
//  Test
//
//  Created by ZhangYu on 9/5/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import SpriteKit
class GameScene: SKScene, SKPhysicsContactDelegate{
    private var player1 : Player!
    private var player2 : Player!
    private var playerTurn:Int = 1 /* variable determining whose turn is to play.  */
    var startpositionOfTouch: CGPoint!
    var endpositionOfTouch: CGPoint!
    var lineNode = SKShapeNode()
    var linerow = SKShapeNode()
    var linecol = SKShapeNode()
    let anglelabel = SKLabelNode(fontNamed:"Chalkduster")
    private var ground: Ground!
    
    func initworld()
    {
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self
        let backgroundTexture =  SKTexture(imageNamed:BackgroundImage)
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: self.frame.size)
        background.zPosition = -100;
        background.position = CGPointMake(size.width*0.5,  size.height*0.5)
        self.addChild(background)
        settingsButton()
    }
    
    /*
    Function adding the two players in the scene in their respective positions
    */
    func addPlayers()
    {
        player1 = PlayerFactory.getPlayer("player1", size: size)
        player1.add2Scene(self)
        player2 = PlayerFactory.getPlayer("player2", size: size)
        player2.add2Scene(self)
    }
    
    //function adding ground object (for contact detection)
    func addGround() {
        let groundSize = CGSizeMake(self.size.width, 1.0)
        let groundPosition = CGPointMake(self.size.width * 0.5, self.size.height * 0.1)
        self.ground = Ground(size: groundSize, position: groundPosition)
        
        self.addChild(self.ground)
    }
    
    
    override func didMoveToView(view: SKView) {
        initworld()
        addPlayers()
        addGround()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        /*
        Impulse vector value must be taken from the finger drag values. Depending on the magnitude of the impulse vector the duration of the arrow delay will be calculated for the animations.
        */
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
                    startpositionOfTouch = touch.locationInNode(self)
                }
                if (playerTurn == 2){
                    startpositionOfTouch = touch.locationInNode(self)
                }
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches
        {
            endpositionOfTouch = touch.locationInNode(self)
            if(startpositionOfTouch.x == endpositionOfTouch.x && startpositionOfTouch.y == endpositionOfTouch.y)
            {
                break
            }
            if (playerTurn == 1){
                var impulseVector1 = CGVectorMake((startpositionOfTouch.x - endpositionOfTouch.x)/9, (startpositionOfTouch.y - endpositionOfTouch.y)/9.3)
                    self.player1.shoot(impulseVector1, scene: self.scene!, position: CGPointMake(self.size.width * 0.13, self.size.height/5))
                    self.arrowLandDelay(2)
            }
            if (playerTurn == 2){
                var impulseVector2 =  CGVectorMake((startpositionOfTouch.x - endpositionOfTouch.x)/9, (startpositionOfTouch.y - endpositionOfTouch.y)/9.3)
                    self.player2.shoot(impulseVector2, scene: self.scene!, position: CGPointMake(self.size.width*0.87,self.size.height/5))
                    self.arrowLandDelay(1)
            }
            lineNode.removeFromParent()
            linerow.removeFromParent()
            linecol.removeFromParent()
            anglelabel.removeFromParent()
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches
        {
            var  position = touch.locationInNode(self)
            
            lineNode.removeFromParent()
            linerow.removeFromParent()
            linecol.removeFromParent()
            
            var pathToDraw = CGPathCreateMutable()
            CGPathMoveToPoint(pathToDraw, nil, startpositionOfTouch.x, startpositionOfTouch.y)
            CGPathAddLineToPoint(pathToDraw, nil, position.x, position.y)
            
            var pathToDrawrow = CGPathCreateMutable()
            CGPathMoveToPoint(pathToDrawrow, nil, startpositionOfTouch.x, startpositionOfTouch.y)
            CGPathAddLineToPoint(pathToDrawrow, nil, position.x, startpositionOfTouch.y)
            
            var pathToDrawcol = CGPathCreateMutable()
            CGPathMoveToPoint(pathToDrawcol, nil, startpositionOfTouch.x, startpositionOfTouch.y)
            CGPathAddLineToPoint(pathToDrawcol, nil, startpositionOfTouch.x, position.y)
            
            
            linerow.path = pathToDrawrow
            linerow.lineWidth = 2.0
            linerow.strokeColor = UIColor.grayColor()
            linerow.alpha = 0.1
            self.addChild(linerow)
            
            linecol.path = pathToDrawcol
            linecol.lineWidth = 2.0
            linecol.strokeColor = UIColor.grayColor()
            linecol.alpha = 0.1
            self.addChild(linecol)
            
            lineNode.path = pathToDraw
            lineNode.lineWidth = 2.0
            lineNode.strokeColor = UIColor.grayColor()
            lineNode.alpha = 0.1
            self.addChild(lineNode)
            
            
            anglelabel.removeFromParent()
            anglelabel.position = CGPoint(x: startpositionOfTouch.x , y:startpositionOfTouch.y-(startpositionOfTouch.y-position.y)/2)
            let row1 = abs(startpositionOfTouch.x - position.x)
            let col1 = abs(startpositionOfTouch.y - position.y)
            let angle =  floor((Double(atan2( row1 , col1)) / M_PI * 180*100))/100
            anglelabel.fontSize = 15
            anglelabel.text = String(stringInterpolationSegment: angle)
            self.addChild(anglelabel)
            
            
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
    
        CollisonHelper.getInstance().didBeginContact(contact)
    }
    /*Function to determine the duration of time needed to expire before next arrow is shot.  */
    func arrowLandDelay(var nextPlayer:Int){
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