//
//  StartGameScene.swift
//  Test
//
//  Created by ZhangYu on 9/5/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import UIKit
import SpriteKit
import Darwin

class StartGameScene: SKScene {
    
    var textField: UITextField!
    let playerName = "test"

    
    let buttonnames = ["Stages", "Start", "Resume", "Settings","Quit"]
    let buttonfuncs = ["Stages": {(s:StartGameScene)->Void in s.startStage()},
        "Start" : {(s:StartGameScene)->Void in s.startGame()},
        "Resume" : {(s:StartGameScene)->Void in s.resume()},
        "Settings" : {(s:StartGameScene)->Void in s.settings()},
        "Quit" : {(s:StartGameScene)->Void in exit(0)}]
    
    var current_game : SKScene?

    func addTextField() {
        let screensize = UIScreen.mainScreen().bounds.size;
        
        textField = UITextField(frame : CGRect(x:20, y:(screensize.height/2.25), width:(screensize.width/10), height:(screensize.height/15) ))
        self.view!.addSubview(textField)
        textField.backgroundColor = UIColor.blueColor()
        textField.textAlignment = .Center
        textField.font = UIFont(name: "Helvetica Neue", size: 23)
    }

    func createButton(name : String, position : CGPoint)->SKNode
    {
        let text : SKLabelNode = SKLabelNode()
        text.name = name
        text.text = name
        text.fontColor = SKColor.blackColor()
        text.fontSize = 50
        text.fontName = "MarkerFelt-Wide"
        text.zPosition = 1
        text.position = position
        text.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        return text
    }
    func settings()
    {
        //changeScene(SettingScene(size: size))
        let vc = view?.window!.rootViewController!
        vc?.presentViewController(EquipmentViewController(), animated: true, completion: nil)
    }
    func resume()
    {
        if(current_game != nil){
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(self.current_game!,transition: transitionType)
        }
    }
    

    override init(size: CGSize) {
        super.init(size: size)
        addButtons()
        self.backgroundColor = UIColor.whiteColor()
       
    }
    func addButtons()
    {
        var i = 1;
        let left = (size.width*0.4)
        for name in buttonnames{
            print(name)
            let top =  size.height*CGFloat(1.0-0.18*CGFloat(i))
            let position = CGPointMake(left ,  top)
            let button = createButton(name, position: position)
            addChild(button)
            ++i
        }

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startGame()
    {
        let name = textField.text!
        
        textField.resignFirstResponder()

        let screensize = UIScreen.mainScreen().bounds.size;
        let scenesize : CGSize = CGSize(width: screensize.width, height: screensize.height)

        let gameScene = MutiplayerScene(size: scenesize, mainmenu: self, localPlayer: name)
        gameScene.scaleMode = SKSceneScaleMode.AspectFit
        textField.removeFromSuperview()
        AppWarpHelper.sharedInstance.gameScene = gameScene

        changeScene(gameScene)
    }
    
    func startStage()
    {
        let playerName = "temp"
        let screensize = UIScreen.mainScreen().bounds.size;
        let scenesize : CGSize = CGSize(width: screensize.width, height: screensize.height)
        
        let gameScene = StageGameScene(size: scenesize, mainmenu: self, localPlayer: playerName )
        gameScene.scaleMode = SKSceneScaleMode.AspectFit
        textField.removeFromSuperview()

        changeScene(gameScene)
    }
    
    func changeScene(scene : SKScene)
    {
        let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        view?.presentScene(scene,transition: transitionType)
    }
    override func didMoveToView(view: SKView) {
        addTextField()
        
        AppWarpHelper.sharedInstance.initializeWarp()
        AppWarpHelper.sharedInstance.startGameScene = self
        
        
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if (touchedNode.name != nil){
            buttonfuncs[touchedNode.name!]?(self)
        }

       
    }
    
    func setCurrentGame(cur : SKScene)
    {
        self.current_game = cur
    }
    
    func removeCurGame()
    {
        self.current_game = nil
    }
}
