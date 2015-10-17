//
//  StageGameScene.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/13/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class StageGameScene: SKScene, SKPhysicsContactDelegate, GameControllerObserver{
    
    var mainmenu: StartGameScene!

    var world : SKNode!
    var UI : SKNode!
    
    var controllBallradius : CGFloat = 30
    var controllPowerradius : CGFloat = 65
    var controllers : Controller!
    
    var touch_disable:Bool = false
    
    var startpositionOfTouch: CGPoint!
    var endpositionOfTouch: CGPoint!
    var startViewLocation: CGFloat!
    var startWorldLocation: CGFloat!
    
    var rounds : Int!

    var isshooting = false

    var boss : Boss!

    
    init(size: CGSize, mainmenu: StartGameScene) {
        super.init(size: size)
        self.mainmenu = mainmenu
        self.mainmenu.setCurrentGame(self)
        
        
        
        self.world = SKNode()
        self.UI = SKNode()
        self.addChild(world)
        self.addChild(UI)
        
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self

        initworld()
        initUI()
        
        gameStart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initworld()
    {

        //World
        addBackground()
        addGround()
        addPlayers()
        addBoss()
        addObstacle()
        addBorder()
        
    }
    
    func initUI()
    {
        //UI
        addControllers()
        addSettingButton()
        
    }
    
    func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:BackgroundImage)
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: CGSizeMake(self.frame.width * 2, self.frame.height))
        background.zPosition = -100;
        background.position = CGPointMake(size.width,  size.height*0.5)
        self.world.addChild(background)
    }
    
    func addBorder()
    {
        let texture = SKTexture()
        let leftBorder = Ground(texture: texture,size: CGSizeMake(1.0, self.size.height * 8),position: CGPointMake(0, 1.0))
        self.world.addChild(leftBorder)
        
        let rightBorder = Ground(texture: texture,size: CGSizeMake(1.0, self.size.height * 8),position: CGPointMake(self.size.width * 2, 1.0))
        self.world.addChild(rightBorder)
        
        let bottomBorder = Ground(texture: texture,size: CGSizeMake(self.size.width * 2, 1.0),position: CGPointMake(self.size.width, 0))
        self.world.addChild(bottomBorder)
        
    }
    
    
    func addPlayers()
    {
        GameController.getInstance().reset()
        let playerposition = CGPointMake(self.size.width * 2 * 0.1, self.size.height / 6)
        let player1 = PlayerFactory.getPlayer("singleplayer", sceneSize: size, playerposition: playerposition)
        player1.add2Scene(self, world: self.world, UI: self.UI)
        GameController.getInstance().addPlayer(player1)
        
        GameController.getInstance().addGameControllerObserver(self)
    }
    
    func addBoss()
    {
        let bossposition = CGPointMake(self.size.width * 2 * 0.9, self.size.height / 6)
        self.boss = Boss(name: "firstboss", scene: self, UI: self.UI, world: self.world, position: bossposition)
        boss.add2Scene()
    }
    
    func addGround()
    {
        let groundTexture = SKTexture(imageNamed: GroundTexture1)
        let ground : Ground = Ground(texture: groundTexture, size: CGSizeMake(size.width * 2, size.height / 3), position: CGPointMake(0, 0))
        ground.position = CGPointMake(size.width, 0)
        self.world.addChild(ground)
        
        
    }
    
    func addControllers(){
        self.controllers = Controller(UI: self.UI , scene: self)
        controllers.addLeftController()
        
    }
    
    //add setting button to UI
    func addSettingButton(){
        
        let settings = SKSpriteNode(imageNamed: InGameSettingButton )
        settings.position = CGPointMake(size.width*0.95,size.height*0.95)
        settings.name = "settings"
        settings.size = CGSize(width: 16, height: 16)
        self.UI.addChild(settings)
    }

    
    func addBuffs()
    {
        
    }
    
    func addObstacle()
    {
        let obstacle = Obstacle(name: "wooden board", size: CGSizeMake(40,100),damage: 10)
        obstacle.setObstaclePosition(self)
        self.world.addChild(obstacle)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)

        if(self.touch_disable == true){
            for child in (self.world.children) {
                if child is FlappyArrow{
                    let arrow = child as! FlappyArrow
                    arrow.flappy()
                }
            }
            return
        }
        
        print(touchedNode.name)
        
        if(touchedNode.name == "settings"){
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(mainmenu,transition: transitionType)
        }
        else if(touchedNode.name == "controlBallLeft")
        {
            startpositionOfTouch = controllers.controllBallleft.position
            endpositionOfTouch = controllers.controllBallleft.position
            isshooting = true
        }else{
            cameraMoveStart(touch)
        }


        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(self.touch_disable == true)
        {
            return
        }
        
        for touch in (touches)
        {
            
            let  position = touch.locationInNode(self)

            //setup camera location according to touch movement
            if(!self.isshooting && !self.touch_disable){
                if(startViewLocation != nil){
                    moveCameraLocation(touch)
                }
            }
            
            
            if(self.isshooting == true && !self.touch_disable)
            {
                self.endpositionOfTouch = position
                controllers.shootingleft(position)
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if(self.touch_disable == true){
            return
        }
        
        
        //self.touch_disable = true
        
        //endpositionOfTouch = touch.locationInNode(self)
        if(self.isshooting == true)
        {
            controllers.bezierLayerleft1.removeFromSuperlayer()
            controllers.bezierLayerleft2.removeFromSuperlayer()
            controllers.controllBallleft.position = CGPoint(x: 100 + self.controllPowerradius - self.controllBallradius, y: 120)
            
            if(startpositionOfTouch.x == endpositionOfTouch.x && startpositionOfTouch.y == endpositionOfTouch.y)
            {
                return
            }
            let impulse = CGVectorMake((startpositionOfTouch.x - endpositionOfTouch.x)/9, (startpositionOfTouch.y - endpositionOfTouch.y)/9)
            GameController.getInstance().currentPlayerShoot(impulse, scene: self)
//            self.touch_disable = true
            ShootingAngle.getInstance().hide()
            //changeTurn()
        }
    }

    /*Funciton updating the angle and posiiton of the arrow during flight */
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
        for child in (self.world.children) {
            if child is Arrow{
                let arrow = child as! Arrow
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


    //call after the arrow disappears
    func nextRound()
    {
        
    }
    
    func startGame()
    {
        
    }
    

    
    
    //center the camera location to the given potin
    func setCameraLocation(location : CGPoint)
    {
        if(location.x < size.width / 2){
            world.position = CGPointMake(0, 0)
        }
        else if(location.x > size.width + size.width / 2){
            world.position = CGPointMake(-size.width, 0)
        }
        else{
            world.position = CGPointMake(size.width / 2 - location.x, 0)
        }
        
    }
    func cameraMoveStart(touchLocation : UITouch)
    {
        self.startViewLocation = touchLocation.locationInView(self.view).x
        self.startWorldLocation = self.world.position.x
    }
    func moveCameraLocation(touch : UITouch)
    {
        let shiftInView = touch.locationInView(self.view).x - startViewLocation
        
        var worldLocation = self.startWorldLocation + shiftInView
        
        //worldLocation is in (-size.width, 0)
        if(worldLocation > 0){
            worldLocation = 0;
        }
        else if(worldLocation < -size.width){
            worldLocation = -size.width
        }
        world.position = CGPointMake(worldLocation, 0)
    }
    
    func gameStart(){
        self.touch_disable = true
        self.rounds = 1
        self.world.position = CGPointMake(-self.size.width, 0)
        
        let moveCamera = SKAction.moveTo(CGPointMake(0, 0), duration: 2)
        world.runAction(moveCamera)
        self.showStart()
        delay(3.0){
            self.touch_disable = false
        }
    }
    
    func showStart(){
        let text : SKLabelNode = SKLabelNode()
        text.text = "Game Start!"
        text.fontColor = SKColor.blackColor()
        text.fontSize = 65
        text.fontName = "MarkerFelt-Wide"
        text.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
        text.zPosition = 1
        self.addChild(text)
        
        let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 2.0)
        text.runAction(fadeout, completion: {
            text.removeFromParent()
            self.showTurns()
        })

    }

    
    
    func turnChanged(turn:Int)
    {
        print("turnChanged() called")
        
        self.rounds = turn
        delay(1.0){
            let moveCamera = SKAction.moveTo(CGPointMake(0, 0), duration: 0.5)
            self.world.runAction(moveCamera)
            self.showTurns()
        }
        delay(1.5){
            self.touch_disable = false
            self.isshooting = false
        }

    }
    
    func showTurns(){
        let text : SKLabelNode = SKLabelNode()
        text.text = "Round \(self.rounds)"
        text.fontColor = SKColor.blackColor()
        text.fontSize = 65
        text.fontName = "MarkerFelt-Wide"
        text.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        text.zPosition = 1
        self.UI.addChild(text)
        
        let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        text.runAction(fadeout, completion: {
            text.removeFromParent()})
        
    }

    
    func gameOver()
    {
        
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
