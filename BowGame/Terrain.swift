//
//  Terrain.swift
//  BowGame
//
//  Created by 朱启亮 on 9/20/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import SpriteKit

let kHillSegmentWidth:CGFloat = 2
let kMaxHillKeyPoints = 100
let xSplit:CGFloat = 20
let ySplit:CGFloat = 3
class Terrain: SKShapeNode, Shotable {
    
    var hillKeyPoints = [CGPoint?](count: kMaxHillKeyPoints, repeatedValue: nil)
    
    init(scene: GameScene) {
        super.init()
        generateHills(scene)
        var bodySet = drawLine(scene)
        self.path = bodySet.path

        self.fillColor = UIColor.brownColor()
        self.physicsBody = bodySet.body_2
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = CollisonHelper.ArrowMask

        scene.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // player_1 position: width * 0.15, height / 5
    // player_2 position: width * 0.85, height / 5
    
    // player width 100px
    
    func generateHills(scene: GameScene) {
        var x: CGFloat = 0
        var y = scene.size.height / 4
        
        let winSize = scene.size
        
        for var i = 0; i < Int(xSplit) + 1; i++ {
            
            if (x <= scene.size.width * 0.15 + 20) {
               hillKeyPoints[i] = CGPointMake(x, scene.size.height * 0.4 - 25)
            } else if(x >= scene.size.width * 0.85) {
               hillKeyPoints[i] = CGPointMake(x, scene.size.height * 0.2 - 25)
            } else {
                hillKeyPoints[i] = CGPointMake(x, y)
            }
            x += winSize.width / xSplit
            var temp = random() % Int(winSize.height / ySplit)
            y = CGFloat(temp)
        }
        
    }
    
    func shot(arrow :Arrow)
    {
        arrow.stop()
    }
    
    func shot(shotable: Shotable) {
        
    }
    
    func drawLine(scene: GameScene) -> (path: CGPath, body_1: SKPhysicsBody, body_2: SKPhysicsBody) {
        
        var path:CGMutablePathRef = CGPathCreateMutable()
        var curve:CGMutablePathRef = CGPathCreateMutable()
        
        
        CGPathMoveToPoint(path, nil, hillKeyPoints[0]!.x, hillKeyPoints[0]!.y)
        CGPathMoveToPoint(curve, nil, hillKeyPoints[0]!.x, hillKeyPoints[0]!.y)
        
        for var i = 1; i < Int(xSplit) + 1; i++ {
            CGPathAddLineToPoint(path, nil, hillKeyPoints[i]!.x, hillKeyPoints[i]!.y)
            
            
            var p0:CGPoint = hillKeyPoints[i-1]!;
            var p1:CGPoint = hillKeyPoints[i]!;
            var hSegments: CGFloat = CGFloat(floorf(Float((p1.x-p0.x)/kHillSegmentWidth)));
            var dx:CGFloat = (p1.x - p0.x) / hSegments;
            var da:CGFloat = CGFloat(M_PI) / hSegments;
            var ymid:CGFloat = (p0.y + p1.y) / 2;
            var ampl:CGFloat = (p0.y - p1.y) / 2;
            
            var pt0:CGPoint = CGPointMake(0, 0)
            var pt1:CGPoint = CGPointMake(0, 0)
            
            pt0 = p0;
           
            for var j = 0; j < Int(hSegments+1); ++j {
                
                pt1.x = p0.x + CGFloat(j) * dx;
                pt1.y = ymid + ampl * CGFloat(cosf( Float(da * CGFloat(j))));
                
                
                CGPathAddLineToPoint(curve, nil, pt1.x, pt1.y)
                pt0 = pt1;
            }
        }
        
        CGPathAddLineToPoint(curve, nil, scene.size.width, 0)
        CGPathAddLineToPoint(curve, nil, 0, 0)
        CGPathAddLineToPoint(curve, nil, 0, hillKeyPoints[0]!.y)
        
        
        return (curve, SKPhysicsBody(edgeChainFromPath: path), SKPhysicsBody(edgeChainFromPath: curve))
    }
    
}