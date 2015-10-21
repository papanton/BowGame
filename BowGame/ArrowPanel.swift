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
    var expanded = false
    
    init() {
        let texture = SKTexture(imageNamed: "bowarrow.png")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.name = "arrowPanel"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func expand() {
        expanded = true
    }
    
    func resume() {
        expanded = false
    }
}



// A cell that contains a single arrow
class ArrowCell: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "bowarrow.png")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.size = CGSizeMake(150, 150)
        self.name = "arrowCell"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
//        print("arrow cell")
//        let touch = touches.first!
//        let touchLocation = touch.locationInNode(self)
//        
//        print(touchLocation.x, touchLocation.y)
//    }
    
}
