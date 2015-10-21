//
//  ArrowPanel.swift
//  BowGame
//
//  Created by 朱启亮 on 10/17/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import Foundation
import SpriteKit

// panel to hold multiple arrow cells
class ArrowPanel: SKSpriteNode {
    var expanded:Bool = false
    var scaleFactor:CGFloat = 0.2
    var cells = [ArrowCell]()
    
    let mArrowName = ArrowColletion.getInstance().mArrowName
    
    init() {
        let texture = SKTexture(imageNamed: "bowarrow.png")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.size = CGSizeMake(150, 150)
        self.name = "arrowPanel"
        
    }
    
    func initCell(scene:GameScene) {
        for name in mArrowName {
            let cell = ArrowCell.init(arrowName: name)
            cell.position = CGPointMake(170, 335)
            cell.xScale = scaleFactor
            cell.yScale = scaleFactor
            cells.append(cell)
            scene.addChild(cell)
        }
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func expand() {
        expanded = true
        
        // horizontal direction
//        for (var i = 0; i < cells.count; i++) {
//            let move = SKAction.moveByX((CGFloat)(150.0 * scaleFactor * CGFloat(i)), y: 0, duration: 0.2)
//            cells[i].runAction(move)
//        }
        
        // vertical direction
        for (var i = 0; i < cells.count; i++) {
            let move = SKAction.moveByX(0, y: -150.0 * scaleFactor * CGFloat(i), duration: 0.2)
            cells[i].runAction(move)
        }
    }
    
    func resume() {
        expanded = false
        
        // expand in horizontal direction
//        for (var i = 0; i < cells.count; i++) {
//            let move = SKAction.moveByX((CGFloat)(-150.0 * scaleFactor * CGFloat(i)), y: 0, duration: 0.2)
//            cells[i].runAction(move)
//        }
        
        // vertical direction
        for (var i = 0; i < cells.count; i++) {
            let move = SKAction.moveByX(0, y: 150.0 * scaleFactor * CGFloat(i), duration: 0.2)
            
            cells[i].runAction(move)
        }
    }
}



// A cell that contains a single arrow
class ArrowCell: SKSpriteNode {
    var selected:Bool = false
    var mArrowName : String!
    init(arrowName : String) {
        let texture = SKTexture(imageNamed: arrowName)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.size = CGSizeMake(150, 150)
        self.name = "arrowCell"
        mArrowName = arrowName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func onSelected()
    {
        DataCenter.getInstance().setArrowItemByName(mArrowName)
    }
    
 //   override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
//        DataCenter.getInstance().setArrowItemByName(name!)
//        print("arrow cell")
//        let touch = touches.first!
//        let touchLocation = touch.locationInNode(self)
//        
//        print(touchLocation.x, touchLocation.y)
 //   }
    
}
