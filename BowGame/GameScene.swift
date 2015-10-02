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
    var camera : SKNode!
    var mainmenu: StartGameScene!
    private var ground: Ground!
    var touch_disable:Bool = true
    var turns : Int = 0
    var controllBallleft: SKShapeNode!
    var controllPowerleft: SKShapeNode!
    var controllBallright: SKShapeNode!
    var controllPowerright: SKShapeNode!
    var controllBallradius : CGFloat = 20
    var controllPowerradius : CGFloat = 65
    
    var bezierPathleft1: UIBezierPath!
    var bezierPathleft2: UIBezierPath!
    var bezierLayerleft1 = CAShapeLayer()
    var bezierLayerleft2 = CAShapeLayer()
    
    var bezierPathright1: UIBezierPath!
    var bezierPathright2: UIBezierPath!
    var bezierLayerright1 = CAShapeLayer()
    var bezierLayerright2 = CAShapeLayer()
    
    var shootable = false
    
    init(size: CGSize, mainmenu: StartGameScene) {
        super.init(size: size)
        self.mainmenu = mainmenu
        self.mainmenu.setCurrentGame(self)
        
        controllBallleft = SKShapeNode(circleOfRadius: self.controllBallradius)
        controllBallleft.fillColor = SKColor.whiteColor()
        controllBallleft.alpha = 0.7
        controllBallleft.position = CGPoint(x: 100 + self.controllPowerradius, y: 120)
        self.addChild(controllBallleft)
        
        controllPowerleft = SKShapeNode(circleOfRadius: self.controllPowerradius)
        controllPowerleft.fillColor = SKColor.grayColor()
        controllPowerleft.alpha = 0.3
        controllPowerleft.position = CGPoint(x: 100, y: 120)
        self.addChild(controllPowerleft)
        
        
        controllBallright = SKShapeNode(circleOfRadius: self.controllBallradius)
        controllBallright.fillColor = SKColor.whiteColor()
        controllBallright.alpha = 0.7
        controllBallright.position = CGPoint(x: self.size.width - 90 - self.controllPowerradius, y: 120)
        self.addChild(controllBallright)
        
        controllPowerright = SKShapeNode(circleOfRadius: self.controllPowerradius)
        controllPowerright.fillColor = SKColor.grayColor()
        controllPowerright.alpha = 0.3
        controllPowerright.position = CGPoint(x: self.size.width - 90, y: 120)
        self.addChild(controllPowerright)
        
        bezierPathleft1 = UIBezierPath(arcCenter: CGPoint(x: controllPowerleft.position.x, y: UIScreen.mainScreen().bounds.height-controllPowerleft.position.y), radius: self.controllPowerradius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI), clockwise: true)
        bezierPathleft2 = UIBezierPath(arcCenter: CGPoint(x: controllPowerleft.position.x, y: UIScreen.mainScreen().bounds.height-controllPowerleft.position.y), radius: self.controllPowerradius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI), clockwise: false)
        bezierLayerleft1.path = bezierPathleft1.CGPath
        bezierLayerleft1.strokeColor = UIColor.redColor().CGColor
        bezierLayerleft1.fillColor = UIColor.clearColor().CGColor
        bezierLayerleft1.lineWidth = 5.0
        bezierLayerleft1.lineCap = kCALineCapRound
        bezierLayerleft2.path = bezierPathleft2.CGPath
        bezierLayerleft2.strokeColor = UIColor.redColor().CGColor
        bezierLayerleft2.fillColor = UIColor.clearColor().CGColor
        bezierLayerleft2.lineWidth = 5.0
        bezierLayerleft2.lineCap = kCALineCapRound
        
        bezierPathright1 = UIBezierPath(arcCenter: CGPoint(x: UIScreen.mainScreen().bounds.width - self.size.width + controllPowerright.position.x, y: UIScreen.mainScreen().bounds.height-controllPowerright.position.y), radius: self.controllPowerradius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI*2), clockwise: true)
        bezierPathright2 = UIBezierPath(arcCenter: CGPoint(x: UIScreen.mainScreen().bounds.width - self.size.width + controllPowerright.position.x, y: UIScreen.mainScreen().bounds.height-controllPowerright.position.y), radius: self.controllPowerradius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI*2), clockwise: false)
        bezierLayerright1.path = bezierPathright1.CGPath
        bezierLayerright1.strokeColor = UIColor.redColor().CGColor
        bezierLayerright1.fillColor = UIColor.clearColor().CGColor
        bezierLayerright1.lineWidth = 5.0
        bezierLayerright1.lineCap = kCALineCapRound
        bezierLayerright2.path = bezierPathright2.CGPath
        bezierLayerright2.strokeColor = UIColor.redColor().CGColor
        bezierLayerright2.fillColor = UIColor.clearColor().CGColor
        bezierLayerright2.lineWidth = 5.0
        bezierLayerright2.lineCap = kCALineCapRound
        
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
        GameController.getInstance().reset()
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
//        let groundSize = CGSizeMake(self.size.width, 1.0)
//        let groundPosition = CGPointMake(self.size.width * 0.5, self.size.height * 0.1)
//        replace ground by terrain
//        self.ground = Ground(size: groundSize, position: groundPosition)
//        self.addChild(self.ground)
        
        Terrain(scene: self);
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

        
    }
    
    func addObstacle() {
        var obstacle = Obstacle(name: "wooden board", size: CGSizeMake(40,100),damage: 10)
        obstacle.setObstaclePosition(self)
//        obstacle.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.3)
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
//                let settingsScene = StartGameScene(size: UIScreen.mainScreen().bounds.size)
//                settingsScene.scaleMode = scaleMode
                let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
                view?.presentScene(mainmenu,transition: transitionType)
            }else if(touchedNode.name == "camera"){
                touchedNode.position = touch.locationInNode(self)
            }
            else {
                if(self.turns % 2 == 1)
                {
                    var x = abs(touchLocation.x - controllPowerleft.position.x)
                    var y = abs(touchLocation.y - controllPowerleft.position.y)
                    if(sqrt(x*x + y*y) <= controllPowerradius)
                    {
                        shootable = true
                        startpositionOfTouch = controllBallleft.position
                    }
                }
                if(self.turns % 2 == 0)
                {
                    var x = abs(touchLocation.x - controllPowerright.position.x)
                    var y = abs(touchLocation.y - controllPowerright.position.y)
                    if(sqrt(x*x + y*y) <= controllPowerradius)
                    {
                        shootable = true
                        startpositionOfTouch = controllBallright.position
                    }
                }
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if(self.touch_disable == true){
            return
        }

        for touch: AnyObject in touches
        {
            if(self.turns % 2 == 1)
            {
                bezierLayerleft1.removeFromSuperlayer()
                bezierLayerleft2.removeFromSuperlayer()
                controllBallleft.position = CGPoint(x: 100 + self.controllPowerradius, y: 120)
            }
            if(self.turns % 2 == 0)
            {
                bezierLayerright1.removeFromSuperlayer()
                bezierLayerright2.removeFromSuperlayer()
                controllBallright.position = CGPoint(x: self.size.width - 90 - self.controllPowerradius, y: 120)
            }
            
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)
            
            
            //endpositionOfTouch = touch.locationInNode(self)
            if(self.shootable == true)
            {
                if(startpositionOfTouch.x == endpositionOfTouch.x && startpositionOfTouch.y == endpositionOfTouch.y)
                {
                    break
                }
                var impulse = CGVectorMake((startpositionOfTouch.x - endpositionOfTouch.x)/9, (startpositionOfTouch.y - endpositionOfTouch.y)/9)
                GameController.getInstance().currentPlayer()?.shoot(impulse, scene: self)
                GameController.getInstance().changePlayerWithDelay(0)
            
                ShootingAngle.getInstance().hide()
            
                changeTurn()
                self.shootable = false
            }
        }
    }
    
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches{
            
            if(self.touch_disable == true){
                break
            }
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)

            //setup camera location according to touch movement
            if(!self.shootable){
                setCameraLocation(touchLocation)
            }
            
            var  position = touch.locationInNode(self)
          
            if(self.shootable == true)
            {
                if(self.turns%2==0)
                {
                    //player on the right
                    var x1 = abs(position.x - controllBallright.position.x)
                    var y1 = abs(position.y - controllBallright.position.y)
                    var x2 = abs(position.x - controllPowerright.position.x)
                    var y2 = abs(position.y - controllPowerright.position.y)
                    if((sqrt(x1*x1 + y1*y1) <= controllBallradius) && (sqrt(x2*x2 + y2*y2) <= controllPowerradius))
                    {
                        endpositionOfTouch = position
                        bezierLayerright1.removeFromSuperlayer()
                        bezierLayerright2.removeFromSuperlayer()
                        bezierLayerright1.strokeEnd = (position.x-controllPowerright.position.x+controllPowerradius) / (controllPowerradius * 2)
                        bezierLayerright2.strokeEnd = (position.x - controllPowerright.position.x+controllPowerradius) / (controllPowerradius * 2)
                        self.view!.layer.addSublayer(bezierLayerright1)
                        self.view!.layer.addSublayer(bezierLayerright2)
                        controllBallright.removeFromParent()
                        controllBallright.position = position
                        self.addChild(controllBallright)
                    }
                }
                if(self.turns%2==1)
                {
                    //player on the left
                    var x1 = abs(position.x - controllBallleft.position.x)
                    var y1 = abs(position.y - controllBallleft.position.y)
                    var x2 = abs(position.x - controllPowerleft.position.x)
                    var y2 = abs(position.y - controllPowerleft.position.y)
                    if((sqrt(x1*x1 + y1*y1) <= controllBallradius) && (sqrt(x2*x2 + y2*y2) <= controllPowerradius))
                    {
                        endpositionOfTouch = position
                        bezierLayerleft1.removeFromSuperlayer()
                        bezierLayerleft2.removeFromSuperlayer()
                        bezierLayerleft1.strokeEnd = (controllPowerleft.position.x + controllPowerradius - position.x) / (controllPowerradius * 2)
                        bezierLayerleft2.strokeEnd = (controllPowerleft.position.x + controllPowerradius - position.x) / (controllPowerradius * 2)
                        self.view!.layer.addSublayer(bezierLayerleft1)
                        self.view!.layer.addSublayer(bezierLayerleft2)
                        controllBallleft.removeFromParent()
                        controllBallleft.position = position
                        self.addChild(controllBallleft)
                    }
                }
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
                arrow.update()
                setCameraLocation(arrow.position)
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
        let gameoverScene = GameOverScene(size: UIScreen.mainScreen().bounds.size, mainmenu: self.mainmenu)
        gameoverScene.scaleMode = scaleMode
        let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        self.removeFromParent()
        view?.presentScene(gameoverScene,transition: transitionType)
    }
    
    
    //called after one player shots
    func changeTurn(){
        
        self.touch_disable = true

        
        let delay = 3 * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            for child in (self.children) {
                if child is Arrow{
                    var arrow = child as! Arrow
                    arrow.removeFromParent()
                }
            }
            
            if(GameController.getInstance().currentPlayer()!.isDead()){
                self.gameOver()
                return
            }
            
            self.turns++
            if(self.turns % 2 == 1){
                //person on left
                self.anchorPoint = CGPointMake(0.25, 0)
                self.showTurns(1)
            }else{
                self.anchorPoint = CGPointMake(-0.25, 0)
                self.showTurns(2)
            }
            self.touch_disable = false
        })
    }

    
    //display the turn information on the screen
    func showTurns(position : Int){
        var text : SKLabelNode = SKLabelNode()
        text.text = "Turn \(self.turns)"
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
        if(self.turns % 5 == 0){
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
    
    
    
}