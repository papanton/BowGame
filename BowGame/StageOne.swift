//
//  StageOne.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/23/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class StageOne: StageGameScene {
    
    var step1 : SKLabelNode!
    var step2 : SKLabelNode!
    var step3 : SKLabelNode!
    var step4 : SKLabelNode!
    var step : Int!
    
    override func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:BackgroundImage)
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: CGSizeMake(self.frame.width * 2, self.frame.height))
        background.zPosition = -100;
        background.position = CGPointMake(size.width,  size.height*0.5)
        self.world.addChild(background)
        
        initTutorial()
    }
    
    override func addGround()
    {
        let groundTexture = SKTexture(imageNamed: GroundTexture1)
        let ground : Ground = Ground(texture: groundTexture, size: CGSizeMake(size.width * 2, size.height / 3), position: CGPointMake(0, 0))
        ground.position = CGPointMake(size.width, 0)
        self.world.addChild(ground)
        
        let collisionframe = CGRectInset(frame, -frame.width*0.2, -frame.height*0.5)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: collisionframe)
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = CollisonHelper.ArrowMask
        
        self.BGM = 2
        
    }
    
    func initTutorial()
    {
        self.step = 1
        
        step1 = SKLabelNode(text: "<------ 1.Hold the Screen to Move the Camera ------->")
        step1.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
        setLabel(step1)
        self.UI.addChild(step1)
        
        step2 = SKLabelNode(text: "2.Drag Here to Shoot!")
        step2.position = CGPointMake(self.size.width * 0.2, self.size.height * 0.4)
        setLabel(step2)
        
        step3 = SKLabelNode(text: "3.Click Here to Select Another Arrow!")
        step3.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.7)
        setLabel(step3)
        
        step4 = SKLabelNode(text: "4.Try to Kill the Boss!")
        step4.position = CGPointMake(self.size.width * 1.8, self.size.height * 0.5)
        setLabel(step4)
    }
    
    private func setLabel(label : SKLabelNode)
    {
        label.fontSize = 17
        label.fontColor = SKColor.redColor()
        label.fontName = "AvenirNext-Heavy"
    }
    
    override func addBoss()
    {
        let bossposition = CGPointMake(self.size.width * 2 * 0.9, self.size.height / 6)
        self.boss = Boss(name: "firstboss", scene: self, UI: self.UI, world: self.world, position: bossposition)
        boss.add2Scene()
    }
    
    
    override func addObstacle() {
        let woodBoard = WoodBoard(size: CGSizeMake(20, 200), position: CGPointMake(self.size.width * 0.8, self.size.height/6), flag:true)
        woodBoard.add2Scene(self, world: self.world)
        let woodBoard2 = WoodBoard(size: CGSizeMake(20, 240), position: CGPointMake(self.size.width * 1.5, self.size.height/6), flag:true)
        woodBoard2.add2Scene(self, world: self.world)
    }
    
    override func addArrowPanel()
    {
        super.addArrowPanel()
        panel.setArrowNum(10, bomb: 1, flappy: 0, split: 2, ignore: 10)
    }
    
    override func restartGame() {
        let gameScene = StageOne(size: self.size, mainmenu: self.mainmenu, localPlayer: "temp", multiPlayerON: false, selectionScene : self.selectionScene, stage: self.stage)
        let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        view?.presentScene(gameScene,transition: transitionType)
        self.removeFromParent()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if(self.touch_disable == true){
            for child in (self.world.children) {
                if child is ClickObersever{
                    let co = child as! ClickObersever
                    co.onClick()
                }
            }
            return
        }
        
        print(touchedNode.name)
        
        if(touchedNode.name == "restartbutton"){
            restartGame()
        }
        else if(touchedNode.name == "back"){
            
            if multiPlayerON {
                let dataDict = NSMutableDictionary()
                dataDict.setObject(NSString(string: "true"), forKey: "QuitGame")
                dataDict.setObject(AppWarpHelper.sharedInstance.playerName, forKey: "Sender")
                
                AppWarpHelper.sharedInstance.updatePlayerDataToServer(dataDict)
            }
            AppWarpHelper.sharedInstance.disconnectFromServer()
            
            backToPreviousScene()
        }
        else if(touchedNode.name == "muteSound") {
            SoundEffect.getInstance().changeMuteSound()
            if(SoundEffect.getInstance().getMuteSound()) {
                self.muteSoundButton.texture = SKTexture(imageNamed: "muteSound")
                SoundEffect.getInstance().stopBMG()
            } else {
                self.muteSoundButton.texture = SKTexture(imageNamed: "unmuteSound")
                if(self.BGM == 1) {
                    SoundEffect.getInstance().playBGM()
                } else if(self.BGM == 2) {
                    SoundEffect.getInstance().playBGM2()
                }
            }
            
        }
        else if(touchedNode.name == "controller_left" ) {
            print("touchLeft: ")
            print(multiPlayerON)
            print(AppWarpHelper.sharedInstance.isRoomOwner)
            
            if (multiPlayerON && !AppWarpHelper.sharedInstance.isRoomOwner) {
                return
            }
            
            if(self.step == 2)
            {
                let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
                self.step2.runAction(fadeout, completion: {
                    self.step2.removeFromParent()
                    self.UI.addChild(self.step3)
                })
                self.step = self.step + 1;
            }
            
            leftControllerOnTouchBegin()
        }else if(touchedNode.name == "arrowPanel") {
            SoundEffect.getInstance().playMenuSelect()
            let panel:ArrowPanel = (touchedNode as? ArrowPanel)!
            if (panel.expanded) {
                panel.resume()
            } else {
                panel.expand()
            }
            
            
            if(self.step == 3)
            {
                let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
                self.step3.runAction(fadeout, completion: {
                    self.step3.removeFromParent()
                    self.world.addChild(self.step4)
                })
                self.step = self.step + 1;
            }
            
        }else if(touchedNode.name == "arrowCell") {
            
            let arrow:ArrowCell = (touchedNode as? ArrowCell)!
            if(arrow.mArrowNum != 0) {
                SoundEffect.getInstance().playMenuSelect()
                arrow.onSelected()
                if (arrow.mArrowPanel.expanded) {
                    arrow.mArrowPanel.switchCell(arrow.mArrowName)
                    arrow.mArrowPanel.resume()
                }
            } else {
                SoundEffect.getInstance().playSelectFault()
            }
        }else{
            if(self.step == 1)
            {
                let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
                self.step1.runAction(fadeout, completion: {
                    self.step1.removeFromParent()
                    self.world.addChild(self.step2)
                })
                self.step = self.step + 1;
            }
            
            cameraMoveStart(touch)
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
            //            if(self.step == 2){
            //                self.UI.addChild(self.step2)
            //            }else if(self.step == 3){
            //                self.UI.addChild(self.step3)
            //            }else if(self.step == 4){
            //                self.world.addChild(self.step4)
            //            }
            self.touch_disable = false
            self.isshooting = false
        }
    }
    
    
    
}
