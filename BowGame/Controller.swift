//
//  Controller.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/5/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit
class Controller: NSObject {

    var controller_left: SKSpriteNode!
    var target_left: SKSpriteNode!
    var controller_right: SKSpriteNode!
    var target_right: SKSpriteNode!

    var initposition_left: CGPoint!
    var initposition_right: CGPoint!
    
    var mScene: SKScene!
    var mUI: SKNode!
    var mWorld: SKNode!
    
    init(UI: SKNode, world : SKNode, scene : SKScene)
    {
        super.init()
        self.mScene = scene
        self.mUI = UI
        self.mWorld = world;
    }
    
    func initLeftController()
    {
        self.initposition_left = CGPointMake(mScene.frame.size.width * 0.30, mScene.frame.size.height / 2.85)
        controller_left = SKSpriteNode(texture: SKTexture(imageNamed: "controller"), color: UIColor.clearColor(), size: CGSizeMake(45, 45))
        controller_left.name = "controller_left"
        controller_left.position = initposition_left
        target_left = SKSpriteNode(texture: SKTexture(imageNamed: "target"), color: UIColor.clearColor(), size: CGSizeMake(40, 40))
        target_left.name = "target_left"
        target_left.position = initposition_left
        
        self.mWorld.addChild(controller_left)
    }
    
    func initRightController()
    {
        self.initposition_right = CGPointMake(mScene.frame.size.width * 1.90, mScene.frame.size.height / 2.85)
        controller_right = SKSpriteNode(texture: SKTexture(imageNamed: "controller"), color: UIColor.clearColor(), size: CGSizeMake(45, 45))
        controller_right.name = "controller_right"
        controller_right.position = initposition_right
        
        target_right = SKSpriteNode(texture: SKTexture(imageNamed: "target"), color: UIColor.clearColor(), size: CGSizeMake(45, 45))
        target_right.name = "target_right"
        target_right.position = initposition_right
        
        self.mWorld.addChild(controller_right)
    }
    
    func resetLeftController()
    {
        self.controller_left.position = initposition_left
        self.target_left.position = initposition_left
        self.target_left.removeFromParent()
    }
    func resetRightController()
    {
        self.controller_right.position = initposition_right
        self.target_right.position = initposition_right
        self.target_right.removeFromParent()
    }
    
    func startLeftMovement()
    {
        self.mWorld.addChild(target_left)
    }
    func startRightMovement()
    {
        self.mWorld.addChild(target_right)
    }
    
    func moveLeftController(touchlocation : CGPoint)
    {
        self.controller_left.position = touchlocation
        let dif_x = initposition_left.x - touchlocation.x
        let dif_y = initposition_left.y - touchlocation.y
        self.target_left.position = CGPointMake(initposition_left.x + dif_x, initposition_left.y + dif_y)
    }
    func moveRightController(touchlocation : CGPoint)
    {
        self.controller_right.position = touchlocation
        let dif_x = initposition_right.x - touchlocation.x
        let dif_y = initposition_right.y - touchlocation.y
        self.target_right.position = CGPointMake(initposition_right.x + dif_x, initposition_right.y + dif_y)
    }
    
    func getLeftImpulse()->CGVector
    {
        let impulse = CGVectorMake((initposition_left.x - controller_left.position.x) / 9, (initposition_left.y - controller_left.position.y) / 9)
        return impulse
    }
    func getRightUmpulse()->CGVector
    {
        let impulse = CGVectorMake((initposition_right.x - controller_right.position.x) / 9, (initposition_right.y - controller_right.position.y) / 9)
        return impulse
    }

}
