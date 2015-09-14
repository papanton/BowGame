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
let BackgroundImage = "backgroundImage.png"
let PlayerImage1 = "player.png"
let PlayerImage2 = "Player2.png"
let ArrowImage = "arrow.png"
let InGameSettingButton = "InGameSettings.png"
/*
Main menu images (buttons etc)
*/
let LoadImage = "startImage.png"
let StartButtonImage = "Start.png"
let SettingsButton = "Setting.png"
let QuitButtonImage = "Quit.png"
let ResumeButtonImage = "ResumeGame.png"

struct Layer {
    static let Background: CGFloat = 0
    static let Player: CGFloat = 1
    static let Arrow: CGFloat = 2
    
    
}

struct Category {
    static let Player: UInt32 = 1
    static let Arrow: UInt32 = 2
    
}