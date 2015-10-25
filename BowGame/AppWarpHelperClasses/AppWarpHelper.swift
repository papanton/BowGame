//
//  AppWarpHelper.swift
//  FightNinja
//
//  Created by Shephertz on 20/06/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

import UIKit


class AppWarpHelper: NSObject
{

    var api_key = "b1f88f28628ed99e69807f7bba8b65dc9f30f488c6985cab705840d63be8e734"
    var secret_key = "7420f2ee4e8e0081f8bb86e111de8954e32506e658520cd18f35cbe9ad1d2361"
    var roomId = ""
    var enemyName: String = ""
    var playerName: String = ""
    var warpClient:WarpClient!
    
    var startGameScene: StartGameScene? = nil
    var gameScene: GameScene? = nil
    
    var tempFlagVal = 0
    
    var isNewRoomCreated = false

    class var sharedInstance:AppWarpHelper{
        struct Static{
            static var instance:AppWarpHelper?
            static var token: dispatch_once_t = 0
            }
            
            dispatch_once(&Static.token){
                Static.instance = AppWarpHelper()
            }
            return Static.instance!
    }

    func initializeWarp()
    {
        WarpClient.initWarp(api_key, secretKey: secret_key)
         warpClient = WarpClient.getInstance()
        warpClient.enableTrace(true)
        warpClient.setRecoveryAllowance(60);
        
        let connectionListener: ConnectionListener = ConnectionListener()
        warpClient.addConnectionRequestListener(connectionListener)
        
        
        let zoneListener: ZoneListener = ZoneListener()
        warpClient.addZoneRequestListener(zoneListener)
        
        let notificationListener:NotificationListener = NotificationListener()
        warpClient.addNotificationListener(notificationListener)
        
        
        
        let roomListener: RoomListener = RoomListener()
        tempFlagVal = tempFlagVal + 1
        print("THIS FUNCTION HAS BEEN RUN " + String(tempFlagVal) + "  TIMES")
        

        warpClient.addRoomRequestListener(roomListener)
    }
    func disconnectFromServer(){
        //let warpClient:WarpClient = WarpClient.getInstance()

        if(roomId.characters.count > 0){
        warpClient.unsubscribeRoom(roomId)
        warpClient.leaveRoom(roomId)
        warpClient.deleteRoom(roomId)
        warpClient.disconnect()
        self.roomId = ""
        self.playerName = ""
        self.enemyName = ""
        }
    }
    
    func connectWithAppWarpWithUserName(userName:String)
    {
        let uNameLength = userName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if uNameLength>0
        {
            //let warpClient:WarpClient = WarpClient.getInstance()
            warpClient.connectWithUserName(userName)
        }
    }
    

    
    func updatePlayerDataToServer(dataDict:NSMutableDictionary)
    {
        if dataDict == NSNull()
        {
            return
        }
        print(dataDict)
        let convertedData = try? NSJSONSerialization.dataWithJSONObject(dataDict, options: NSJSONWritingOptions.PrettyPrinted)
        //var convertedData = NSPropertyListSerialization.dataWithPropertyList(dataDict, format: NSPropertyListFormat.XMLFormat_v1_0, options: 0, error: nil)
        
        if convertedData == nil
        {
            return
        }
        
        if warpClient.getConnectionState()==0
        {
            print("updatePlayerDataToServer")
            warpClient.sendUpdatePeers(convertedData)
        }
    }
    
    func receivedEnemyStatus(data:NSData)
    {
        print("receivedEnemyStatus...1")
        print(data)

        if data == NSNull()
        {
            print(data)
        }
        else
        {
            print("receivedEnemyStatus...2")
            
            let error: NSError? = nil;
            let responseDict: NSMutableDictionary = (try! NSJSONSerialization.JSONObjectWithData(data,options: NSJSONReadingOptions.MutableContainers)) as! NSMutableDictionary
            
            //var propertyListFormat:NSPropertyListFormat? = nil
            //var responseDict: NSDictionary = NSPropertyListSerialization.propertyListWithData(data, options: 0, format:&propertyListFormat, error: nil) as NSDictionary
            print(responseDict)
            //println(error!.value)
            //gameScene!.updateEnemyStatus(responseDict)
            
            if (error == nil)
            {
                print("receivedEnemyStatus...3")
                
                if enemyName.isEmpty
                {
                    let userName : (String!) = responseDict.objectForKey("userName") as! String
                    let isEqual = playerName.hasPrefix(userName)
                    if !isEqual
                    {
                        enemyName = responseDict.objectForKey("userName") as! String
                        gameScene!.updateEnemyStatus(responseDict)
                    }
                }
                else
                {
                    
                    let userName : (String!) = responseDict.objectForKey("userName") as! String
                    let isEqual = enemyName.hasPrefix(userName)
                    if isEqual
                    {
                        gameScene!.updateEnemyStatus(responseDict)
                    }
                }
            }

        }
        
    }
}
