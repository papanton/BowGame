//
//  GameOverScene.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/1/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit


class GameOverScene: SKScene {
    override func didMoveToView(view: SKView) {
        
        var text : SKLabelNode = SKLabelNode()
        text.text = "GAME OVER"
        text.fontColor = SKColor.whiteColor()
        text.fontSize = 65
        text.fontName = "BradleyHandITCTT-Bold"
        text.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
        text.zPosition = 1
        self.addChild(text)

        
        let returnButton = SKSpriteNode(imageNamed: "Mainmenu" )
        returnButton.position = CGPointMake(size.width/2,size.height*0.20 )
        returnButton.name = "mainmenu"
        

        self.addChild(returnButton)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if(touchedNode.name == "mainmenu"){
            let settingsScene = StartGameScene(size: UIScreen.mainScreen().bounds.size)
            settingsScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(settingsScene,transition: transitionType)
        }
    }

}
