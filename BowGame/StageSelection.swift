//
//  StageSelection.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/23/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class StageSelection: SKScene {
    
    var selectedStage = 0
    
    var mainmenu: StartGameScene!
    var dataFilePath: String!
    let stagesLocked = true //for testing
    var currentStage: Int!
    var mute: SKSpriteNode!
    var proceed:SKSpriteNode!
    let buttonfuncs = [
        "reset": {(s:StageSelection)->Void in s.resetProcess()},
        "proceedButton":{(s:StageSelection)->Void in s.proceedToStage()},
        "back": {(s:StageSelection)->Void in s.backToMainMenu()},
        "muteSound" : {(s:StageSelection)->Void in s.muteSound()},
        "stage1": {(s:StageSelection)->Void in s.goStageOne()},
        "stage2": {(s:StageSelection)->Void in s.goStageTwo()},
        "stage3": {(s:StageSelection)->Void in s.goStageThree()},
        "stage4": {(s:StageSelection)->Void in s.goStageFour()},
        "stage5": {(s:StageSelection)->Void in s.goStageFive()},
        "stage6": {(s:StageSelection)->Void in s.goStageSix()},
        "stage7": {(s:StageSelection)->Void in s.goStageSeven()},
        "stage8": {(s:StageSelection)->Void in s.goStageEight()},
        "test": {(s:StageSelection)->Void in s.goTestStage()},
    ]
    var stages: [SKSpriteNode]!
    
    let playerName = "temp"
    let screensize = UIScreen.mainScreen().bounds.size;
    let scenesize : CGSize = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height)
    
    init(size: CGSize, mainmenu : StartGameScene)
    {
        super.init(size : size)
        self.mainmenu = mainmenu
        
        addBackground()
        addBackButton()
        addMuteButton()
        addSelections()
        addResetButton()
        currentStage = readStageProgress()
        if currentStage < 1 {
            //first time playing
            storeStageProgress(1)
            currentStage = 1
        }
        print (currentStage)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        
        self.selectedStage = 0
        updateProcess()
        
    }
    
    /*
    Add stage description subview each time a stage is selected.
    
    */
    func showInfo(stageTitle: String, stageDescription: String, stageImage: UIImage) {

        let myInfo = StageInfo(frame: CGRect(x: self.size.width * 0.25 , y: self.size.height * 0.2, width: self.size.width * 0.5, height: self.size.height * 0.2))
        myInfo.textView.text = stageDescription
        myInfo.imageView.image = stageImage
        myInfo.title.text = stageTitle
        
        
        self.view?.addSubview(myInfo)
        
        
    }
    //add background for stage selection
    func addBackground()
    {
        let background = SKSpriteNode(texture: SKTexture(imageNamed: "snowbg"), color: UIColor.clearColor(), size: CGSizeMake(self.size.width * 2, self.size.height))
        background.position = CGPoint(x: 0.0, y: background.size.height/2)
        self.addChild(background)
    }
    
    
    func addMuteButton() {
        if(SoundEffect.getInstance().getMuteSound()) {
            mute = SKSpriteNode(texture: SKTexture(imageNamed: "muteSound"),color: UIColor.clearColor(),size: CGSizeMake(30,30))
        } else{
            mute = SKSpriteNode(texture: SKTexture(imageNamed: "unmuteSound"),color: UIColor.clearColor(),size: CGSizeMake(30,30))
        }
        mute.position = CGPointMake(80,self.size.height-30)
        mute.name = "muteSound"
        mute.zPosition = 2
        self.addChild(mute)
    }
    
    func addProceedButton() {
        proceed = SKSpriteNode(texture: SKTexture(imageNamed: "startbutton"),color: UIColor.clearColor(),size: CGSizeMake(30,30))
        proceed.position = CGPointMake(self.size.width - 30, self.size.height - 30)
        proceed.name = "proceedButton"
        proceed.zPosition = 2
        self.addChild(proceed)
        
    }
    
    //add back button to return the main menu
    func addBackButton()
    {
        let back = SKSpriteNode(texture: SKTexture(imageNamed: "backbutton"), color: UIColor.clearColor(), size: CGSizeMake(30, 30))
        back.position = CGPointMake(30, self.size.height - 30)
        back.name = "back"
        back.zPosition = 2
        self.addChild(back)
    }
    
    //add reset button to clear stage process
    func addResetButton() {
        let back = SKSpriteNode(texture: SKTexture(imageNamed: "restartbutton"), color: UIColor.clearColor(), size: CGSizeMake(30, 30))
        back.position = CGPointMake(self.size.width - 30, 30)
        back.name = "reset"
        back.zPosition = 2
        self.addChild(back)
    }
    
    //add selections to enter a stage
    func addSelections()
    {
        let currentStage = readStageProgress()
        print("Current Stage is \(currentStage) ")
        
        let stage1 = SKSpriteNode(texture: SKTexture(imageNamed: "stage1"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage1.alpha = 0.5
        stage1.name = "stage1"
        
        let stage2 = SKSpriteNode(texture: SKTexture(imageNamed: "stageLock"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage2.alpha = 0.5
        stage2.name = "stage2"
        
        let stage3 = SKSpriteNode(texture: SKTexture(imageNamed: "stageLock"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage3.name = "stage3"
        stage3.alpha = 0.5
        
        let stage4 = SKSpriteNode(texture: SKTexture(imageNamed: "stageLock"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage4.name = "stage4"
        stage4.alpha = 0.5
        
        let stage5 = SKSpriteNode(texture: SKTexture(imageNamed: "stageLock"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage5.name = "stage5"
        stage5.alpha = 0.5
        
        let stage6 = SKSpriteNode(texture: SKTexture(imageNamed: "stageLock"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage6.name = "stage6"
        stage6.alpha = 0.5
        
        let stage7 = SKSpriteNode(texture: SKTexture(imageNamed: "stageLock"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage7.name = "stage7"
        stage7.alpha = 0.5
        
        
        let stage8 = SKSpriteNode(texture: SKTexture(imageNamed: "stageLock"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
        stage8.name = "stage8"
        stage8.alpha = 0.5
        
        
//        let test = SKSpriteNode(texture: SKTexture(imageNamed: "stageLock"), color: UIColor.clearColor(), size: CGSizeMake(87/2, 94/2))
//        test.name = "test"
//        test.alpha = 0.5
        
        
        
        self.stages = [stage1,stage2,stage3,stage4,stage5,stage6,stage7,stage8]
        
        for (index, stage) in stages.enumerate() {
            
            if (index + 1 <= currentStage && stagesLocked) {
                stage.texture = SKTexture(imageNamed: stage.name!)
                stage.alpha = 1
            }
        }
        var i = 1.0
        var offset : CGFloat = 5
        
        for button in stages{
            offset = offset * -1
            button.position = CGPointMake((button.size.width + 15) * CGFloat(i), self.size.height * 0.2 + offset)
            button.zPosition = 2
            self.addChild(button)
            i = i + 1
        }
    }
    
    //back to the Main Menu when press back button
    func backToMainMenu()
    {
        view!.subviews.forEach({ $0.removeFromSuperview() })

        AppWarpHelper.sharedInstance.disconnectFromServer()
        //let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Down, duration: 0.5)
        view?.presentScene(self.mainmenu,transition: transitionType)
        self.removeFromParent()
    }
    
    func muteSound() {
        if(!SoundEffect.getInstance().getMuteSound()) {
            self.mute.texture = SKTexture(imageNamed: "muteSound")
        } else {
            self.mute.texture = SKTexture(imageNamed: "unmuteSound")
        }
        SoundEffect.getInstance().changeMuteSound()
    }
    
    //functions go to correspoding stages
    func goStageOne()
    {
        if proceed != nil {
            proceed.removeFromParent()
        }

        view!.subviews.forEach({ $0.removeFromSuperview() })


        if currentStage >= 1 || !stagesLocked {

            let stageTitle = "Stage 1"
            let stageDescription = "A fresh start! Learn the basics that will transform you into an amazing archer"
            let stagePicture = UIImage(named: "pigboss1")
            addProceedButton()
            
            showInfo(stageTitle, stageDescription: stageDescription, stageImage: stagePicture!)
            
            
            self.selectedStage = 1
        }
    }
    func goStageTwo()
    {
        
        if proceed != nil {
            proceed.removeFromParent()
        }

        view!.subviews.forEach({ $0.removeFromSuperview() })

        if currentStage >= 2 || !stagesLocked {
            
            let stageTitle = "Stage 2"
            let stageDescription = "Kill the troll! Use the flappy arrow to get some damage in and then shoot straight through the obstacles!"
            let stagePicture = UIImage(named: "fighterboss1")
            addProceedButton()
            
            showInfo(stageTitle, stageDescription: stageDescription, stageImage: stagePicture!)
            
            
            self.selectedStage = 2
        }
    }
    func goStageThree()
    {
        
        if proceed != nil {
            proceed.removeFromParent()
        }

        view!.subviews.forEach({ $0.removeFromSuperview() })

        if currentStage >= 3 || !stagesLocked {
            
            let stageTitle = "Stage 3"
            let stageDescription = "The cannon stop you from shootting the boss! Can you destroyed them with the Bomb Arrow?"
            let stagePicture = UIImage(named: "whiteboss")
            addProceedButton()
            
            showInfo(stageTitle, stageDescription: stageDescription, stageImage: stagePicture!)
            
            
            self.selectedStage = 3
        }
    }
    func goStageFour()
    {
        
        if proceed != nil {
            proceed.removeFromParent()
        }

        view!.subviews.forEach({ $0.removeFromSuperview() })

        
        if currentStage >= 4 || !stagesLocked {
            
            let stageTitle = "Stage 4"
            let stageDescription = "Try to shoot the boss with the help of the ices!"
            let stagePicture = UIImage(named: "whiteboss2")
            addProceedButton()
            
            showInfo(stageTitle, stageDescription: stageDescription, stageImage: stagePicture!)
            
            
            self.selectedStage = 4
        }
    }
    func goStageFive()
    {
        if proceed != nil {
            proceed.removeFromParent()
        }

        view!.subviews.forEach({ $0.removeFromSuperview() })

        if currentStage >= 5  || !stagesLocked {
            let stageTitle = "Stage 5"
            let stageDescription = "Can't see the boss? Try to shoot something else!"
            let stagePicture = UIImage(named: "beeboss")
            addProceedButton()
            
            showInfo(stageTitle, stageDescription: stageDescription, stageImage: stagePicture!)
            
            
            self.selectedStage = 5
        }
    }
    func goStageSix()
    {
        
        if proceed != nil {
            proceed.removeFromParent()
        }

        view!.subviews.forEach({ $0.removeFromSuperview() })

        if currentStage >= 6 || !stagesLocked {
            
            let stageTitle = "Stage 6"
            let stageDescription = "More Tricky!"
            let stagePicture = UIImage(named: "pigboss1")
            addProceedButton()
            
            showInfo(stageTitle, stageDescription: stageDescription, stageImage: stagePicture!)
            
            
            self.selectedStage = 6
        }
    }
    func goStageSeven()
    {
        if proceed != nil {
            proceed.removeFromParent()
        }

        view!.subviews.forEach({ $0.removeFromSuperview() })

        if currentStage >= 7 || !stagesLocked  {
            
            let stageTitle = "Stage 7"
            let stageDescription = "Shoot the bee with the help of flappy arrows or more powerful arrows!"
            let stagePicture = UIImage(named: "beeboss")
            addProceedButton()
            
            showInfo(stageTitle, stageDescription: stageDescription, stageImage: stagePicture!)
            
            
            self.selectedStage = 7
        }
    }
    func goStageEight()
    {
        if proceed != nil {
            proceed.removeFromParent()
        }

        view!.subviews.forEach({ $0.removeFromSuperview() })

        if currentStage >= 8 || !stagesLocked {
            
            let stageTitle = "Stage 8"
            let stageDescription = "What if the boss is hidden behind its small room? Destroy it first!"
            let stagePicture = UIImage(named: "whiteboss2")
            addProceedButton()
            
            showInfo(stageTitle, stageDescription: stageDescription, stageImage: stagePicture!)
            
            
            self.selectedStage = 8
        }
    }
    func goTestStage()
    {
        if proceed != nil {
            proceed.removeFromParent()
        }

        view!.subviews.forEach({ $0.removeFromSuperview() })

        print("select test stage")
        let playerName = "temp"
        let screensize = UIScreen.mainScreen().bounds.size;
        let scenesize : CGSize = CGSize(width: screensize.width, height: screensize.height)
        let gameScene = TestScene(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self, stage: 9)
        
        changeScene(gameScene)
    }
    
    
    //select stages by touch begin
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if (touchedNode.name != nil){
            //SoundEffect.getInstance().playSelectStage()
            buttonfuncs[touchedNode.name!]?(self)
        }
    }
    
    
    //define transition type to change scene
    func changeScene(scene : SKScene)
    {
        view!.subviews.forEach({ $0.removeFromSuperview() })
        if proceed != nil {
        proceed.removeFromParent()
        }

        scene.scaleMode = .AspectFit
        //let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Down, duration: 0.5)
        view?.presentScene(scene,transition: transitionType)
    }
    
    
    func readStageProgress() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        let stage = defaults.integerForKey("stageKey")
        
        return stage
    }
    
    func storeStageProgress(stage:Int) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(stage, forKey: "stageKey")
        
        defaults.synchronize()
        
        
    }
    
    func resetProcess() {
        storeStageProgress(1)
        updateProcess()
    }
    
    func updateProcess() {
        currentStage = readStageProgress()

        for (index, stage) in stages.enumerate() {
            
            if (index + 1 <= currentStage && stagesLocked) {
                stage.texture = SKTexture(imageNamed: stage.name!)
                stage.alpha = 1
            }else{
                stage.texture = SKTexture(imageNamed: "stageLock")
                stage.alpha = 0.5
            }
        }
    }
    
    func proceedToStage(){
        
        switch selectedStage {
        case (0):
            proceed.removeFromParent()
            break
        case (1):

            let gameScene = StageOne(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self, stage: 1)
            changeScene(gameScene)
        case (2):

            let gameScene = StageTwo(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self, stage: 2)
            changeScene(gameScene)
        case(3):

            let gameScene = StageThree(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self, stage: 3)
            changeScene(gameScene)
        case(4):

            let gameScene = StageFour(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self, stage: 4)
            changeScene(gameScene)
        case(5):

            let gameScene = StageFive(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self, stage: 5)
            changeScene(gameScene)
        case(6):

            let gameScene = StageSix(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self, stage: 6)
            changeScene(gameScene)
        case(7):

            let gameScene = StageSeven(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self, stage: 7)
            changeScene(gameScene)
        case(8):

            let gameScene = StageEight(size: scenesize, mainmenu: self.mainmenu, localPlayer: playerName, multiPlayerON: false, selectionScene: self, stage: 8)
            changeScene(gameScene)
       
            

            
            
        default:
            self.selectedStage = 0

            
        }
    }
    
    
}
