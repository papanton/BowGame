//
//  SoundEffect.swift
//  BowGame
//
//  Created by ZhangYu on 9/16/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import AVFoundation
class SoundEffect
{
    private var arrow : AVAudioPlayer?
    private var scream : AVAudioPlayer?
    private var bombDropping : AVAudioPlayer?
    private var bombExplosion : AVAudioPlayer?
    private var backgroundMusic : AVAudioPlayer?
    private var boss: AVAudioPlayer?
    private var getBuff: AVAudioPlayer?
    private var bossDie : AVAudioPlayer?
    private var loss : AVAudioPlayer?
    private var menuSelect : AVAudioPlayer?
    private var selectFault : AVAudioPlayer?
    private var arrowHitAbstacle: AVAudioPlayer?
    private var player_die : AVAudioPlayer?
    private var arrowFlappy: AVAudioPlayer?
    private var cannon: AVAudioPlayer?
    private var selectStage : AVAudioPlayer?
    
    private static var instance : SoundEffect?
    static func getInstance()->SoundEffect
    {
        if nil==instance{
            instance = SoundEffect()
        }
        return instance!
    }
    private init()
    {
        
    }
    func playArrow()
    {
        if nil == arrow {
            arrow = getSound("sound/Bow", type: "mp3")
        }
        arrow?.play()
    }
    func playScream()
    {
        if nil == scream {
            scream = getSound("sound/Player_get_hit", type: "wav")
        }
        scream?.play()
    }
    func playPlayerDie() {
        if nil == player_die {
            player_die = getSound("sound/Player_dead", type: "wav")
            
        }
        player_die?.play()
    }
    func playBossScream() {
        if nil == boss {
            boss = getSound("sound/Boss", type: "mp3")
        }
        boss?.volume = 1.0
        boss?.play()
    }
    func playBossDie() {
        
        if nil == bossDie {
            bossDie = getSound("sound/BossDie", type: "mp3")
        }
        bossDie?.volume = 1.0
        bossDie?.play()
    }
    
    func playGetBuff() {
        if nil == getBuff {
            getBuff = getSound("sound/getBuff", type: "mp3")
        }
        getBuff?.play()
    }
    func playMenuSelect() {
        if nil == menuSelect {
            menuSelect = getSound("sound/MenuSelect",type: "mp3")
        }
        menuSelect?.volume = 0.5
        menuSelect?.play()
    }
    func playSelectFault() {
        if nil == selectFault {
            selectFault = getSound("sound/SelectFault", type: "mp3")
        }
        selectFault?.volume = 0.1
        selectFault?.play()
    }
    func playArrowHitObstacle() {
        if nil == arrowHitAbstacle {
            arrowHitAbstacle = getSound("sound/ArrowHitObstacle",type : "mp3")
        }
        arrowHitAbstacle?.play()
    }
    
    func playArrowFlappy() {
        if nil == arrowFlappy {
            arrowFlappy = getSound("sound/flappy_arrow", type: "wav")
        }
        arrowFlappy?.volume = 0.3
        arrowFlappy?.play()
    }
    
    func playCannon() {
        if nil == cannon {
            cannon = getSound("sound/Cannon", type: "wav")
        }
        cannon?.volume = 0.5
        cannon?.play()
    }
    func playSelectStage() {
        if nil == selectStage {
            selectStage = getSound("sound/SelectStage", type: "wav")
        }
        selectStage?.play()
    }
    
    func stopBombDropping()
    {
        if nil != bombDropping {
            bombDropping?.stop()
        }
        
    }
    func playBombDropping()
    {
        if nil == bombDropping {
            bombDropping = getSound("sound/BombDropping", type: "mp3")
        }
        bombDropping?.play()
    }
    func playBombExplosion()
    {
        if nil == bombExplosion {
            bombExplosion = getSound("sound/BombExplosion", type: "mp3")
        }
        bombExplosion?.play()
    }
    func playBGM()
    {
        if (nil == backgroundMusic) {
            backgroundMusic = getSound("sound/Background", type: "mp3")
            backgroundMusic?.numberOfLoops = -1
        }
        backgroundMusic?.volume = 0.2
        backgroundMusic?.play()
    }
    
    func stopBMG()
    {
        if (backgroundMusic != nil) {
            backgroundMusic?.stop()
            backgroundMusic?.currentTime = 0
        }
    }
    
    
    private func getSound(file:String, type:String) -> AVAudioPlayer  {
        //1
        let path = NSBundle.mainBundle().pathForResource(file, ofType:type)
        let url = NSURL.fileURLWithPath(path!)
        
        //2
        var error: NSError?
        
        //3
        var audioPlayer:AVAudioPlayer?
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: url)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        //4
        return audioPlayer!
    }
}
