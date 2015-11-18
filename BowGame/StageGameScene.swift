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
    var selectionScene : StageSelection!

    init(size: CGSize, mainmenu: StartGameScene, localPlayer: String, multiPlayerON: Bool, selectionScene : StageSelection, stage:Int) {
        super.init(size: size, mainmenu: mainmenu, localPlayer: localPlayer, multiPlayerON: multiPlayerON, stage: stage)
        self.selectionScene = selectionScene
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
    override func initUI() {
        super.initUI()
        addRestartButton()
    }
    
    func addRestartButton()
    {
        let restart = SKSpriteNode(imageNamed: "restartbutton")
        restart.position = CGPointMake(size.width - 30, size.height - 30)
        restart.name = "restartbutton"
        restart.size = CGSize(width: 30, height: 30)
        self.UI.addChild(restart)
    }

    //init environment of the game world
    //specific in each stage scene
    override func addObstacle() {}
    override func addBackground() {}
    func addBoss(){}
    //func addBlackHole() {}
    //func addCanon() {}

    
    override func addPlayers()
    {
        let playerposition = CGPointMake(self.size.width * 2 * 0.1, self.size.height / 6)
        let player1 = PlayerFactory.getPlayer("singleplayer", sceneSize: size, playerposition: playerposition)
        player1.add2Scene(self, world: self.world, UI: self.UI)
    }
    
    //init ui controllers
    override func addControllers(){
        self.controllers = Controller(UI: self.UI, world: self.world, scene: self)
        controllers.initLeftController()
    }
    override func controllerShoot(position : CGPoint)
    {
        controllers.moveLeftController(position)
    }
    override func controllerOnTouchEnded()
    {
        //leftControllerOnTouchEnded()
        controllers.resetLeftController()
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
    
    override func backToPreviousScene() {
        let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        self.soundEffect?.stopBMG()
        view?.presentScene(selectionScene,transition: transitionType)
    }
}
