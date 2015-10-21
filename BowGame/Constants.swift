//
//  Constants.swift
//  BowGame
//
//  Created by Antonis papantoniou on 9/8/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit

//Constants

/*
All images used for the game
*/
let BackgroundImage = "background"
let PlayerImage1 = "player"
let PlayerImage2 = "Player2"
let ArrowImage = "arrow"
let InGameSettingButton = "InGameSettings"
let GroundTexture1 = "groundtexture1"
let HealthBarFrame = "healthbarframelong"

let BombImage = "bomb"


/*
Boss texture
*/
let Boss1 = "pigboss1"

/*
Obstacle textures
*/
let Woodbox = "woodbox"
let Stone = "stone"
let StoneBroken = "stonebroken"
let Ice = "icebox"
/*
Main menu images (buttons etc)
*/
let LoadImage = "startImage"
let StartButtonImage = "Start"
let SettingsButton = "Setting"
let QuitButtonImage = "Quit"
let ResumeButtonImage = "ResumeGame"

struct Layer {
    static let Background: CGFloat = 0
    static let Player: CGFloat = 1
    static let Arrow: CGFloat = 2
    
    
}

struct Category {
    static let Player: UInt32 = 1
    static let Arrow: UInt32 = 2
    
}


func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}
