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
        }
        return mInstance!
    }
    
    func setArrowItemDamage(damage : Int)
    {
        initArrowItem()
        mArrowItem.name = "arrow"
        mArrowItem.damage = damage
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }else{
            println("save successfully! \(mArrowItem.damage)")
        }
    }
    func setArrowItem(index : Int)
    {
        setArrowItemDamage(100*(index+1))
    }
    private func initArrowItem()
    {
        let fetchRequest = NSFetchRequest(entityName:"ArrowItem")
        let predicate = NSPredicate(format: "name = %@", "arrow")
        fetchRequest.returnsObjectsAsFaults = false;
        fetchRequest.predicate = predicate
        var error: NSError?
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
        error: &error) as? [ArrowItem]
        if let res = fetchedResults {
            mArrowItem = res[0]
            println("fetched \(mArrowItem.name) \(mArrowItem.damage)")
        } else {
            mArrowItem = ArrowItem.getDefault()
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    func getArrowItem()->ArrowItem
    {
        if(mArrowItem == nil){
            initArrowItem()
        }
        //println("mArrowItem damage = \(mArrowItem.name) \(mArrowItem.damage)")
        return mArrowItem
    }
}
