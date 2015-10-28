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
    let buttonnames = ["Single", "Multiple", "Settings", "Exit"]
    let buttonImage = ["Single" : "singleplayerbutton", "Multiple" : "multipleplayerbutton", "Settings" : "settingsbutton","Exit" : "exitbutton"]
    let buttonfuncs = ["Single": {(s:StartGameScene)->Void in s.startStage()},
        "Multiple" : {(s:StartGameScene)->Void in s.startGame()},
        //"Resume" : {(s:StartGameScene)->Void in s.resume()},
        "Settings" : {(s:StartGameScene)->Void in s.settings()},
        "Exit" : {(s:StartGameScene)->Void in exit(0)}]
    
    var textField: UITextField!
    var playerName = "test"

    var current_game : SKScene?

    var tempFlagVal = 0

    
    var alertController:UIAlertController!
    
    
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
        let button = SKSpriteNode(imageNamed: buttonImage[name]!)
        button.name = name
        button.zPosition = 2
        button.position = position
        return button
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
    func addBackground()
    {
        let background = SKSpriteNode(texture: SKTexture(imageNamed: BackgroundImage), color: UIColor.clearColor(), size: CGSizeMake(self.size.width * 2, self.size.height))
        background.position = CGPoint(x: 0.0, y: background.size.height/2)
        self.addChild(background)
    }

    override init(size: CGSize) {
        super.init(size: size)
        AppWarpHelper.sharedInstance.initializeWarp()

        addBackground()
        addButtons()
        addAlertController()
    }
    func addButtons()
    {
        var i = 1;
        let left = (size.width*0.8)
        for name in buttonnames{
            print(name)
            let top =  size.height*(1 -  0.2 * CGFloat(i))
            let position = CGPointMake(left ,  top)
            let button = createButton(name, position: position)
            addChild(button)
            print(i)
            ++i
        }
        let stick = SKSpriteNode(imageNamed: "startscenestick")
        stick.zPosition = 1
        stick.position = CGPointMake(left, size.height/2)
        addChild(stick)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startGame()
    {
        
        AppWarpHelper.sharedInstance.startGameScene = self
        
        playerName = textField.text!
        
        textField.resignFirstResponder()

        let uName:String = playerName as String
        let uNameLength = uName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if uNameLength>0
        {
            AppWarpHelper.sharedInstance.playerName = uName
            AppWarpHelper.sharedInstance.connectWithAppWarpWithUserName(uName)
        }
        
        self.view?.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        DataCenter.getInstance().setArrowItemByName("arrow")
    }
    
    func startMultiplayerGame(){
        
        textField.removeFromSuperview()

        
        let screensize = UIScreen.mainScreen().bounds.size;
        let scenesize : CGSize = CGSize(width: screensize.width, height: screensize.height)
        
        let gameScene = MutiplayerScene(size: scenesize, mainmenu: self, localPlayer: playerName, multiPlayerON: true)
        gameScene.scaleMode = SKSceneScaleMode.AspectFit
        self.view?.window?.rootViewController?.dismissViewControllerAnimated(true, completion: {})
        AppWarpHelper.sharedInstance.gameScene = gameScene
         changeScene(gameScene)

        DataCenter.getInstance().setArrowItemByName("arrow")
    }
    
    func startStage()
    {
//        let playerName = "temp"
        let screensize = UIScreen.mainScreen().bounds.size;
        let scenesize : CGSize = CGSize(width: screensize.width, height: screensize.height)
//        
//        let gameScene = StageGameScene(size: scenesize, mainmenu: self, localPlayer: playerName, multiPlayerON: false )
        
        let stageSelect = StageSelection(size: scenesize, mainmenu: self)
        
        stageSelect.scaleMode = SKSceneScaleMode.AspectFit
        textField.removeFromSuperview()
        changeScene(stageSelect)
        DataCenter.getInstance().setArrowItemByName("arrow")
    }
    
    func changeScene(scene : SKScene)
    {
        let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        view?.presentScene(scene,transition: transitionType)
    }
    override func didMoveToView(view: SKView) {
        addTextField()
        playerName = ""
        
        
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
    
    
    func addAlertController(){
         alertController = UIAlertController(title: "Connecting...",
            message: "Waiting for other player ...",
            preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Default,
            handler: {(alert: UIAlertAction!) in  AppWarpHelper.sharedInstance.disconnectFromServer()}))
    }
    
}
