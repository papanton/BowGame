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
    var mainmenu : SKScene!
    var text : SKLabelNode!
    init(size: CGSize, mainmenu : SKScene, textcontent : String) {
        super.init(size: size)
        self.mainmenu = mainmenu
        
        text = SKLabelNode()
        text.text = textcontent
        text.fontColor = SKColor.whiteColor()
        text.fontSize = 65
        text.fontName = "BradleyHandITCTT-Bold"
        text.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
        text.zPosition = 1
        self.addChild(text)
        
        
        let returnButton = SKSpriteNode(imageNamed: "backbutton" )
        returnButton.position = CGPointMake(size.width/2,size.height*0.20 )
        returnButton.name = "backbutton"
        
        
        self.addChild(returnButton)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if(touchedNode.name == "backbutton"){
            mainmenu.removeFromParent()
            //let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Down, duration: 0.5)
            view?.presentScene(self.mainmenu,transition: transitionType)
        }
    }

}
