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
    
    var current_game : SKScene?

    override init(size: CGSize) {
        super.init(size: size)
        addButtons()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addButtons(){
        let startGameButton = SKSpriteNode(imageNamed: StartButtonImage)
        startGameButton.position = CGPointMake(size.width/2,size.height*0.80 )
        startGameButton.name = "startgame"
        
        let resumeButton = SKSpriteNode(imageNamed: ResumeButtonImage )
        resumeButton.position = CGPointMake(size.width/2,size.height*0.60 )
        resumeButton.name = "resumegame"
        
        let settingsButton = SKSpriteNode(imageNamed: SettingsButton)
        settingsButton.position = CGPointMake(size.width/2,size.height*0.40 )
        settingsButton.name = "settings"
        
        let quitButton = SKSpriteNode(imageNamed: QuitButtonImage )
        quitButton.position = CGPointMake(size.width/2,size.height*0.20 )
        quitButton.name = "quit"
        
        
        addChild(startGameButton)
        addChild(settingsButton)
        addChild(quitButton)
        addChild(resumeButton)
    }
    
    override func didMoveToView(view: SKView) {
        /*let startGameButton = SKSpriteNode(color: UIColor.orangeColor(),size: CGSize(width: 500,height: 500))
        NSLog("Adding button")*/
        

        
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if(touchedNode.name == "startgame"){
            var screensize = UIScreen.mainScreen().bounds.size;
            var scenesize : CGSize = CGSize(width: screensize.width * 2, height: screensize.height)
            let gameScene = GameScene(size: scenesize, mainmenu: self)
            
            gameScene.scaleMode = SKSceneScaleMode.AspectFit
            
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(gameScene,transition: transitionType)
            
        }else if(touchedNode.name == "resumegame"){
            
            if(current_game != nil){
                let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
                view?.presentScene(self.current_game,transition: transitionType)
            }
            
        }
        
        else if(touchedNode.name == "settings") {
            
            //let gameScene = MultiPlayerActions
        }

        if(touchedNode.name == "quit"){
            exit(0)
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
