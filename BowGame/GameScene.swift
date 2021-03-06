//
//  GameScene.swift
//  Test
//
//  Created by ZhangYu on 9/5/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import SpriteKit
class GameScene: SKScene, SKPhysicsContactDelegate, GameControllerObserver{
    
    var mainmenu: StartGameScene!
    
    var world : SKNode!
    var UI : SKNode!


    var controllers : Controller!
    
    var touch_disable:Bool = true
    
    var startpositionOfTouch: CGPoint!
    var endpositionOfTouch: CGPoint!
    var startViewLocation: CGFloat!
    var startWorldLocation: CGFloat!
    
    var rounds : Int = 0
    
    var isshooting = false
    
    var localPlayer = "local"
    var enemyPlayer = "temp"
    
    var multiPlayerON = false
    
    var panel:ArrowPanel!
    
    var stage:Int!
    
    var muteSoundButton : SKSpriteNode!
    
    var BGM = 1

    init(size: CGSize, mainmenu: StartGameScene, localPlayer: String, multiPlayerON: Bool, stage: Int) {
        super.init(size: size)
        self.mainmenu = mainmenu
        self.mainmenu.setCurrentGame(self)
        self.localPlayer = localPlayer
        self.multiPlayerON = multiPlayerON
        self.stage = stage
        self.world = SKNode()
        self.UI = SKNode()
        //        self.UI.zPosition = 100;
        self.world.zPosition = -1;
        self.addChild(world)
        self.addChild(UI)
        
        self.physicsWorld.gravity = CGVectorMake(0, -3.3)
        self.physicsWorld.contactDelegate = self
        
        initworld()
        initUI()
        
        gameStart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
    func initworld()
    {
        GameController.getInstance().reset()
        GameController.getInstance().addGameControllerObserver(self)
        addBackground()
        addGround()
        addBorder()
        addPlayers()
        addObstacle()
        addBGM()
    }
    
    func initUI()
    {
        //addArrowPanel()
        addControllers()
        addSettingButton()
        addMuteSoundButton()
    }
    
    func addBGM()
    {
        if(self.BGM == 1) {
            SoundEffect.getInstance().playBGM()
        } else if(BGM == 2){
            SoundEffect.getInstance().playBGM2()
        }
    }
    
    
    //add Scene background picture to world node
    func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:BackgroundImage)
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: CGSizeMake(self.frame.width * 2, self.frame.height))
        background.zPosition = -100;
        background.position = CGPointMake(size.width,  size.height*0.5)
        self.world.addChild(background)
        
        print(background.frame.width)
        print(background.frame.height)
    }
    
    func addBorder()
    {
        let texture = SKTexture()
        let leftBorder = Bound(texture: texture,size: CGSizeMake(1.0, self.size.height * 8),position: CGPointMake(0, 1.0))
        self.world.addChild(leftBorder)
        
        let rightBorder = Bound(texture: texture,size: CGSizeMake(1.0, self.size.height * 8),position: CGPointMake(self.size.width * 2, 1.0))
        self.world.addChild(rightBorder)
        
        let bottomBorder = Bound(texture: texture,size: CGSizeMake(self.size.width * 2, 1.0),position: CGPointMake(self.size.width, 0))
        self.world.addChild(bottomBorder)
        
    }
    
    
    //Function adding the two players in the scene in their respective positions
    func addPlayers()
    {
        
        let player1position = CGPointMake(self.size.width * 2 * 0.1, self.size.height / 6)
        let player1 = PlayerFactory.getPlayer("player1", sceneSize: self.size, playerposition: player1position)
        
        player1.add2Scene(self, world: self.world, UI: self.UI)
        
        let player2position = CGPointMake(self.size.width * 2 * 0.9, self.size.height / 6)
        let player2 = PlayerFactory.getPlayer("player2", sceneSize: self.size, playerposition: player2position)
        player2.add2Scene(self, world: self.world, UI: self.UI)
        if multiPlayerON {
            player1.setMultiName(localPlayer)
            player2.setMultiName(enemyPlayer)
        }
    }
    
    
    //function adding ground object (for contact detection)
    func addGround()
    {
        let groundTexture = SKTexture(imageNamed: GroundTexture1)
        let ground : Ground = Ground(texture: groundTexture, size: CGSizeMake(size.width * 2, size.height / 3), position: CGPointMake(0, 0))
        ground.position = CGPointMake(size.width, 0)
        self.world.addChild(ground)
        
        let collisionframe = CGRectInset(frame, -frame.width*0.2, -frame.height*0.5)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: collisionframe)
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = CollisonHelper.ArrowMask
    }
    
    func addControllers(){
        self.controllers = Controller(UI: self.UI, world: self.world, scene: self)
        controllers.initLeftController()
        controllers.initRightController()
        if(multiPlayerON) {
            if(AppWarpHelper.sharedInstance.isRoomOwner) {
                controllers.controller_right.hidden = true
            } else {
                controllers.controller_left.hidden = true
            }
        }
    }
    
    //add setting button to scene
    func addSettingButton()
    {
        
        let settings = SKSpriteNode(imageNamed: "backbutton")
        settings.position = CGPointMake(30, size.height - 30)
        settings.name = "back"
        settings.size = CGSize(width: 30, height: 30)
        self.UI.addChild(settings)
        
    }
    
    //add muteSoundButton to scene
    func addMuteSoundButton() {
        if(SoundEffect.getInstance().getMuteSound()) {
            self.muteSoundButton = SKSpriteNode(imageNamed: "muteSound")
        } else {
            self.muteSoundButton = SKSpriteNode(imageNamed: "unmuteSound")
        }
        self.muteSoundButton.position = CGPointMake(80, size.height - 30)
        self.muteSoundButton.name = "muteSound"
        self.muteSoundButton.size = CGSize(width: 30, height: 30)
        self.UI.addChild(self.muteSoundButton)
    }
    
    //add one Buff to Scene
    func addBuffs()
    {
        
        
    }
    
    //add one Obstacle to Scene
    func addObstacle() {
        
        
    }
    
    //add arrow panel
