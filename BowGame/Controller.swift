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
    var controllBallleft: SKShapeNode!
    var controllPowerleft: SKShapeNode!
    var controllBallright: SKShapeNode!
    var controllPowerright: SKShapeNode!
    var controllBallradius : CGFloat = 30
    var controllPowerradius : CGFloat = 65
    
    var bezierPathleft1: UIBezierPath!
    var bezierPathleft2: UIBezierPath!
    var bezierLayerleft1 = CAShapeLayer()
    var bezierLayerleft2 = CAShapeLayer()
    
    var bezierPathright1: UIBezierPath!
    var bezierPathright2: UIBezierPath!
    var bezierLayerright1 = CAShapeLayer()
    var bezierLayerright2 = CAShapeLayer()
    
    var controller_left: SKSpriteNode!
    var target_left: SKSpriteNode!
    var controller_right: SKSpriteNode!
    var target_right: SKSpriteNode!

    var initposition_left: CGPoint!
    var initposition_right: CGPoint!
    
    var mScene: SKScene!
    var mUI: SKNode!
    
    init(UI: SKNode, scene : SKScene)
    {
        super.init()
        self.mScene = scene
        self.mUI = UI
    }
    
    func initLeftController()
    {
        self.initposition_left = CGPointMake(mScene.frame.size.width * 0.2, mScene.frame.size.height / 3)
        controller_left = SKSpriteNode(texture: SKTexture(imageNamed: "controller"), color: UIColor.clearColor(), size: CGSizeMake(30, 30))
        controller_left.name = "controller_left"
        controller_left.position = initposition_left
        
        target_left = SKSpriteNode(texture: SKTexture(imageNamed: "target"), color: UIColor.clearColor(), size: CGSizeMake(30, 30))
        target_left.name = "target_left"
        target_left.position = initposition_left
        
        self.mUI.addChild(controller_left)
    }
    
    func initRightController()
    {
        self.initposition_right = CGPointMake(mScene.frame.size.width * 0.8, mScene.frame.size.height / 3)
        controller_right = SKSpriteNode(texture: SKTexture(imageNamed: "controller"), color: UIColor.clearColor(), size: CGSizeMake(30, 30))
        controller_right.name = "controller_right"
        controller_right.position = initposition_right
        
        target_right = SKSpriteNode(texture: SKTexture(imageNamed: "target"), color: UIColor.clearColor(), size: CGSizeMake(30, 30))
        target_right.name = "target_right"
        target_right.position = initposition_right
        
        self.mUI.addChild(controller_right)
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
        self.mUI.addChild(target_left)
    }
    func startRightMovement()
    {
        self.mUI.addChild(target_right)
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
    
//    func addLeftController()
//    {
//        controllBallleft = initControllBallleft(self.controllBallradius, powerradius: self.controllPowerradius)
//        controllPowerleft = initControllPowerleft(self.controllPowerradius)
//        initbezierleft()
//
//    }
    
//    func addRightController()
//    {
//        controllBallright = initControllBallright(self.controllBallradius, powerradius: self.controllPowerradius)
//        controllPowerright = initControllPowerright(self.controllPowerradius)
//        initbezierright()
//    }
    
    func initControllBallleft(ballradius: CGFloat, powerradius: CGFloat) -> SKShapeNode
    {
        let controllBall = SKShapeNode(circleOfRadius: ballradius)
        controllBall.fillColor = SKColor.whiteColor()
        controllBall.alpha = 0.7
        controllBall.position = CGPoint(x: 100 + powerradius - ballradius, y: 120)
        controllBall.name = "controlBallLeft"
        controllBall.zPosition = 1
        if(self.mUI != nil)
        {
            self.mUI.addChild(controllBall)
        }else{
            
            self.mScene.addChild(controllBall)
        }
        return controllBall
        
    }
    
    func initControllBallright(ballradius: CGFloat, powerradius: CGFloat) -> SKShapeNode
    {
        let controllBall = SKShapeNode(circleOfRadius: ballradius)
        controllBall.fillColor = SKColor.whiteColor()
        controllBall.alpha = 0.7
        controllBall.position = CGPoint(x: self.mScene.size.width - 90 - self.controllPowerradius + ballradius, y: 120)
        controllBall.name = "controlBallRight"
        controllBall.zPosition = 1
        if(self.mUI != nil)
        {
            self.mUI.addChild(controllBall)
        }else{
            
            self.mScene.addChild(controllBall)
        }
        return controllBall
    }
    
    func initControllPowerleft(powerradius: CGFloat) -> SKShapeNode
    {
        let controllPower = SKShapeNode(circleOfRadius: powerradius)
        controllPower.fillColor = SKColor.grayColor()
        controllPower.alpha = 0.3
        controllPower.position = CGPoint(x: 100, y: 120)
        
        if(self.mUI != nil)
        {
            self.mUI.addChild(controllPower)
        }else{
            self.mScene.addChild(controllPower)
        }
        return controllPower
    }
    
    func initControllPowerright(powerradius: CGFloat) -> SKShapeNode
    {
        let controllPower = SKShapeNode(circleOfRadius: powerradius)
        controllPower.fillColor = SKColor.grayColor()
        controllPower.alpha = 0.3
        controllPower.position = CGPoint(x: self.mScene.size.width - 90, y: 120)
        
        if(self.mUI != nil)
        {
            self.mUI.addChild(controllPower)
        }else{
            self.mScene.addChild(controllPower)
        }
        
        return controllPower
    }
    
    func initbezierleft()
    {
        bezierPathleft1 = UIBezierPath(arcCenter: CGPoint(x: controllPowerleft.position.x, y: UIScreen.mainScreen().bounds.height-controllPowerleft.position.y), radius: self.controllPowerradius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI), clockwise: true)
        bezierPathleft2 = UIBezierPath(arcCenter: CGPoint(x: controllPowerleft.position.x, y: UIScreen.mainScreen().bounds.height-controllPowerleft.position.y), radius: self.controllPowerradius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI), clockwise: false)
        bezierLayerleft1.path = bezierPathleft1.CGPath
        bezierLayerleft1.strokeColor = UIColor.redColor().CGColor
        bezierLayerleft1.fillColor = UIColor.clearColor().CGColor
        bezierLayerleft1.lineWidth = 5.0
        bezierLayerleft1.lineCap = kCALineCapRound
        bezierLayerleft2.path = bezierPathleft2.CGPath
        bezierLayerleft2.strokeColor = UIColor.redColor().CGColor
        bezierLayerleft2.fillColor = UIColor.clearColor().CGColor
        bezierLayerleft2.lineWidth = 5.0
        bezierLayerleft2.lineCap = kCALineCapRound
    }
    
    func initbezierright()
    {
        bezierPathright1 = UIBezierPath(arcCenter: CGPoint(x: UIScreen.mainScreen().bounds.width - self.mScene.size.width + controllPowerright.position.x, y: UIScreen.mainScreen().bounds.height-controllPowerright.position.y), radius: self.controllPowerradius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI*2), clockwise: true)
        bezierPathright2 = UIBezierPath(arcCenter: CGPoint(x: UIScreen.mainScreen().bounds.width - self.mScene.size.width + controllPowerright.position.x, y: UIScreen.mainScreen().bounds.height-controllPowerright.position.y), radius: self.controllPowerradius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI*2), clockwise: false)
        bezierLayerright1.path = bezierPathright1.CGPath
        bezierLayerright1.strokeColor = UIColor.redColor().CGColor
        bezierLayerright1.fillColor = UIColor.clearColor().CGColor
        bezierLayerright1.lineWidth = 5.0
        bezierLayerright1.lineCap = kCALineCapRound
        bezierLayerright2.path = bezierPathright2.CGPath
        bezierLayerright2.strokeColor = UIColor.redColor().CGColor
        bezierLayerright2.fillColor = UIColor.clearColor().CGColor
        bezierLayerright2.lineWidth = 5.0
        bezierLayerright2.lineCap = kCALineCapRound
    }
    
    func shootingleft(position : CGPoint)
    {
        let x1 = abs(position.x - controllBallleft.position.x)
        let y1 = abs(position.y - controllBallleft.position.y)
        let x2 = abs(position.x - controllPowerleft.position.x)
        let y2 = abs(position.y - controllPowerleft.position.y)
        if((sqrt(x1*x1 + y1*y1) <= controllBallradius) && (sqrt(x2*x2 + y2*y2) <= controllPowerradius))
        {
            bezierLayerleft1.removeFromSuperlayer()
            bezierLayerleft2.removeFromSuperlayer()
            bezierLayerleft1.strokeEnd = (controllPowerleft.position.x + controllPowerradius - position.x) / (controllPowerradius * 2)
            bezierLayerleft2.strokeEnd = (controllPowerleft.position.x + controllPowerradius - position.x) / (controllPowerradius * 2)
            self.mScene.view!.layer.addSublayer(bezierLayerleft1)
            self.mScene.view!.layer.addSublayer(bezierLayerleft2)
            controllBallleft.removeFromParent()
            controllBallleft.position = position
            if(self.mUI != nil){
                self.mUI.addChild(controllBallleft)
            }else{
                self.mScene.addChild(controllBallleft)
            }
        }
    }
    
    func shootingright(position : CGPoint)
    {
        let x1 = abs(position.x - controllBallright.position.x)
        let y1 = abs(position.y - controllBallright.position.y)
        let x2 = abs(position.x - controllPowerright.position.x)
        let y2 = abs(position.y - controllPowerright.position.y)
        if((sqrt(x1*x1 + y1*y1) <= controllBallradius) && (sqrt(x2*x2 + y2*y2) <= controllPowerradius))
        {
            bezierLayerright1.removeFromSuperlayer()
            bezierLayerright2.removeFromSuperlayer()
            bezierLayerright1.strokeEnd = (position.x-controllPowerright.position.x+controllPowerradius) / (controllPowerradius * 2)
            bezierLayerright2.strokeEnd = (position.x - controllPowerright.position.x+controllPowerradius) / (controllPowerradius * 2)
            self.mScene.view!.layer.addSublayer(bezierLayerright1)
            self.mScene.view!.layer.addSublayer(bezierLayerright2)
            controllBallright.removeFromParent()
            controllBallright.position = position
            if(self.mUI != nil){
                self.mUI.addChild(controllBallright)
            }else{
                self.mScene.addChild(controllBallright)
            }
        }
    }


}
