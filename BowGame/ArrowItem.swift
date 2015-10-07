//
//  ArrowItem.swift
//  BowGame
//
//  Created by ZhangYu on 10/3/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class ArrowItem: NSManagedObject {

    @NSManaged var damage: NSNumber
    @NSManaged var name: String
    static func getDefault()->ArrowItem
    {
        let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        let entity = NSEntityDescription.entityForName("ArrowItem", inManagedObjectContext: managedContext)
        var ai = ArrowItem(entity: entity!,insertIntoManagedObjectContext:managedContext)
        ai.damage = 100
        ai.name = "arrow"
        return ai
    }

}
