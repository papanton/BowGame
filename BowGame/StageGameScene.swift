//
//  StageGameScene.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/13/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class StageGameScene: GameScene{
    
    var boss : Boss!


    override init(size: CGSize, mainmenu: StartGameScene, localPlayer: String, multiPlayerON: Bool) {
        super.init(size: size, mainmenu:mainmenu, localPlayer: localPlayer, multiPlayerON: multiPlayerON)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func initworld()
    {
        //World
        super.initworld()
        addBoss()
    }
    //init environment of the game world
    //specific in each stage scene
    override func addObstacle() {}
    override func addBackground() {}
    func addBoss(){}
    func addBlackHole() {}
    func addCanon() {}

    
    override func addPlayers()
    {
        let playerposition = CGPointMake(self.size.width * 2 * 0.1, self.size.height / 6)
        let player1 = PlayerFactory.getPlayer("singleplayer", sceneSize: size, playerposition: playerposition)
        player1.add2Scene(self, world: self.world, UI: self.UI)
    }
    
    //init ui controllers
    override func addControllers(){
        self.controllers = Controller(UI: self.UI , scene: self)
        controllers.addLeftController()
        
    }
    override func controllerShoot(position : CGPoint)
    {
        controllers.shootingleft(position)
    }
    override func controllerOnTouchEnded()
    {
        leftControllerOnTouchEnded()
    }
/*    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
        print(isFirstResponder())
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
        }
        else if(touchedNode.name == "arrowPanel") {
            let panel:ArrowPanel = (touchedNode as? ArrowPanel)!
            if (panel.expanded) {
                panel.resume()
            } else {
                panel.expand()
            }
        } else if(touchedNode.name == "arrowCell") {
            let arrow:ArrowCell = (touchedNode as? ArrowCell)!
            if (arrow.selected == false) {
                arrow.selected = true
                
                for cell in panel.cells {
                    if (!cell.isEqual(arrow)) {
                        cell.selected = false
                    }
                }
            }
            if (panel.expanded) {
                panel.resume()
            }
        }
        else{
            cameraMoveStart(touch)
        }


        
    }
*/
/*    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        
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

            self.touch_disable = true
            ShootingAngle.getInstance().hide()
        }
    }
*/
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
    

    override func turnChanged(turn:Int)
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
}
