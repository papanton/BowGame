//
//  GameScene.swift
//  Test
//
//  Created by ZhangYu on 9/5/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import SpriteKit
class GameScene: SKScene, SKPhysicsContactDelegate, GameControllerObserver, Shotable{
    var startpositionOfTouch: CGPoint!
    var endpositionOfTouch: CGPoint!
    var mainmenu: StartGameScene!
    private var ground: Ground!
    var touch_disable:Bool = true
    var turns : Int = 0
    var isshooting = false

    var startViewLocation: CGFloat!
    var startAnchorLocation: CGFloat!

    
    //controller bar
    var controllBallradius : CGFloat = 30
    var controllPowerradius : CGFloat = 65
    var controllers : Controller!
    
    init(size: CGSize, mainmenu: StartGameScene) {
        super.init(size: size)
        self.mainmenu = mainmenu
        self.mainmenu.setCurrentGame(self)

        self.controllers = Controller(scene: self)
        
        initworld()
        addPlayers()
        addGround()
        addBuffs()
        addObstacle()
        gameStart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
    func initworld()
    {
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self
        addBackground()
        settingsButton()
    }
    
    
    //add Scene background picture
    func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:BackgroundImage)
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: self.frame.size)
        background.zPosition = -100;
        background.position = CGPointMake(size.width*0.5,  size.height*0.5)
        self.addChild(background)
    }
    
    
    //Function adding the two players in the scene in their respective positions
    func addPlayers()
    {
        GameController.getInstance().reset()
        var player1 = PlayerFactory.getPlayer("player1", sceneSize: size)
        player1.add2Scene(self)
        GameController.getInstance().addPlayer(player1)
        var player2 = PlayerFactory.getPlayer("player2", sceneSize: size)
        GameController.getInstance().addPlayer(player2)
        player2.add2Scene(self)
        GameController.getInstance().addGameControllerObserver(self)
    }
    
    //function adding ground object (for contact detection)
    func addGround()
    {
        let collisionframe = CGRectInset(frame, -frame.width*0.2, -frame.height*0.5)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: collisionframe)
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = CollisonHelper.ArrowMask
        Terrain(scene: self);
    }
    
    //add one Buff to Scene
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

        
    }
    
    //add one Obstacle to Scene
    func addObstacle() {
        var obstacle = Obstacle(name: "wooden board", size: CGSizeMake(40,100),damage: 10)
        obstacle.setObstaclePosition(self)
        self.addChild(obstacle)
    }
    
    override func didMoveToView(view: SKView) {
        
    
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
            
            if(self.touch_disable == true){
                for child in (self.children) {
                    if child is FlappyArrow{
                        var arrow = child as! FlappyArrow
                        arrow.flappy()
                    }
                }
                return
            }
            
            
            if(touchedNode.name == "settings"){
                let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
                view?.presentScene(mainmenu,transition: transitionType)
            }
            else if(self.turns % 2 == 1 && touchedNode.name == "controlBallLeft")
            {
//                startpositionOfTouch = controllBallleft.position
                startpositionOfTouch = controllers.controllBallleft.position
                isshooting = true
            }
            else if(self.turns % 2 == 0 && touchedNode.name == "controlBallRight")
            {
//                    startpositionOfTouch = controllBallright.position
                startpositionOfTouch = controllers.controllBallright.position
                isshooting = true
                        
            }else{
                cameraMoveStart(touch)
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch in (touches as! Set<UITouch>)
        {

            if(self.touch_disable == true){
                break
            }

            if(self.turns % 2 == 1)
            {
                controllers.bezierLayerleft1.removeFromSuperlayer()
                controllers.bezierLayerleft2.removeFromSuperlayer()
                controllers.controllBallleft.position = CGPoint(x: 100 + self.controllPowerradius - self.controllBallradius, y: 120)
            }
            if(self.turns % 2 == 0)
            {
                controllers.bezierLayerright1.removeFromSuperlayer()
                controllers.bezierLayerright2.removeFromSuperlayer()
                controllers.controllBallright.position = CGPoint(x: self.size.width - 90 - self.controllPowerradius + self.controllBallradius, y: 120)
            }
            
            //self.touch_disable = true
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)
            
            
            //endpositionOfTouch = touch.locationInNode(self)
            if(self.isshooting == true)
            {
                if(startpositionOfTouch.x == endpositionOfTouch.x && startpositionOfTouch.y == endpositionOfTouch.y)
                {
                    break
                }
                var impulse = CGVectorMake((startpositionOfTouch.x - endpositionOfTouch.x)/9, (startpositionOfTouch.y - endpositionOfTouch.y)/9)
                GameController.getInstance().currentPlayerShoot(impulse, scene: self)
                self.touch_disable = true
                ShootingAngle.getInstance().hide()
                //changeTurn()
            }
        }
    }
    
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
    {

        if(self.touch_disable == true){
            return
        }

        for touch in (touches as! Set<UITouch>)
        {
            let touchLocation = touch.locationInNode(self)
            let viewLocation = touch.locationInView(view)
            let touchedNode = self.nodeAtPoint(touchLocation)

            //setup camera location according to touch movement
            if(!self.isshooting && !self.touch_disable){
                moveCameraLocation(touch)
            }
            
            var  position = touch.locationInNode(self)
          
            if(self.isshooting == true && !self.touch_disable)
            {
                controllers.shooting(position)
            }
            
            //ShootingAngle.getInstance().hide()
            //ShootingAngle.getInstance().update(startpositionOfTouch, to: position)
            //ShootingAngle.getInstance().show(self)
        }
    }

    /*Funciton updating the angle and posiiton of the arrow during flight */
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
        for child in (self.children) {
            if child is Arrow{
                var arrow = child as! Arrow
                if arrow.update(){
                    setCameraLocation(arrow.position)
                }
            }
        }
    }
    func didBeginContact(contact: SKPhysicsContact)
    {
        //please use CollisonHelper to do the contact tasks.
        CollisonHelper.getInstance().didBeginContact(contact)
    }
    
    //add setting button to scene
    func settingsButton(){
        
        let settings = SKSpriteNode(imageNamed: InGameSettingButton )
        settings.position = CGPointMake(size.width*0.95,size.height*0.95)
        settings.name = "settings"
        settings.size = CGSize(width: 16, height: 16)
        addChild(settings)
        
    }
    
    //center the camera location to the given potin
    func setCameraLocation(location : CGPoint){
        var x = 0.5 - location.x / self.size.width
        if(x > 0.25){
            x = 0.25
        }
        if(x < -0.25){
            x = -0.25
        }
        self.anchorPoint = CGPointMake(x, 0)
    }
    func cameraMoveStart(touchLocation : UITouch){
        self.startViewLocation = touchLocation.locationInView(self.view).x
        self.startAnchorLocation = self.anchorPoint.x

    }

    func moveCameraLocation(touch : UITouch){
        
        let shiftInView = touch.locationInView(self.view).x - startViewLocation
        let shiftInAnchor = shiftInView / (UIScreen.mainScreen().bounds.width)
        var anchorPosition: CGFloat = startAnchorLocation + shiftInAnchor;
        if(anchorPosition > 0.25){
            anchorPosition = 0.25
        }else if(anchorPosition < -0.25){
            anchorPosition = -0.25
        }
        self.anchorPoint = CGPointMake(anchorPosition, 0)
    }

    
    
    //show game start information and move view to P1
    func gameStart(){
        self.touch_disable = true
        let delay = 3 * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        self.turns++
        self.showStart()
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.scaleMode = SKSceneScaleMode.AspectFill
            self.anchorPoint = CGPointMake(0.25, 0)
    
            self.touch_disable = false
        })
    }
    
    //move to game over view
    func gameOver(){

        delay(1.0) {
            let gameoverScene = GameOverScene(size: UIScreen.mainScreen().bounds.size, mainmenu: self.mainmenu)
            gameoverScene.scaleMode = self.scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            self.removeFromParent()
            self.view?.presentScene(gameoverScene,transition: transitionType)
        }
    }
    
    //display the turn information on the screen
    func showTurns(position : Int){
        var text : SKLabelNode = SKLabelNode()
        text.text = "Turn \(turns)"
        text.fontColor = SKColor.blackColor()
        text.fontSize = 65
        text.fontName = "MarkerFelt-Wide"
        if(position == 0){
            text.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
        }else if(position == 1){
            text.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.5)
        }else{
            text.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.5)
        }
        text.zPosition = 1
        self.addChild(text)
        
        let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        text.runAction(fadeout, completion: {
            text.removeFromParent()})
        if(turns % 5 == 0){
            addBuffs()
        }
    }
    
    //display the game start information
    func showStart(){
        var text : SKLabelNode = SKLabelNode()
        text.text = "Game Start!"
        text.fontColor = SKColor.blackColor()
        text.fontSize = 65
        text.fontName = "MarkerFelt-Wide"
        text.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
        text.zPosition = 1
        self.addChild(text)
        
        let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        text.runAction(fadeout, completion: {
            text.removeFromParent()
            self.showTurns(0)
        })


    }
    func turnChanged(turn : Int)
    {
        println("notified")
//        self.touch_disable = true
        
        delay(1.0){
            if(turn % 2 == 1){
                self.anchorPoint = CGPointMake(0.25, 0)
                self.showTurns(1)
            }else{
                self.anchorPoint = CGPointMake(-0.25, 0)
                self.showTurns(2)
            }
        }
        delay(1.5){
            self.touch_disable = false
            self.isshooting = false
        }
        self.turns = turn
    }
    func shot(attack :Attacker)->Bool
    {
        if let arrow = attack as? Arrow {
            arrow.stop()
            //GameController.getInstance().afterArrowDead()
        }
        return true
    }
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}