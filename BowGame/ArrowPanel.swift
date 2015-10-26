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
        let texture = SKTexture(imageNamed: "transparent")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.size = CGSizeMake(250, 250)
        self.name = "arrowPanel"
        
    }
    
    func initCell(scene:GameScene) {
        for name in mArrowName {
            let cell = ArrowCell.init(arrowName: name,arrowPanel: self)
            cell.position = CGPointMake(170, 335)
            cell.xScale = scaleFactor
            cell.yScale = scaleFactor
            cells.append(cell)
            if(cells.count > 1) {
                cell.hidden = true
            }
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
            let move = SKAction.moveByX(0, y: -250.0 * scaleFactor * CGFloat(i), duration: 0.2)
            cells[i].hidden = false
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
            let move = SKAction.moveByX(0, y: 250.0 * scaleFactor * CGFloat(i), duration: 0.2)
            let currentCell = cells[i]
            if(i == 0) {
                currentCell.runAction(move)
            } else {
                currentCell.runAction(move, completion: {
                    currentCell.hidden = true
                })
            }
        }
    }
    
    func switchCell(cellName: String) {
        for(var i = 0; i < cells.count; i++) {
            if cells[i].mArrowName == cellName {
                let previousFirst = cells[0]
                cells[0] = cells[i];
                cells[i] = previousFirst
                cells[i].position = cells[0].position
                cells[i].zPosition = cells[0].zPosition
                cells[0].position = CGPointMake(170, 335)
                cells[0].zPosition = 4
                break
            }
        }
    }
    
    func setArrowNum(normal:Int, bomb: Int, flappy:Int, split:Int, ignore: Int) {
        for(var i = 0; i < cells.count; i++) {
            if cells[i].mArrowName == "arrow" {
                cells[i].mArrowNum = normal
            } else if(cells[i].mArrowName == "FlappyArrow") {
                cells[i].mArrowNum = flappy
            } else if(cells[i].mArrowName == "ArrowThrowsBombs") {
                cells[i].mArrowNum = bomb
            } else if(cells[i].mArrowName == "SplitableArrow") {
                cells[i].mArrowNum = split
            } else {
                cells[i].mArrowNum = ignore
            }
            if(cells[i].mArrowNum == 0) {
                cells[i].alpha = 0.3
            }
            cells[i].mNumLabel.text = String(cells[i].mArrowNum)
        }
    }
    
    func updateArrowNum() {
        cells[0].mArrowNum = cells[0].mArrowNum - 1
        if(cells[0].mArrowNum == 0) {
            cells[0].alpha = 0.3
        }
        cells[0].mNumLabel.text = String(cells[0].mArrowNum)
    }
    
    func remindOutofArrow() {
        var sequence = [SKAction]()
        for i in 1...3{
            sequence.append(SKAction.rotateByAngle(CGFloat(M_PI) / CGFloat(3*i), duration: 0.1))
            sequence.append(SKAction.rotateByAngle(-CGFloat(M_PI) / CGFloat(3*i), duration: 0.1))
        }
        //let action = SKAction.repeatActionForever(SKAction.sequence(sequence))
        cells[0].runAction(SKAction.sequence(sequence))
    }
}



// A cell that contains a single arrow
class ArrowCell: SKSpriteNode {
    var selected:Bool = false
    var mArrowName : String!
    var mArrowPanel : ArrowPanel!
    var mArrowNum: Int!
    var mNumLabel : SKLabelNode!
    var mLabelBG : SKShapeNode!
    init(arrowName : String, arrowPanel: ArrowPanel) {
        var texture: SKTexture!
        if(arrowName == "arrow") {
            texture = SKTexture(imageNamed: "cell_normalarrow")
        }else if(arrowName == "FlappyArrow") {
            texture = SKTexture(imageNamed: "cell_flappyarrow")
        }else if(arrowName == "ArrowThrowsBombs") {
            texture = SKTexture(imageNamed: "cell_bombarrow")
            
        } else if(arrowName == "SplitableArrow") {
            texture = SKTexture(imageNamed: "cell_splitarrow")
        } else {
            texture = SKTexture(imageNamed: "cell_ignorearrow")
        }
        
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.size = CGSizeMake(250, 250)
        self.name = "arrowCell"
        self.mArrowName = arrowName
        self.mArrowPanel = arrowPanel
        self.mArrowNum = 100
        
        
        self.mLabelBG = SKShapeNode(rectOfSize: CGSizeMake(80, 80), cornerRadius: 40)
        //self.mLabelBG = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(80, 80))
        self.mLabelBG.strokeColor = UIColor.redColor()
        self.mLabelBG.fillColor = UIColor.redColor()
        self.mLabelBG.position = CGPointMake(self.position.x+self.size.width-150, self.position.y + self.size.height-150)
        self.mLabelBG.zPosition = 1
        self.addChild(self.mLabelBG)
        
        //set numlabel
        
        
        self.mNumLabel = SKLabelNode(fontNamed: "Arial")
        self.mNumLabel.text = String(self.mArrowNum)
        self.mNumLabel.fontColor = UIColor.whiteColor()
        self.mNumLabel.fontSize = 50
        self.mNumLabel.position = CGPointZero
        self.mNumLabel.zPosition = 5
        self.mNumLabel.verticalAlignmentMode = .Center
        self.mLabelBG.addChild(self.mNumLabel)
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
