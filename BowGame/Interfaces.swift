//
//  Interfaces.swift
//  BowGame
//
//  Created by ZhangYu on 10/20/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit

protocol Attacker
{
    func afterAttack( )
    func getDamage( ) -> Int
    func tryStop( )
    func stop( )
    func isFrom(player : Player)->Bool
    func isAlive()->Bool
}

protocol Shotable
{
    func shot(attack :Attacker)->Bool
}

protocol ClickObersever
{
    func onClick()
}
