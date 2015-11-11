//
//  ShootingAngel.swift
//  BowGame
//
//  Created by ZhangYu on 9/17/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class ShootingAngle
{
    private static var mInstance :ShootingAngle!
    var mLineNode = SKShapeNode()
    var mLineRow = SKShapeNode()
    var mLineCol = SKShapeNode()
    var mAngleLabel = SKLabelNode(fontNamed:"Chalkduster")
    var mLines =  [SKShapeNode]()
    static func getInstance()->ShootingAngle
    {
        if mInstance == nil{
            mInstance = ShootingAngle()
        }
        return mInstance
    }
    private init()
    {
        mLines.append(mLineNode)
        mLines.append(mLineRow)
        mLines.append(mLineCol)
        for line in mLines{
            addLineStyle(line)
        }
    }
    func show(scene :SKScene)
    {
        for line in mLines{
            scene.addChild(line)
        }
        scene.addChild(mAngleLabel)
    }
    func hide()
    {
        for line in mLines{
            line.removeFromParent()
        }
        mAngleLabel.removeFromParent()
    }
    private func addLineStyle(line : SKShapeNode)
    {
        line.lineWidth = 2.0
        line.strokeColor = UIColor.grayColor()
        line.alpha = 0.1
    }
    func update(from: CGPoint, to: CGPoint)
    {
        updateLinePaths (from, to: to)
        updateAngleLabel(from, to: to)
    }
    private func updateLinePaths(from: CGPoint, to: CGPoint)
    {
        mLineNode.path = createLinePath(from.x, y1: from.y, x2: to.x, y2: to.y)
        mLineRow.path = createLinePath(from.x, y1: from.y, x2: to.x, y2: from.y)
        mLineCol.path = createLinePath(from.x, y1: from.y, x2: from.x, y2: to.y)
    }
    private func updateAngleLabel(from: CGPoint, to: CGPoint)
    {
        mAngleLabel.position = CGPoint(x: from.x , y:from.y-(from.y-to.y)/2)
        let row1 = abs(from.x - to.x)
        let col1 = abs(from.y - to.y)
        let angle =  floor((Double(atan2( row1 , col1)) / M_PI * 180*100))/100
        mAngleLabel.fontSize = 15
        mAngleLabel.text = String(stringInterpolationSegment: angle)
    }
    private func createLinePath(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat)->CGMutablePath
    {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, x1, y1)
        CGPathAddLineToPoint(path, nil, x2, y2)
        return path
    }

}
