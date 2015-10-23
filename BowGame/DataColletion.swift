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
    var mCollection = [ArrowItem]()
    var mCollectionMap = [String : ArrowItem]()
    let mArrowName = ["arrow", "FlappyArrow", "ArrowThrowsBombs","SplitableArrow"]
    let mArrowDamage = [10, 20, 10, 10]
    private static var mInstance : ArrowColletion!
    static func getInstance()->ArrowColletion
    {
        if(mInstance == nil){
            mInstance = ArrowColletion()
        }
        return mInstance
    }
    private override init()
    {
        super.init()
        for i in 1 ... mArrowName.count{
            let arrow = ArrowItem.getDefault()
            arrow.damage = mArrowDamage[i-1]
            arrow.name = mArrowName[i-1]
            mCollection.append(arrow)
            mCollectionMap[arrow.name] = arrow;
        }
    }
}
