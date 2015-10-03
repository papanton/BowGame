//
//  ViewController.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 19/03/2558 E.B..
//  Copyright (c) 2558 ère b. DaRk-_-D0G. All rights reserved.
//

import UIKit
import GameKit

class MultiPlayerActions: UIViewController {
    
    @IBOutlet weak var TextLabel: UILabel!
    /*####################################################################################################*/
    /*                                          viewDidLoad                                               */
    /*####################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    /*####################################################################################################*/
    /*    Set New view controller delegate, is when you change you change UIViewController                 */
    /*####################################################################################################*/
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Set New view controller delegate */
        EasyGameCenter.delegate = self
    }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    /*####################################################################################################*/
    /*                                          Button                                                    */
    /*####################################################################################################*/
    @IBAction func ActionFindPlayer(sender: AnyObject) {
        EasyGameCenter.findMatchWithMinPlayers(2, maxPlayers: 2)
    }
    
    @IBAction func ActionSendData(sender: AnyObject) {
        
        var myStruct = Packet(name: "My Data to Send !", index: 1234567890, numberOfPackets: 1)
        EasyGameCenter.sendDataToAllPlayers(myStruct.archive(), modeSend: .Reliable)
        
    }
    @IBAction func ActionGetPlayerInMatch(sender: AnyObject) {
        if let setOfPlayer = EasyGameCenter.getPlayerInMatch() {
            for player in setOfPlayer{
                println(player.alias)
            }
        }
    }
    @IBAction func ActionGetMatch(sender: AnyObject) {
        if let match = EasyGameCenter.getMatch() {
            print(match)
        }
    }
    @IBAction func ActionDisconnected(sender: AnyObject) {
        EasyGameCenter.disconnectMatch()
    }
    /*####################################################################################################*/
    /*                         Delegate Mutliplayer Easy Game Center                                      */
    /*####################################################################################################*/
    /**
    Match Start, Delegate Func of Easy Game Center
    */
    func easyGameCenterMatchStarted() {
        println("\n[MultiPlayerActions] MatchStarted")
        if let players = EasyGameCenter.getPlayerInMatch() {
            for player in players{
                println(player.alias)
            }
        }
        self.TextLabel.text = "Match Started !"
    }
    /**
    Match Recept Data (When you send Data this function is call in the same time), Delegate Func of Easy Game Center
    */
    func easyGameCenterMatchRecept(match: GKMatch, didReceiveData data: NSData, fromPlayer playerID: String) {
        
        // See Packet
        let autre =  Packet.unarchive(data)
        println("\n[MultiPlayerActions] Recept From player = \(playerID)")
        println("\n[MultiPlayerActions] Recept Packet.name = \(autre.name)")
        println("\n[MultiPlayerActions] Recept Packet.index = \(autre.index)")
        
        self.TextLabel.text = "Recept Date From \(playerID)"
    }
    /**
    Match End / Error (No NetWork example), Delegate Func of Easy Game Center
    */
    func easyGameCenterMatchEnded() {
        println("\n[MultiPlayerActions] MatchEnded")
        self.TextLabel.text = "Match Ended !"
    }
    /**
    Match Cancel, Delegate Func of Easy Game Center
    */
    func easyGameCenterMatchCancel() {
        println("\n[MultiPlayerActions] Match cancel")
    }
    
}

