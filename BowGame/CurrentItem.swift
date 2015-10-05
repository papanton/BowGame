//
//  CurrentItem.swift
//  BowGame
//
//  Created by ZhangYu on 10/3/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import Foundation
import CoreData

class CurrentItem: NSManagedObject {

    @NSManaged var arrowname: String
    @NSManaged var bowname: String
    @NSManaged var playername: String

}
