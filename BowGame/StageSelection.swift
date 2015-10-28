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
    
    let buttonfuncs = [
        "back": {(s:StageSelection)->Void in s.backToMainMenu()},
        "stage1": {(s:StageSelection)->Void in s.goStageOne()},
        "stage2": {(s:StageSelection)->Void in s.goStageTwo()},
        "stage3": {(s:StageSelection)->Void in s.goStageThree()},
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
        let stage1 = SKSpriteNode(texture: SKTexture(imageNamed: "stage1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage1.name = "stage1"
        let stage2 = SKSpriteNode(texture: SKTexture(imageNamed: "stage1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage2.name = "stage2"
        let stage3 = SKSpriteNode(texture: SKTexture(imageNamed: "stage1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage3.name = "stage3"
        let test = SKSpriteNode(texture: SKTexture(imageNamed: "stage1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        test.name = "test"
        
        
        let stages = [stage1,stage2,stage3,test]
        var i = 1.0
        var offset : CGFloat = 5
        for button in stages{
            offset = offset * -1
            button.position = CGPointMake((button.size.width + 20) * CGFloat(i), self.size.height * 0.2 + offset)
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
        print("select stage 1")
        let gameScene = StageOne(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self)
        changeScene(gameScene)
    }
    func goStageTwo()
    {
        print("select stage 2")
        let gameScene = StageTwo(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self)
        changeScene(gameScene)
    }
    func goStageThree()
    {
        print("select stage 3")
        let gameScene = StageThree(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self)
        changeScene(gameScene)
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

    
    
    
    
}
