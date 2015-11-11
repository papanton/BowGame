//
//  Obstacle.swift
//  BowGame
//
//  Created by Jiawei Song on 9/20/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class Obstacle: SKSpriteNode, Shotable, Attacker {
  
    private var type: String!
    private var collisionTimes: Int!
    private var damage : Int!
    private var obstacletexture : SKTexture!
    private var obstaclesize : CGSize!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func isAlive()->Bool
    {
        return collisionTimes < 2
    }
    //init a obstacle with give name, possible damage and its init position
    init(name: String, damage: Int, position: CGPoint, size: CGSize) {
        obstacletexture = SKTexture(imageNamed: name)
        obstaclesize = size
        self.type = name
        self.damage = damage
        super.init(texture: obstacletexture, color: UIColor.clearColor(), size: obstaclesize)
        self.collisionTimes = 0
        self.position = CGPointMake(position.x, position.y + self.size.height / 2)
        
        self.addPhysicsBody()
    }
    
    //init physicsBody to the obstacle
    private func addPhysicsBody() {
        self.physicsBody = SKPhysicsBody(texture: obstacletexture, size: obstaclesize)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask | CollisonHelper.ShotableMask
        self.physicsBody?.collisionBitMask = CollisonHelper.ArrowMask | CollisonHelper.ShotableMask
    }
    
    /**
     *  give a random position to the obstacle
     *  not used now
     */
    func setObstaclePosition(mScene: SKScene)
    {
        let minX = mScene.size.width * 0.3
        let maxX = mScene.size.width * 0.7
        let rangeX = maxX - minX
        let positionX:CGFloat = CGFloat(arc4random()) % CGFloat(rangeX) + CGFloat(minX)
        
        let minY = mScene.size.height * 0.3
        let maxY = mScene.size.height * 0.1
        let rangeY = maxY - minY
        let positionY:CGFloat = CGFloat(arc4random()) % CGFloat(rangeY) + CGFloat(minY)
        
        self.position = CGPointMake(positionX, positionY)
    }

    //return the damage of the obstacle
    func getDamage()-> Int
    {
        return damage
    }

    
    func afterAttack()
    {
        self.collisionTimes = self.collisionTimes + 1
        if(self.collisionTimes == 2) {
            
            let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1.5 * Double(NSEC_PER_SEC))),dispatch_get_main_queue()){
                self.runAction(fadeout, completion: {
                    self.removeFromParent()})
            }
        }
        //print("22")
    }
    func shot(attacker : Attacker)->Bool
    {
        if let arrow = attacker as? Arrow{
            arrow.slowDown()
            self.physicsBody?.dynamic = true
        }
        //print("11")
        return true
    }
    func stop() {
        physicsBody?.dynamic = false
    }
    func tryStop() {
         stop()
    }
    func isFrom(player: Player) -> Bool {
        return false
    }
}

class woodbox : Obstacle {
    
    private var woodbox_size : CGSize!
    init(position : CGPoint)
    {
        woodbox_size = CGSizeMake(50, 50)
        super.init(name: Woodbox, damage: 0, position: position, size: woodbox_size)
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //wood box disappears after shot
    override func shot(attacker: Attacker) -> Bool {
        print("shot wood box")
        
        if let arrow = attacker as? Arrow{
            arrow.tryStop()
            
        }
        let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        runAction(fadeout, completion: {
            self.removeFromParent()
        })

        return true
    }
}

class stone : Obstacle {
    private var stone_size : CGSize!
    init(position : CGPoint)
    {
        self.stone_size = CGSizeMake(50, 50)
        super.init(name: Stone, damage: 0, position: position, size: stone_size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //wood box disappears after shot
    override func shot(attacker: Attacker) -> Bool {
        print("shot wood box")
        
        if let arrow = attacker as? Arrow{
            arrow.stop()
            
        }
        if(self.collisionTimes == 0)
        {
            self.collisionTimes = self.collisionTimes + 1
            self.texture = SKTexture(imageNamed: StoneBroken)
        }
        else{
            let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
            runAction(fadeout, completion: {
                self.removeFromParent()
            })
        }
        
        return true
    }

}

class Icebox : Obstacle {
    private var ice_size : CGSize!
    init(position : CGPoint)
    {
        self.ice_size = CGSizeMake(50, 50)
        super.init(name: Ice, damage: 0, position: position, size: ice_size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //wood box disappears after shot
    override func shot(attacker: Attacker) -> Bool {
        print("shot ice box")
        
        if let arrow = attacker as? Arrow{
            if(self.position.x < arrow.position.x && arrow.position.x < self.position.x + 50)
            {
                arrow.physicsBody?.velocity.dy = -(arrow.physicsBody?.velocity.dy)!
            }else{
                arrow.physicsBody?.velocity.dx = -(arrow.physicsBody?.velocity.dx)!
                arrow.xScale = -arrow.xScale
            }
            arrow.update()
        }
        
        return true
    }
    
}

class WoodBoard : Obstacle {
    private var board_size : CGSize!
    private var mScene: SKScene!
    private var mWorld: SKNode!
    private var rootFlag : Bool!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(size: CGSize, position: CGPoint, flag: Bool) {
        self.board_size = size
        super.init(name: Board, damage: 0, position: position, size: board_size)
        self.rootFlag = flag
    }
    
    func add2Scene(scene: SKScene, world: SKNode)
    {
        if(!self.rootFlag) {
            self.physicsBody?.dynamic = true
        }
        self.mScene = scene;
        self.mWorld = world;
        self.mWorld.addChild(self)
    }
    
    override func shot(attacker: Attacker) -> Bool {
        if let arrow = attacker as? Arrow{
            arrow.slowDown()
        }
        if(self.rootFlag == true) {
            let part1 = WoodBoard(size: CGSizeMake(self.size.width, self.size.height/2),position: self.position,flag: false)
            let part2 = WoodBoard(size: CGSizeMake(self.size.width, self.size.height/2),position: CGPointMake(self.position.x, self.position.y + self.size.height/2 + 5), flag: false)
            part2.zRotation = -10
        
            part1.add2Scene(self.mScene,world:self.mWorld)
            part2.add2Scene(self.mScene,world:self.mWorld)
            self.removeFromParent()
        }
        else {
            let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
            runAction(fadeout, completion: {
                self.removeFromParent()
            })
        }
        return true
    }
}

class Rock : Obstacle {
    private var rock_size : CGSize!
    init(position : CGPoint)
    {
        self.rock_size = CGSizeMake(222 / 3, 234 / 3)
        super.init(name: "rock", damage: 0, position: position, size: rock_size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //wood box disappears after shot
    override func shot(attacker: Attacker) -> Bool {
        print("shot rock")
        
        if let arrow = attacker as? Arrow{
            arrow.tryStop()
        }
        
        return true
    }

}

