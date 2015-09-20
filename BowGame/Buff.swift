//
//  Buff.swift
//  BowGame
//
//  Created by Zhiyang Lu on 9/18/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class Buff: SKSpriteNode {
    
    private let buffSize = CGSizeMake(50.0, 50.0)
    private var mScene : SKScene!
    private var type : String!
    
    init(name : String) {
        let texture = SKTexture(imageNamed: name)
        type = name
        super.init(texture: texture, color: SKColor.clearColor(), size: buffSize)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //init the physicsBody attributions
    private func addPhysicsBody(){
        self.physicsBody = SKPhysicsBody(rectangleOfSize: buffSize)
        self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = 0x0
        
    }
    
    //called when shot
    func shot(scene : SKScene, arrow : Arrow){
        var player = arrow.getHost()
        
        if(type == "buff_heal"){
            player.healed(30)
        }
    }
    
    func shot(shotable: Shotable) {
        
    }
    
    //set the position of the buff
    func setPosition()
    {
        self.position = CGPointMake(mScene.size.width * 0.5, mScene.size.height * 0.8)
    }
    
    //add the buff to the GameScene
    func add2Scene(scene : SKScene)
    {
        mScene = scene
        setPosition()
        mScene.addChild(self)
    }
    
}
