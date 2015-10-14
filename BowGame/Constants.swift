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