//
//  CurrentItem.swift
//  BowGame
//
//  Created by ZhangYu on 10/3/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class CurrentItem: NSManagedObject {

    @NSManaged var arrowname: String
    @NSManaged var bowname: String
    @NSManaged var playername: String
    static func getDefault()->CurrentItem
    {
        let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        let entity = NSEntityDescription.entityForName("CurrentItem", inManagedObjectContext: managedContext)
        var ci = CurrentItem(entity: entity!,insertIntoManagedObjectContext:managedContext)
        ci.arrowname = "arrow"
        return ci
    }

}
