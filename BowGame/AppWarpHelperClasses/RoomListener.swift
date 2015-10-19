//
//  RoomListener.swift
//  FightNinja
//
//  Created by Shephertz on 20/06/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

import UIKit

class RoomListener: NSObject,RoomRequestListener
{
    func onJoinRoomDone(roomEvent:RoomEvent)
    {
        if roomEvent.result == 0 // SUCESS
        {
           let roomData:RoomData = roomEvent.roomData
           AppWarpHelper.sharedInstance.roomId = roomData.roomId
            WarpClient.getInstance().subscribeRoom(roomData.roomId)
            print("onJoinRoomDone Success")

        }
        else // Failed to join
        {
            print("onJoinRoomDone Failed")
            WarpClient.getInstance().createRoomWithRoomName("R1", roomOwner: "Rajeev", properties: nil, maxUsers: 2)
        }
    }
    
    func onSubscribeRoomDone(roomEvent: RoomEvent)
    {
        if roomEvent.result == 0 // SUCESS
        {
            print("onSubscribeRoomDone Success")
       // AppWarpHelper.sharedInstance.startGameScene!.startGame()
        }
        else // Failed to join
        {
            print("onSubscribeRoomDone Failed")
        }
    }
}
