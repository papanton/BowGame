//
//  Buff.swift
//  BowGame
//
//  Created by Zhiyang Lu on 9/18/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class Buff: SKSpriteNode, Shotable {
    
    private let buffSize = CGSizeMake(50.0, 50.0)
    private var mScene : SKScene!
    private var type : String!
    
    init(name : String) {
        let texture = SKTexture(imageNamed: name)
        type = name
        super.init(texture: texture, color: SKColor.clearColor(), size: buffSize)
        addPhysicsBody()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //init the physicsBody attributions
    private func addPhysicsBody(){
        self.physicsBody = SKPhysicsBody(rectangleOfSize: buffSize)
        self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = 0x0
        
    }
    
    //called when shot
    func shot(arrow : Arrow){
        var player = arrow.getHost()
        
        if(type == "buff_heal"){
            player.healed(30)
        }
        else if(type == "buff_damage"){
            for player_index in GameController.getInstance().getPlayers(){
                if player != player_index{
                    player_index.hurted(50)
                    break
                }
            }
        }
        let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 2.0)
        arrow.stop()
        runAction(fadeout, completion: {
            self.removeFromParent()})
        
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
