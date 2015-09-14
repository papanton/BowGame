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
    override func didMoveToView(view: SKView) {
        /*let startGameButton = SKSpriteNode(color: UIColor.orangeColor(),size: CGSize(width: 500,height: 500))
        NSLog("Adding button")*/
        let startGameButton = SKSpriteNode(imageNamed: StartButtonImage)
        startGameButton.position = CGPointMake(size.width/2,size.height*0.80 )
        startGameButton.name = "startgame"
        
        let resumeButton = SKSpriteNode(imageNamed: ResumeButtonImage )
        resumeButton.position = CGPointMake(size.width/2,size.height*0.60 )
        
        let settingsButton = SKSpriteNode(imageNamed: SettingsButton)
        settingsButton.position = CGPointMake(size.width/2,size.height*0.40 )

        let quitButton = SKSpriteNode(imageNamed: QuitButtonImage )
        quitButton.position = CGPointMake(size.width/2,size.height*0.20 )
        quitButton.name = "quit"


        
        
        addChild(startGameButton)
        addChild(settingsButton)
        addChild(quitButton)
        addChild(resumeButton)
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if(touchedNode.name == "startgame"){
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(gameScene,transition: transitionType)
        }

        if(touchedNode.name == "quit"){
            exit(0)
        }
       
    }
}
