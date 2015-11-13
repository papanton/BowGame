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
    //private var mArrowItem : ArrowItem!
    private var mCurrentItem : CurrentItem!
    private static var mInstance : DataCenter!
    static func getInstance() ->DataCenter
    {
        if mInstance == nil{
            mInstance = DataCenter()
            mInstance.managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        }
        return mInstance!
    }
    
    /*func setArrowItemDamage(damage : Int)
    {
        initCurrentItem()
        mArrowItem.name = "arrow"
        mArrowItem.damage = damage
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }else{
            println("save successfully! \(mArrowItem.damage)")
        }
    }*/
    private func setCurrentArrow(name : String)
    {
        initCurrentItem()
        mCurrentItem.arrowname = name
        var error: NSError?
        do {
            try managedContext.save()
            print("save successfully! \(mCurrentItem.arrowname)")
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    func setArrowItemByName(name : String)
    {
        if ArrowColletion.getInstance().mArrowName.contains(name){
            setCurrentArrow(name)
        }
        
    }
    func setArrowItemByIndex(index : Int)
    {
        setCurrentArrow(ArrowColletion.getInstance().mArrowName[index])
    }
    private func initCurrentItem()
    {
        let fetchRequest = NSFetchRequest(entityName:"CurrentItem")
        //let predicate = NSPredicate(format: "arrowname = %@", "arrow")
        fetchRequest.returnsObjectsAsFaults = false;
        let fetchedResults:[CurrentItem]!
        //fetchRequest.predicate = predicate
        do {
            try  fetchedResults = managedContext.executeFetchRequest(fetchRequest) as? [CurrentItem]

        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            abort()
        }
        print("initArrowItem")
        let res = fetchedResults
        if  res != nil && res!.count > 0 {
            mCurrentItem = res![0]
            print("fetched \(mCurrentItem.arrowname)")
        } else {
            mCurrentItem = CurrentItem.getDefault()
            print("Get Default Arrow")
        }
    }
    func getArrowItem()->ArrowItem
    {
        if(mCurrentItem == nil){
            initCurrentItem()
        }
        //println("mArrowItem damage = \(mArrowItem.name) \(mArrowItem.damage)")
        return ArrowColletion.getInstance().mCollectionMap[mCurrentItem.arrowname]!
    }
}
