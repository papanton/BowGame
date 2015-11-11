//
//  StageFour.swift
//  BowGame
//
//  Created by Zhiyang Lu on 11/10/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit

class StageFour: StageGameScene
{
    override func addBoss()
    {
        let bossposition = CGPointMake(self.size.width * 2 * 0.9, self.size.height / 6)
        self.boss = Boss(name: "firstboss", scene: self, UI: self.UI, world: self.world, position: bossposition)
        boss.add2Scene()
    }
    
    
    override func addObstacle() {
        for(var i = 0; i < 6; i++){
            let ice = Icebox(position: CGPointMake(size.width/2, 150+CGFloat(i * 50)))
            self.world.addChild(ice)
        }
        let ice = SuperIcebox(position: CGPointMake(size.width, 40), ice_size: CGSizeMake(size.width*2, 30))
            self.world.addChild(ice)
    }

}
