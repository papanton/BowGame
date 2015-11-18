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
    private var arrowHitObstacle: AVAudioPlayer?
    private var player_die : AVAudioPlayer?
    private var arrowFlappy: AVAudioPlayer?
    private var cannon: AVAudioPlayer?
    private var selectStage : AVAudioPlayer?
    private var hitIce: AVAudioPlayer?
    private var blackHole: AVAudioPlayer?
    private var ballonBurst: AVAudioPlayer?
    private var backgroundMusic2: AVAudioPlayer?
    private var woodCrash: AVAudioPlayer?
    private var woodHitGround : AVAudioPlayer?
    
    private var muteSound = false
    
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
    func getMuteSound() -> Bool {
        return muteSound
    }
    func changeMuteSound() {
        muteSound = !muteSound
    }
    
    func playArrow()
    {
        if(muteSound) {
            return
        }
        
        if nil == arrow {
            arrow = getSound("sound/Bow", type: "mp3")
        }
        arrow?.play()
    }
    func playScream()
    {
        if(muteSound) {
            return
        }
        if nil == scream {
            scream = getSound("sound/Player_get_hit", type: "wav")
        }
        scream?.play()
    }
    func playPlayerDie() {
        if(muteSound) {
            return
        }
        if nil == player_die {
            player_die = getSound("sound/Player_dead", type: "wav")
            
        }
        player_die?.play()
    }
    func playBossScream() {
        if(muteSound) {
            return
        }
        if nil == boss {
            boss = getSound("sound/Boss", type: "mp3")
            boss?.volume = 1.0
        }
        boss?.play()
    }
    func playBossDie() {
        if(muteSound) {
            return
        }
        if nil == bossDie {
            bossDie = getSound("sound/BossDie", type: "mp3")
            bossDie?.volume = 1.0
        }
        bossDie?.play()
    }
    
    func playGetBuff() {
        if(muteSound) {
            return
        }
        if nil == getBuff {
            getBuff = getSound("sound/getBuff", type: "mp3")
        }
        testRepeatAudio(getBuff!)
        getBuff?.play()
    }
    
    func playWoodCrash() {
        if(muteSound) {
            return
        }
        if nil == woodCrash {
            woodCrash = getSound("sound/Wood_crash", type: "mp3")
            woodCrash?.volume = 0.2
        }
        testRepeatAudio(woodCrash!)
        woodCrash?.play()
    }
    
    func playWoodHitGround() {
        if(muteSound) {
            return
        }
        if nil == woodHitGround {
            woodHitGround = getSound("sound/Wood_hitGround", type: "mp3")
            woodHitGround?.volume = 1.0
        }
        testRepeatAudio(woodHitGround!)
        woodHitGround?.play()
    }
    
    
    func playBlackHole() {
        if(muteSound) {
            return
        }
        if nil == blackHole {
            blackHole = getSound("sound/Blackhole", type: "mp3")
            blackHole?.volume = 0.5
        }
        testRepeatAudio(blackHole!)
        blackHole?.play()
    }
    
    func playMenuSelect() {
        if(muteSound) {
            return
        }
        if nil == menuSelect {
            menuSelect = getSound("sound/MenuSelect",type: "mp3")
            menuSelect?.volume = 0.5
        }
        testRepeatAudio(menuSelect!)
        menuSelect?.play()
    }
    
    
    func playSelectFault() {
        if(muteSound) {
            return
        }
        if nil == selectFault {
            selectFault = getSound("sound/SelectFault", type: "mp3")
            selectFault?.volume = 0.1
        }
        selectFault?.play()
    }
    
    func playHitIce() {
        if(muteSound) {
            return
        }
        if nil == hitIce {
           hitIce = getSound("sound/HitIce", type: "mp3")
        }
        testRepeatAudio(hitIce!)
        hitIce?.play()
    }
    
    func playArrowHitObstacle() {
        if(muteSound) {
            return
        }
        if nil == arrowHitObstacle {
            arrowHitObstacle = getSound("sound/ArrowHitObstacle",type : "mp3")
        }
        testRepeatAudio(arrowHitObstacle!)
        arrowHitObstacle?.play()
    }
    
    func playArrowFlappy() {
        if(muteSound) {
            return
        }
        if nil == arrowFlappy {
            arrowFlappy = getSound("sound/flappy_arrow", type: "wav")
            arrowFlappy?.volume = 0.3
        }
        testRepeatAudio(arrowFlappy!)
        arrowFlappy?.play()
    }
    
    func playCannon() {
        if(muteSound) {
            return
        }
        if nil == cannon {
            cannon = getSound("sound/Cannon", type: "wav")
            cannon?.volume = 0.5
        }
        testRepeatAudio(cannon!)
        cannon?.play()
    }
    func playSelectStage() {
        if(muteSound) {
            return
        }
        if nil == selectStage {
            selectStage = getSound("sound/SelectStage", type: "wav")
        }
        selectStage?.play()
    }
    
    func stopBombDropping()
    {
        if(muteSound) {
            return
        }
        if nil != bombDropping {
            bombDropping?.stop()
        }
        
    }
    func playBombDropping()
    {
        if(muteSound) {
            return
        }
        if nil == bombDropping {
            bombDropping = getSound("sound/BombDropping", type: "mp3")
        }
        testRepeatAudio(bombDropping!)
        bombDropping?.play()
    }
    func playBombExplosion()
    {
        if(muteSound) {
            return
        }
        if nil == bombExplosion {
            bombExplosion = getSound("sound/BombExplosion", type: "mp3")
            bombExplosion?.volume = 0.5
        }
        testRepeatAudio(bombExplosion!)
        bombExplosion?.play()
    }
    
    func playBallonBurst() {
        if(muteSound) {
            return
        }
        if nil == ballonBurst {
            ballonBurst = getSound("sound/Balloon-burst", type: "wav")
            ballonBurst?.volume = 0.1
        }
        testRepeatAudio(ballonBurst!)
        ballonBurst?.play()
    }
    
    func testRepeatAudio(sound : AVAudioPlayer) {
        if(sound.playing) {
            sound.pause()
            sound.currentTime = 0
        }
    }
    
    func playBGM()
    {
        if(muteSound) {
            return
        }
        if (nil == backgroundMusic) {
            backgroundMusic = getSound("sound/Background", type: "mp3")
            backgroundMusic?.numberOfLoops = -1
            backgroundMusic?.volume = 0.2
        }
        backgroundMusic?.play()
    }
    
    func playBGM2() {
        if(muteSound) {
            return
        }
        if(nil == backgroundMusic2) {
            backgroundMusic2 = getSound("sound/Background2",type : "mp3")
            backgroundMusic2?.numberOfLoops = -1
            backgroundMusic2?.volume = 0.6
        }
        backgroundMusic2?.play()
    }
    
    func stopBMG()
    {
        if (backgroundMusic != nil) {
            backgroundMusic?.pause()
            backgroundMusic?.currentTime = 0
        }
        if (backgroundMusic2 != nil) {
            backgroundMusic2?.pause()
            backgroundMusic2?.currentTime = 0
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
