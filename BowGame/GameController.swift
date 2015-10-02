//
//  GameController.swift
//  BowGame
//
//  Created by ZhangYu on 9/17/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class GameController
{
    private var mCurPlayer: Player?
    private var mPlayers = [Player]()
    private static var mInstance : GameController!
    static func getInstance() ->GameController
    {
        if mInstance == nil{
            mInstance = GameController()
        }
        return mInstance!
    }
    private init(){}
    func reset()
    {
        mPlayers = [Player]()
        mCurPlayer = nil
    }
    func currentPlayer()->Player?
    {
        if mCurPlayer == nil && mPlayers.count > 0{
            mCurPlayer = mPlayers[0]
        }
        return mCurPlayer
    }
   
    func changePlayerWithDelay(seconds :Double){
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.changePlayer()
        })
    }
    
    func changePlayer()
    {
        for player in mPlayers{
            if mCurPlayer != player{
                mCurPlayer = player
                break
            }
        }
    }
    
    
    func getPlayers() -> [Player]{
        return mPlayers
    }
    
    func addPlayer(player : Player)
    {
        mPlayers.append(player)
    }
}
