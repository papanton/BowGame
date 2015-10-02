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
    var buttonfuncs = ["Start" : {(s:StartGameScene)->Void in s.startGame()},
        "Resume" : {(s:StartGameScene)->Void in s.resume()},
        "Settings" : {(s:StartGameScene)->Void in s.settings()},
        "Quit" : {(s:StartGameScene)->Void in exit(0)}]
    func createButton(name : String, position : CGPoint)->SKNode
    {
        var text : SKLabelNode = SKLabelNode()
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
        var vc = view?.window!.rootViewController!
        vc?.presentViewController(EquipmentViewController(), animated: true, completion: nil)
    }
    func resume()
    {
        
    }
    func startGame()
    {
        changeScene(GameScene(size: size))
    }
    func changeScene(scene : SKScene)
    {
        scene.scaleMode = scaleMode
        let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        view?.presentScene(scene,transition: transitionType)
    }
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.whiteColor()
        var i = 1;
        for name in buttonfuncs.keys{
            var left = (size.width*0.4)
            var top =  size.height*CGFloat(1.0-0.2*CGFloat(i))
            var position = CGPointMake(left ,  top)
            var button = createButton(name, position: position)
            addChild(button)
            ++i
        }
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        buttonfuncs[touchedNode.name!]?(self)
    }
}
