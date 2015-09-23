//
//  GameScene.swift
//  Test
//
//  Created by ZhangYu on 9/5/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import SpriteKit
class GameScene: SKScene, SKPhysicsContactDelegate{
    var startpositionOfTouch: CGPoint!
    var endpositionOfTouch: CGPoint!
    private var ground: Ground!
    var touch_disable:Bool = true
    var turns : Int = 0
    
    func initworld()
    {
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self
        addBackground()
        settingsButton()
    }
    func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:BackgroundImage)
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: self.frame.size)
        background.zPosition = -100;
        background.position = CGPointMake(size.width*0.5,  size.height*0.5)
        self.addChild(background)
    }
    /*
       Function adding the two players in the scene in their respective positions
    */
    func addPlayers()
    {
        var player1 = PlayerFactory.getPlayer("player1", sceneSize: size)
        player1.add2Scene(self)
        GameController.getInstance().addPlayer(player1)
        var player2 = PlayerFactory.getPlayer("player2", sceneSize: size)
        GameController.getInstance().addPlayer(player2)
        player2.add2Scene(self)
    }
    
    //function adding ground object (for contact detection)
    func addGround()
    {
        let groundSize = CGSizeMake(self.size.width, 1.0)
        let groundPosition = CGPointMake(self.size.width * 0.5, self.size.height * 0.13)
        self.ground = Ground(size: groundSize, position: groundPosition)
        self.addChild(self.ground)
    }
    /**
     *  function adding a random buff
     *  currently add a specific healing buff
     */
    func addBuffs()
    {
        
        var buffcount:Int = 0
        for child in (self.children) {
            if child is Buff{
                buffcount++;
            }
        }
        
        if(buffcount < 1){
            var new_buff = Buff()
            
            new_buff.add2Scene(self)
        }

//        var buff_power = Buff(name: "buff_power")
//        var buff_heal = Buff(name: "buff_heal")
        
    }
    
    func addObstacle() {
        var obstacle = Obstacle(name: "wooden board", size: CGSizeMake(40,100),damage: 10)
        obstacle.setObstaclePosition(self)
//        obstacle.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.3)
        self.addChild(obstacle)
    }
    
    override func didMoveToView(view: SKView) {
        initworld()
        addPlayers()
        addGround()
        
        addBuffs()
        addObstacle()
        changeTurn()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        /*
        Impulse vector value must be taken from the finger drag values. Depending on the magnitude of the impulse vector the duration of the arrow delay will be calculated for the animations.
        */
        for touch in (touches as! Set<UITouch>) {
            
            if(self.touch_disable == true){
                break
            }
            
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
                view?.presentScene(settingsScene,transition: transitionType)
            }
            else {
                startpositionOfTouch = touch.locationInNode(self)
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if(self.touch_disable == true){
            return
        }

        for touch: AnyObject in touches
        {
            
            endpositionOfTouch = touch.locationInNode(self)
            if(startpositionOfTouch.x == endpositionOfTouch.x && startpositionOfTouch.y == endpositionOfTouch.y)
            {
                break
            }
            var impulse = CGVectorMake((startpositionOfTouch.x - endpositionOfTouch.x)/9, (startpositionOfTouch.y - endpositionOfTouch.y)/9.3)
            GameController.getInstance().currentPlayer()?.shoot(impulse, scene: self)
            GameController.getInstance().changePlayerWithDelay(0)
            
            ShootingAngle.getInstance().hide()
            
            changeTurn()
        }
    }
    
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches{
            
            if(self.touch_disable == true){
                break
            }
            
            var  position = touch.locationInNode(self)
            ShootingAngle.getInstance().hide()
            ShootingAngle.getInstance().update(startpositionOfTouch, to: position)
            ShootingAngle.getInstance().show(self)
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
        //please use CollisonHelper to do the contact tasks.
        CollisonHelper.getInstance().didBeginContact(contact)
    }
    
    func settingsButton(){
        
        let settings = SKSpriteNode(imageNamed: InGameSettingButton )
        settings.position = CGPointMake(size.width*0.95,size.height*0.95)
        settings.name = "settings"
        settings.size = CGSize(width: 16, height: 16)
        addChild(settings)
        
    }
    
    func changeTurn(){
        self.touch_disable = true
        let delay = 2 * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.turns++
            self.showTurns()
            
            self.touch_disable = false
        })
    }

    
    //display the turn information on the screen
    func showTurns(){
        var text : SKLabelNode = SKLabelNode()
        text.text = "Turn \(self.turns)"
        text.fontColor = SKColor.blackColor()
        text.fontSize = 65
        text.fontName = "MarkerFelt-Wide"
        text.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
        text.zPosition = 1
        self.addChild(text)
        
        let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 2.0)
        text.runAction(fadeout, completion: {
            text.removeFromParent()})
        if(self.turns % 5 == 0){
            addBuffs()
        }
    }
    
    
    
    
}