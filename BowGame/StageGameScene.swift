//
//  StageGameScene.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/13/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class StageGameScene: SKScene, SKPhysicsContactDelegate{
    
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

    var isshooting = false


    
    init(size: CGSize, mainmenu: StartGameScene) {
        super.init(size: size)
        self.mainmenu = mainmenu
        self.mainmenu.setCurrentGame(self)
        
        initworld()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initworld()
    {
        self.world = SKNode()
        self.UI = SKNode()
        self.addChild(world)
        self.addChild(UI)
        
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self

        addBackground()
        addGround()
        addPlayers()
        addControllers()
        addSettingButton()
        addObstacle()
        
        
        //for test
//        world.position = CGPointMake(300, 0)
        print(self.world.position.x)
        print(self.world.position.y)
        print(self.UI.position.x)
        print(self.UI.position.y)
        print(self.world.frame.size.width)
        print(self.world.frame.size.height)
        
}
    
    func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:BackgroundImage)
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: CGSizeMake(self.frame.width * 2, self.frame.height))
        background.zPosition = -100;
        background.position = CGPointMake(size.width,  size.height*0.5)
        self.world.addChild(background)
    }
    func addPlayers()
    {
        GameController.getInstance().reset()
        let player1 = PlayerFactory.getPlayer("player1", sceneSize: size)
        player1.add2Scene(self, world: self.world, UI: self.UI)
        GameController.getInstance().addPlayer(player1)
    }
    
    func addGround()
    {
        let groundTexture = SKTexture(imageNamed: GroundTexture1)
        let ground : Ground = Ground(texture: groundTexture, size: CGSizeMake(size.width * 2, size.height / 3), position: CGPointMake(0, 0))
        ground.position = CGPointMake(size.width, 0)
        self.world.addChild(ground)
        
        
    }
    
    func addControllers(){
        self.controllers = Controller(UI: self.UI)
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
                controllers.shootleft(position)
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


}
