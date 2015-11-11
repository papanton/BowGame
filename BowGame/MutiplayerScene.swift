//
//  MutiplayerScene.swift
//  BowGame
//
//  Created by ZhangYu on 10/17/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit

class MutiplayerScene: GameScene
{
    override func leftControllerOnTouchBegin()
    {
        if self.rounds % 2 == 1{
            super.leftControllerOnTouchBegin()
        }
    }
    override  func rightControllerOnTouchBegin()
    {
        if self.rounds % 2 == 0{
            super.rightControllerOnTouchBegin()
        }
    }
    override func controllerShoot(position: CGPoint)
    {
        if(rounds % 2 == 1)
        {
            controllers.moveLeftController(position)
        }else{
            controllers.moveRightController(position)
        }
    }
    override func controllerOnTouchEnded()
    {
        if(self.rounds % 2 == 1)
        {
            controllers.resetLeftController()
        }
        if(self.rounds % 2 == 0)
        {
            controllers.resetRightController()
        }
    }
}
