//
//  StageSelection.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/23/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class StageSelection: SKScene {
    
    var mainmenu: StartGameScene!
    var dataFilePath: String!
    let stagesLocked = true //for testing
    var currentStage: Int!

    let buttonfuncs = [
        "back": {(s:StageSelection)->Void in s.backToMainMenu()},
        "stage1": {(s:StageSelection)->Void in s.goStageOne()},
        "stage2": {(s:StageSelection)->Void in s.goStageTwo()},
        "stage3": {(s:StageSelection)->Void in s.goStageThree()},
        "stage4": {(s:StageSelection)->Void in s.goStageFour()},
        "stage5": {(s:StageSelection)->Void in s.goStageFive()},
        "stage6": {(s:StageSelection)->Void in s.goStageSix()},
        "stage7": {(s:StageSelection)->Void in s.goStageSeven()},
        "stage8": {(s:StageSelection)->Void in s.goStageEight()},
        "test": {(s:StageSelection)->Void in s.goTestStage()},
    ]
    
    let playerName = "temp"
    let screensize = UIScreen.mainScreen().bounds.size;
    let scenesize : CGSize = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height)
    
    init(size: CGSize, mainmenu : StartGameScene)
    {
        super.init(size : size)
        self.mainmenu = mainmenu
        
        addBackground()
        addBackButton()
        addSelections()
        currentStage = readStageProgress()
        if currentStage < 1 {
        //first time playing
            currentStage = 1
        }
        print (currentStage)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    //add background for stage selection
    func addBackground()
    {
        let background = SKSpriteNode(texture: SKTexture(imageNamed: "snowbg"), color: UIColor.clearColor(), size: CGSizeMake(self.size.width * 2, self.size.height))
        background.position = CGPoint(x: 0.0, y: background.size.height/2)
        self.addChild(background)
    }
    
    //add back button to return the main menu
    func addBackButton()
    {
        let back = SKSpriteNode(texture: SKTexture(imageNamed: "backbutton"), color: UIColor.clearColor(), size: CGSizeMake(30, 30))
        back.position = CGPointMake(30, self.size.height - 30)
        back.name = "back"
        back.zPosition = 2
        self.addChild(back)
    }
    
    //add selections to enter a stage
    func addSelections()
    {
        let currentStage = readStageProgress()
        
        let stage1 = SKSpriteNode(texture: SKTexture(imageNamed: "stage1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage1.alpha = 0.5
        stage1.name = "stage1"
        
        let stage2 = SKSpriteNode(texture: SKTexture(imageNamed: "stage1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage2.alpha = 0.5
        stage2.name = "stage2"
        
        let stage3 = SKSpriteNode(texture: SKTexture(imageNamed: "stage1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage3.name = "stage3"
        stage3.alpha = 0.5

        let stage4 = SKSpriteNode(texture: SKTexture(imageNamed: "stage1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage4.name = "stage4"
        stage4.alpha = 0.5

        let stage5 = SKSpriteNode(texture: SKTexture(imageNamed: "stage1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage5.name = "stage5"
        stage5.alpha = 0.5

        let stage6 = SKSpriteNode(texture: SKTexture(imageNamed: "stage1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage6.name = "stage6"
        stage6.alpha = 0.5

        let stage7 = SKSpriteNode(texture: SKTexture(imageNamed: "stage1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage7.name = "stage7"
        stage7.alpha = 0.5

        
        let stage8 = SKSpriteNode(texture: SKTexture(imageNamed: "stage1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage8.name = "stage8"
        stage8.alpha = 0.5


        let test = SKSpriteNode(texture: SKTexture(imageNamed: "stage1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        test.name = "test"
        test.alpha = 0.5
        
        
        
        let stages = [stage1,stage2,stage3,stage4,stage5,stage6,stage7,stage8,test]
        
        for (index, stage) in stages.enumerate() {
            
            if (index <= currentStage && stagesLocked) {
                stage.alpha = 1
            }
        }
        var i = 1.0
        var offset : CGFloat = 5
        
        for button in stages{
            offset = offset * -1
            button.position = CGPointMake((button.size.width + 15) * CGFloat(i), self.size.height * 0.2 + offset)
            button.zPosition = 2
            self.addChild(button)
            i = i + 1
        }
    }
    
    //back to the Main Menu when press back button
    func backToMainMenu()
    {
        AppWarpHelper.sharedInstance.disconnectFromServer()
        let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        view?.presentScene(self.mainmenu,transition: transitionType)
        self.removeFromParent()
    }
    
    //functions go to correspoding stages
    func goStageOne()
    {
        
        if currentStage >= 1 || !stagesLocked {
        print("select stage 1")
        let gameScene = StageOne(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self)
        changeScene(gameScene)
        }
    }
    func goStageTwo()
    {
        
        if currentStage >= 2 || !stagesLocked {

        print("select stage 2")
        let gameScene = StageTwo(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self)
        changeScene(gameScene)
        }
    }
    func goStageThree()
    {
        
        if currentStage >= 3 || !stagesLocked {

        print("select stage 3")
        let gameScene = StageThree(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self)
        changeScene(gameScene)
        }
    }
    func goStageFour()
    {
        
        if currentStage >= 4 || !stagesLocked {

        print("select stage 4")
        let gameScene = StageFour(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self)
        changeScene(gameScene)
        }
    }
    func goStageFive()
    {
        if currentStage >= 5  || !stagesLocked {
        print("select stage 5")
        let gameScene = StageFive(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self)
        changeScene(gameScene)
        }
    }
    func goStageSix()
    {
        if currentStage >= 6 || !stagesLocked {

        print("select stage 6")
        let gameScene = StageSix(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self)
        changeScene(gameScene)
        }
    }
    func goStageSeven()
    {
        if currentStage >= 7 || !stagesLocked  {

        print("select stage 7")
        let gameScene = StageSeven(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self)
        changeScene(gameScene)
        }
    }
    func goStageEight()
    {
        if currentStage >= 8 || !stagesLocked {

        print("select stage 8")
        let gameScene = StageEight(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self)
        changeScene(gameScene)
        }
    }
    func goTestStage()
    {
        print("select test stage")
        let playerName = "temp"
        let screensize = UIScreen.mainScreen().bounds.size;
        let scenesize : CGSize = CGSize(width: screensize.width, height: screensize.height)
        let gameScene = TestScene(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self)
        
        changeScene(gameScene)
    }
    
    
    //select stages by touch begin
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if (touchedNode.name != nil){
            buttonfuncs[touchedNode.name!]?(self)
        }
    }
    
    
    //define transition type to change scene
    func changeScene(scene : SKScene)
    {
        let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        view?.presentScene(scene,transition: transitionType)
    }

    
    func readStageProgress() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        let stage = defaults.integerForKey("stageKey")
        
        return stage
    }
    
    
    
    
}
