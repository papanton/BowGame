//
//  DataCenter.swift
//  BowGame
//
//  Created by ZhangYu on 10/1/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import CoreData
class DataCenter: NSObject
{
    var managedContext: NSManagedObjectContext!
    private var mArrowItem : ArrowItem!
    private static var mInstance : DataCenter!
    static func getInstance() ->DataCenter
    {
        if mInstance == nil{
            mInstance = DataCenter()
            mInstance.managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
            let arrowEntity =  NSEntityDescription.entityForName("ArrowItem",
                inManagedObjectContext: mInstance.managedContext)
             mInstance.mArrowItem = ArrowItem(entity: arrowEntity!,insertIntoManagedObjectContext:mInstance.managedContext)
            mInstance.setArrowItemDamage(100);
        }
        return mInstance!
    }
    func setArrowItemDamage(damage : Int)
    {
        mArrowItem.setValue("arrow", forKey: "name")
        mArrowItem.setValue(damage, forKey: "damage")
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }else{
            println("save successfully!")
        }
    }
    func setArrowItem(index : Int)
    {
        setArrowItemDamage(100*(index+1))
    }
    func getArrowItem()->ArrowItem
    {
        let fetchRequest = NSFetchRequest(entityName:"ArrowItem")
        let predicate = NSPredicate(format: "name = %@", "name")
        fetchRequest.returnsObjectsAsFaults = false;
        fetchRequest.predicate = predicate
        var error: NSError?
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
        error: &error) as? [ArrowItem]
        if let res = fetchedResults {
            mArrowItem.damage = res[0].damage
            println("fetched")
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        return mArrowItem
    }
}
