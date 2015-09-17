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
            arrow = getSound("Bow", type: "mp3")
        }
        arrow?.play()
    }
    func playScream()
    {
        if nil == scream {
            scream = getSound("Scream", type: "mp3")
        }
        scream?.play()
    }

    private func getSound(file:String, type:String) -> AVAudioPlayer  {
        //1
        var path = NSBundle.mainBundle().pathForResource(file, ofType:type)
        var url = NSURL.fileURLWithPath(path!)
        
        //2
        var error: NSError?
        
        //3
        var audioPlayer:AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        //4
        return audioPlayer!
    }
}
