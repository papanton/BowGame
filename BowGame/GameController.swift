//
//  GameController.swift
//  BowGame
//
//  Created by ZhangYu on 9/17/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

protocol GameControllerObserver
{
    func turnChanged(turn:Int)
    func gameOver()
}
class GameController
{
    private var mTurn  = 1
    private var mObservers = [GameControllerObserver]()
    private var mCurPlayer: Player?
    private var mPlayers = [Player]()
    private static var mInstance : GameController!
    private var mCanShooting = true
    
    func isGameOver()->Bool
    {
        var isGameOver = false
        for player in mPlayers{
            if(player.isDead()){
                isGameOver = true
            break
            }
        }
        return isGameOver
    }
    private func notify()
    {

        for ob in mObservers{
            if(isGameOver()){
                ob.gameOver()
            }else{
                ob.turnChanged(mTurn)
            }
        }
    }
    /*func getTurn()->Int
    {
        return mTurn
    }*/
    func afterArrowDead()
    {
        ++mTurn;
        changePlayer()
        self.notify()
        mCanShooting = true
    }
    func addGameControllerObserver(ob:GameControllerObserver)
    {
        mObservers.append(ob)
    }
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
        mTurn = 1
        mPlayers = [Player]()
        mObservers = [GameControllerObserver]()
        mCurPlayer = nil
        mCanShooting = true
    }
    func currentPlayerShoot(impulse: CGVector , scene : SKScene)
    {
        if mCanShooting{
            if mCurPlayer == nil && mPlayers.count > 0{
                mCurPlayer = mPlayers[0]
            }
            mCurPlayer?.shoot(impulse, scene: scene)
            mCanShooting = false
        }
    }
   
    /*func changePlayerWithDelay(seconds :Double){
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.changePlayer()
        })
    }
    */
    private func changePlayer()
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
    /*func enableShooting()
    {
        mCanShooting = true
    }
    func disableShooting()
    {
        mCanShooting = false
    }*/
    func canShooting()->Bool
    {
        return mCanShooting
    }
}