//    func addArrowPanel()
//    {
//        panel = ArrowPanel.init()
//        panel.initCell(self)
//        
//        panel.position = CGPointMake(170, self.size.height-40)
//        panel.zPosition = 5
//        panel.xScale = 0.2
//        panel.yScale = 0.2
//        self.addChild(panel)
//        
//        
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        print(touchedNode.name)
        
        if(touchedNode.name == "restartbutton"){
            restartGame()
        }
        if(touchedNode.name == "back"){
            
            if multiPlayerON {
                let dataDict = NSMutableDictionary()
                dataDict.setObject(NSString(string: "true"), forKey: "QuitGame")
                dataDict.setObject(AppWarpHelper.sharedInstance.playerName, forKey: "Sender")
                
                AppWarpHelper.sharedInstance.updatePlayerDataToServer(dataDict)
            }
            
            AppWarpHelper.sharedInstance.disconnectFromServer()
            
            backToPreviousScene()
        }
        if(self.touch_disable == true){
            for child in (self.world.children) {
                if child is ClickObersever{
                    let co = child as! ClickObersever
                    co.onClick()
                }
            }
            return
        }

        if(touchedNode.name == "muteSound") {
            SoundEffect.getInstance().changeMuteSound()
            if(SoundEffect.getInstance().getMuteSound()) {
                self.muteSoundButton.texture = SKTexture(imageNamed: "muteSound")
                SoundEffect.getInstance().stopBMG()
            } else {
                self.muteSoundButton.texture = SKTexture(imageNamed: "unmuteSound")
                if(self.BGM == 1) {
                    SoundEffect.getInstance().playBGM()
                } else if(self.BGM == 2) {
                    SoundEffect.getInstance().playBGM2()
                }
            }
            
        }
        else if(touchedNode.name == "controller_left" ) {
            print("touchLeft: ")
            print(multiPlayerON)
            print(AppWarpHelper.sharedInstance.isRoomOwner)
            
            if (multiPlayerON && !AppWarpHelper.sharedInstance.isRoomOwner) {
                return
            }
            
            leftControllerOnTouchBegin()
        }else if(touchedNode.name == "controller_right"){
            print("touchRight: ")
            print(multiPlayerON)
            print(AppWarpHelper.sharedInstance.isRoomOwner)
            
            if (multiPlayerON && AppWarpHelper.sharedInstance.isRoomOwner) {
                return
            }
            rightControllerOnTouchBegin()
        }
        else if(touchedNode.name == "arrowPanel") {
            SoundEffect.getInstance().playMenuSelect()
            let panel:ArrowPanel = (touchedNode as? ArrowPanel)!
            if (panel.expanded) {
                panel.resume()
            } else {
                panel.expand()
            }
        }
        else if(touchedNode.name == "arrowCell") {
            
            let arrow:ArrowCell = (touchedNode as? ArrowCell)!
            if(arrow.mArrowNum != 0) {
                SoundEffect.getInstance().playMenuSelect()
                arrow.onSelected()
                /*if (arrow.selected == false) {
                arrow.selected = true
                
                for cell in panel.cells {
                if (!cell.isEqual(arrow)) {
                cell.selected = false
                }
                }
                }*/
                if (arrow.mArrowPanel.expanded) {
                    arrow.mArrowPanel.switchCell(arrow.mArrowName)
                    arrow.mArrowPanel.resume()
                }
            } else {
                SoundEffect.getInstance().playSelectFault()
            }
        }
        else{
            cameraMoveStart(touch)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        
        if(self.touch_disable == true)
        {
            return
        }
        
        for touch in (touches )
        {
            
            let  position = touch.locationInNode(self.world)
//            let  worldposition = touch.locationInNode(self.world)
            
            //setup camera location according to touch movement
            if(!self.isshooting && !self.touch_disable){
                if(startViewLocation != nil){
                    moveCameraLocation(touch)
                }
            }
            
            if(self.isshooting == true && !self.touch_disable)
            {
                self.endpositionOfTouch = position
                controllerShoot(position)
                updatePlayerAnimation(GameController.getInstance().getPlayers()[0], position: position)
            }
            
        }
    }
    
    func updatePlayerAnimation(player: Player, position:CGPoint) {
        
    }
    
    func leftControllerOnTouchBegin()
    {
        startpositionOfTouch = controllers.initposition_left
        endpositionOfTouch = controllers.initposition_left
       // if(self.panel.cells[0].mArrowNum > 0) {
            controllers.startLeftMovement()
            isshooting = true
       // } else {
        //    self.panel.remindOutofArrow()
        //}
        
    }
    func rightControllerOnTouchBegin()
    {
        startpositionOfTouch = controllers.initposition_right
        endpositionOfTouch = controllers.initposition_right
        controllers.startRightMovement()
        isshooting = true
    }
    func controllerShoot(position: CGPoint){ }
    
    func leftControllerOnTouchEnded()
    {
        controllers.resetLeftController()
    }
    func rightControllerOnTouchEnded()
    {
        controllers.resetRightController()
    }
    func controllerOnTouchEnded(){}
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if(self.touch_disable == true){
            return
        }
        
        
        if(self.isshooting == true)
        {
            controllerOnTouchEnded()

            let impulse = CGVectorMake((startpositionOfTouch.x - endpositionOfTouch.x) / 9, (startpositionOfTouch.y - endpositionOfTouch.y) / 9)
            
            GameController.getInstance().currentPlayerShoot(impulse, scene: self)
            
            self.touch_disable = true
            ShootingAngle.getInstance().hide()
            
            if self.panel != nil {
                self.panel.updateArrowNum()
            }
            
            //Multiplayer update enemy player
            
            if multiPlayerON {
                let dataDict = NSMutableDictionary()
                dataDict.setObject("1", forKey: "dictType")
                dataDict.setObject(AppWarpHelper.sharedInstance.playerName, forKey: "userName")
                let stringImpulse = NSStringFromCGVector(impulse)
                dataDict.setObject(stringImpulse, forKey: "impulse")
                
                AppWarpHelper.sharedInstance.updatePlayerDataToServer(dataDict)
            }
        }
    }
    
    
    
    /*Funciton updating the angle and posiiton of the arrow during flight */
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
        for child in (self.world.children) {
            if child is Arrow{
                let arrow = child as! Arrow
                if arrow.update(){
                    setCameraLocation(arrow.position)
                    
                }
            }
            
        }
    }
    
    override func didMoveToView(view: SKView) {
        //playAsGuest()
        
    }
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        //please use CollisonHelper to do the contact tasks.
        CollisonHelper.getInstance().didBeginContact(contact)
    }
    
    
    //center the camera location to the given potin
    func setCameraLocation(location : CGPoint)
    {
        if(location.x < size.width / 2){
            world.position = CGPointMake(0, 0)
        }
        else if(location.x > size.width + size.width / 2){
            world.position = CGPointMake(-size.width, 0)
        }
        else{
            world.position = CGPointMake(size.width / 2 - location.x, 0)
        }
        
    }
    func cameraMoveStart(touchLocation : UITouch)
    {
        self.startViewLocation = touchLocation.locationInView(self.view).x
        self.startWorldLocation = self.world.position.x
    }
    func moveCameraLocation(touch : UITouch)
    {
        let shiftInView = touch.locationInView(self.view).x - startViewLocation
        
        var worldLocation = self.startWorldLocation + shiftInView
        
        //worldLocation is in (-size.width, 0)
        if(worldLocation > 0){
            worldLocation = 0;
        }
        else if(worldLocation < -size.width){
            worldLocation = -size.width
        }
        world.position = CGPointMake(worldLocation, 0)
        
    }
    
    
    
    //show game start information and move view to P1
    func gameStart(){
        self.touch_disable = true
        self.rounds++
        var moveCamera: SKAction!
        
        if(multiPlayerON) {
            if(AppWarpHelper.sharedInstance.isRoomOwner) {
                self.world.position = CGPointMake(-self.size.width, 0)
                moveCamera = SKAction.moveTo(CGPointMake(0, 0), duration: 2)
            } else {
                self.world.position = CGPointMake(0, 0)
                moveCamera = SKAction.moveTo(CGPointMake(-self.size.width, 0), duration: 2)
            }
            
        }else{
            self.world.position = CGPointMake(-self.size.width, 0)
            moveCamera = SKAction.moveTo(CGPointMake(0, 0), duration: 2)
        }
        
        world.runAction(moveCamera)
        self.showStart()
        delay(3.0){
            self.touch_disable = false
        }
    }
    
    func showStart(){
        let text : SKLabelNode = SKLabelNode()
        text.text = "Game Start!"
        text.fontColor = SKColor.blackColor()
        text.fontSize = 65
        text.fontName = "MarkerFelt-Wide"
        text.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
        text.zPosition = 1
        self.addChild(text)
        
        let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 2.0)
        text.runAction(fadeout, completion: {
            text.removeFromParent()
            self.showTurns()
        })
        
    }
    
    
    //move to game over view
    func gameOver(){

        delay(1.0) {
            let gameoverScene = GameOverScene(size: UIScreen.mainScreen().bounds.size, mainmenu: self.mainmenu, textcontent : "GAME OVER")
            gameoverScene.scaleMode = self.scaleMode
            //let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Down, duration: 0.5)
            SoundEffect.getInstance().stopBMG()
            SoundEffect.getInstance().playLose()
            self.removeFromParent()
            self.view?.presentScene(gameoverScene,transition: transitionType)
        }
    }
    
    func youWin(){
        delay(1.0) {
            let gameoverScene = GameOverScene(size: UIScreen.mainScreen().bounds.size, mainmenu: self.mainmenu, textcontent : "You Win!")
            gameoverScene.scaleMode = self.scaleMode
            //let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Down, duration: 0.5)
            SoundEffect.getInstance().stopBMG()
            SoundEffect.getInstance().playWin()
            self.removeFromParent()
            self.view?.presentScene(gameoverScene,transition: transitionType)
            
            if (!self.multiPlayerON){
                var stageProgress =  self.readStageProgress()
                if self.stage == stageProgress{

                stageProgress = stageProgress + 1
                self.storeStageProgress(stageProgress)
                }
            }
        }
    }
    
    //display the turn information on the screen
    func showTurns(){
        let text : SKLabelNode = SKLabelNode()
        if(!multiPlayerON){
            text.text = "Round \(self.rounds)"
        }
        else if (multiPlayerON){
            
            if(AppWarpHelper.sharedInstance.isRoomOwner){
                if(self.rounds % 2 == 0){
                    text.text = "Enemy's Turn"
                }
                else {
                    text.text = "Your Turn"
                }
            }else{
                if(self.rounds % 2 == 0){
                    text.text = "Your Turn"
                }
                else {
                    text.text = "Enemy's Turn"
                }
            }
            
        }
        
        text.fontColor = SKColor.blackColor()
        text.fontSize = 65
        text.fontName = "MarkerFelt-Wide"
        text.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        text.zPosition = 1
        self.UI.addChild(text)
        
        let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        text.runAction(fadeout, completion: {
            text.removeFromParent()})
        
    }
    
    func turnChanged(turn : Int)
    {
        print("turnChanged() called")
        
        self.rounds = turn
        delay(1.0){
            if(turn % 2 == 1)
            {
                let moveCamera = SKAction.moveTo(CGPointMake(0, 0), duration: 0.5)
                self.world.runAction(moveCamera)
                self.showTurns()
            }
            else
            {
                let moveCamera = SKAction.moveTo(CGPointMake(-self.size.width, 0), duration: 0.5)
                self.world.runAction(moveCamera)
                self.showTurns()
            }
        }
        delay(1.5){
            self.touch_disable = false
            self.isshooting = false
        }
    }
    
    func updateEnemyStatus(dataDict: NSDictionary){
        
        if(dataDict.objectForKey("dictType")!.isEqual("1")){
            enemyPlayer =  dataDict.objectForKey("userName") as! String
            let stringImpulse:String = dataDict.objectForKey("impulse") as! String
            let realImpulse:CGVector = CGVectorFromString(stringImpulse)
            GameController.getInstance().currentPlayerShoot(realImpulse, scene: self)
        }
        
        else if (dataDict.objectForKey("dictType")!.isEqual("2")){
        for child in (self.world.children) {
        if child is Arrow{
        let arrow = child as! Arrow
        arrow.updatePosition(CGPointFromString((dataDict.objectForKey("arrowPosition") as! String)))
        enemyPlayer =  dataDict.objectForKey("userName") as! String
            }
            }
        }
    }
    
        
        
        func playAsGuest()
        {
        
        let uName:String = localPlayer as String
        let uNameLength = uName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if uNameLength>0
        {
        AppWarpHelper.sharedInstance.playerName = uName
        AppWarpHelper.sharedInstance.connectWithAppWarpWithUserName(uName)
        }

    }
    
    func restartGame(){}
    
    func backToPreviousScene()
    {
        //let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Down, duration: 0.5)
        SoundEffect.getInstance().stopBMG()
        view?.presentScene(mainmenu,transition: transitionType)
    }
    
    func storeStageProgress(stage:Int) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(stage, forKey: "stageKey")
        
        defaults.synchronize()
        
        
    }
    
    func readStageProgress() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        let stage = defaults.integerForKey("stageKey")
        
        return stage
    }

  

    
 
}