//
//  Terrain.swift
//  BowGame
//
//  Created by 朱启亮 on 9/20/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import SpriteKit


let kMaxHillKeyPoints = 15
let xSplit:CGFloat = 10
let ySplit:CGFloat = 4
class Terrain: SKNode {
    
    var hillKeyPoints = [CGPoint?](count: kMaxHillKeyPoints, repeatedValue: nil)
    
    init(scene: GameScene) {
        super.init()
        
        generateHills(scene)
        self.physicsBody = drawLine()
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        scene.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func generateHills(scene: GameScene) {
        var x: CGFloat = 0
        var y = scene.size.height / 4
        
        let winSize = scene.size
        
        for var i = 0; i < kMaxHillKeyPoints; i++ {
            hillKeyPoints[i] = CGPointMake(x, y)
            x += winSize.width / xSplit
            var temp = random() % Int(winSize.height / ySplit)
            y = CGFloat(temp)
        }
        
    }
    
    func drawLine() -> SKPhysicsBody {
        
        var path:CGMutablePathRef = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, hillKeyPoints[0]!.x, hillKeyPoints[0]!.y)
        
        for var i = 1; i < kMaxHillKeyPoints; i++ {
            print(hillKeyPoints[i]!.x)
            print(" ")
            print(hillKeyPoints[i]!.y)
            println()
            CGPathAddLineToPoint(path, nil, hillKeyPoints[i]!.x, hillKeyPoints[i]!.y)
            
        }
        
        return SKPhysicsBody(edgeChainFromPath: path)
    }
    
}