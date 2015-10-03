//
//  EquipmentItem.swift
//  BowGame
//
//  Created by ZhangYu on 10/1/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import CoreData
class EquipmentItem: UICollectionViewCell {

    static let mArrowDamage = [100, 200, 300, 400]
    static let mItemNumber = ["ArrowItem" : 4, "BowItem":4, "PlayerItem":2]
    let mSetEquipmentFuncs = ["ArrowItem" : {(index : Int)->Void in DataCenter.getInstance().setArrowItem(index)}]
    
    @IBOutlet weak var  mImageView : UIImageView!
    static let PlayerItemNames = [PlayerImage1, PlayerImage2]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Print it to the consol
    }
    func customize(name : String, index : Int)
    {
        if name == "PlayerItem"{
            mImageView.image = UIImage(named: EquipmentItem.PlayerItemNames[index])
        }
    }
    func changeEquipment(name : String, index : Int)
    {
        mSetEquipmentFuncs[name]?(index)
    }
    static func itemNum(name : String) -> Int
    {
        return mItemNumber[name]!
    }
}
