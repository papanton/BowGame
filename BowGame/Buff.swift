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
    
    
    // Buff types could be
    // buff_heal
    // buff_power
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
    //cannot add new buff to correct position
    func shot(arrow : Arrow){
        var player = arrow.getHost()
        
        if(type == "buff_heal"){
            player.healed(30)
        }else
        if(type == "buff_power"){
            player.powerup(10)
        }
        else
        if(type == "buff_damage"){
            for player_index in GameController.getInstance().getPlayers(){
                if player != player_index{
                    player_index.hurted(50)
                    break
                }
            }
        }
        
        print("shotbuff")
        
        let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 2.0)
        arrow.stop()
        runAction(fadeout, completion: {
            self.removeFromParent()
        })
        
        
        var new_buff : Buff = Buff(name: "buff_heal")
        //        new_buff.add2Scene(self.mScene)

    }
    
    //set the random position of the buff
    //position is between 0.3-0.7 width and 0.5 - 1 height
    func setPosition()
    {
        var minX = mScene.size.width * 0.3
        var maxX = mScene.size.width * 0.7
        var rangeX = maxX - minX
        let positionX:CGFloat = CGFloat(arc4random()) % CGFloat(rangeX) + CGFloat(minX)

        var minY = mScene.size.height - self.size.height
        var maxY = mScene.size.height * 0.5
        var rangeY = maxY - minY
        let positionY:CGFloat = CGFloat(arc4random()) % CGFloat(rangeY) + CGFloat(minY)

        
        self.position = CGPointMake(mScene.size.width*0.5, mScene.size.height*0.5)
    }
    
    //add the buff to the GameScene
    func add2Scene(scene : SKScene)
    {
        mScene = scene
        setPosition()
        mScene.addChild(self)
    }
    
}
