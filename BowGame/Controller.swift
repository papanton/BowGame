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
    
    var mScene: GameScene!

    init(scene : GameScene){
        super.init()
        self.mScene = scene

        controllBallleft = initControllBallleft(self.controllBallradius, powerradius: self.controllPowerradius)
        
        controllPowerleft = initControllPowerleft(self.controllPowerradius)
        
        controllBallright = initControllBallright(self.controllBallradius, powerradius: self.controllPowerradius)
        controllPowerright = initControllPowerright(self.controllPowerradius)
        initbezierleft()
        initbezierright()
    }
    
    func initControllBallleft(ballradius: CGFloat, powerradius: CGFloat) -> SKShapeNode
    {
        var controllBall = SKShapeNode(circleOfRadius: ballradius)
        controllBall.fillColor = SKColor.whiteColor()
        controllBall.alpha = 0.7
        controllBall.position = CGPoint(x: 100 + powerradius - ballradius, y: 120)
        controllBall.name = "controlBallLeft"
        controllBall.zPosition = 1
        self.mScene.addChild(controllBall)
        return controllBall
        
    }
    
    func initControllBallright(ballradius: CGFloat, powerradius: CGFloat) -> SKShapeNode
    {
        var controllBall = SKShapeNode(circleOfRadius: ballradius)
        controllBall.fillColor = SKColor.whiteColor()
        controllBall.alpha = 0.7
        controllBall.position = CGPoint(x: self.mScene.size.width - 90 - self.controllPowerradius + ballradius, y: 120)
        controllBall.name = "controlBallRight"
        controllBall.zPosition = 1
        self.mScene.addChild(controllBall)
        return controllBall
    }
    
    func initControllPowerleft(powerradius: CGFloat) -> SKShapeNode
    {
        var controllPower = SKShapeNode(circleOfRadius: powerradius)
        controllPower.fillColor = SKColor.grayColor()
        controllPower.alpha = 0.3
        controllPower.position = CGPoint(x: 100, y: 120)
        self.mScene.addChild(controllPower)
        return controllPower
    }
    
    func initControllPowerright(powerradius: CGFloat) -> SKShapeNode
    {
        var controllPower = SKShapeNode(circleOfRadius: powerradius)
        controllPower.fillColor = SKColor.grayColor()
        controllPower.alpha = 0.3
        controllPower.position = CGPoint(x: self.mScene.size.width - 90, y: 120)
        self.mScene.addChild(controllPower)
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
    
    func shooting(position : CGPoint){
        if(self.mScene.turns%2==0)
        {
            //player on the right
            var x1 = abs(position.x - controllBallright.position.x)
            var y1 = abs(position.y - controllBallright.position.y)
            var x2 = abs(position.x - controllPowerright.position.x)
            var y2 = abs(position.y - controllPowerright.position.y)
            if((sqrt(x1*x1 + y1*y1) <= controllBallradius) && (sqrt(x2*x2 + y2*y2) <= controllPowerradius))
            {
                self.mScene.endpositionOfTouch = position
                bezierLayerright1.removeFromSuperlayer()
                bezierLayerright2.removeFromSuperlayer()
                bezierLayerright1.strokeEnd = (position.x-controllPowerright.position.x+controllPowerradius) / (controllPowerradius * 2)
                bezierLayerright2.strokeEnd = (position.x - controllPowerright.position.x+controllPowerradius) / (controllPowerradius * 2)
                self.mScene.view!.layer.addSublayer(bezierLayerright1)
                self.mScene.view!.layer.addSublayer(bezierLayerright2)
                controllBallright.removeFromParent()
                controllBallright.position = position
                self.mScene.addChild(controllBallright)
            }
        }
        if(self.mScene.turns%2==1)
        {
            //player on the left
            var x1 = abs(position.x - controllBallleft.position.x)
            var y1 = abs(position.y - controllBallleft.position.y)
            var x2 = abs(position.x - controllPowerleft.position.x)
            var y2 = abs(position.y - controllPowerleft.position.y)
            if((sqrt(x1*x1 + y1*y1) <= controllBallradius) && (sqrt(x2*x2 + y2*y2) <= controllPowerradius))
            {
                self.mScene.endpositionOfTouch = position
                bezierLayerleft1.removeFromSuperlayer()
                bezierLayerleft2.removeFromSuperlayer()
                bezierLayerleft1.strokeEnd = (controllPowerleft.position.x + controllPowerradius - position.x) / (controllPowerradius * 2)
                bezierLayerleft2.strokeEnd = (controllPowerleft.position.x + controllPowerradius - position.x) / (controllPowerradius * 2)
                self.mScene.view!.layer.addSublayer(bezierLayerleft1)
                self.mScene.view!.layer.addSublayer(bezierLayerleft2)
                controllBallleft.removeFromParent()
                controllBallleft.position = position
                self.mScene.addChild(controllBallleft)
            }
        }

    }

}
