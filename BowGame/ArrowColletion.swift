//
//  ArrowColletion.swift
//  BowGame
//
//  Created by ZhangYu on 10/3/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit

class ArrowColletion: NSObject
{
    var mCollection : [String : ArrowItem]!
    let mArrowName = ["Arrow", "FlappyArrow"]
    let mArrowDamage = [10, 20]
    override init()
    {
        super.init()
        for i in 1 ... mArrowName.count{
            var arrow = ArrowItem()
            arrow.damage = mArrowDamage[i-1]
            arrow.name = mArrowName[i-1]
        }
    }
}
