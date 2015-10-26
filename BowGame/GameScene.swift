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

    var controllBallradius : CGFloat = 30
    var controllPowerradius : CGFloat = 65
    var controllers : Controller!

    var touch_disable:Bool = true
    
    var startpositionOfTouch: CGPoint!
    var endpositionOfTouch: CGPoint!
    var startViewLocation: CGFloat!
    var startAnchorLocation: CGFloat!
    var startWorldLocation: CGFloat!

    var rounds : Int = 0
    
    var isshooting = false

    var localPlayer = "local"
    var enemyPlayer = "temp"

    var multiPlayerON = false
    
    var panel:ArrowPanel!

    init(size: CGSize, mainmenu: StartGameScene, localPlayer: String, multiPlayerON: Bool) {
        super.init(size: size)
        self.mainmenu = mainmenu
        self.mainmenu.setCurrentGame(self)
        self.localPlayer = localPlayer
        self.multiPlayerON = multiPlayerON
        
        self.world = SKNode()
        self.UI = SKNode()
//        self.UI.zPosition = 100;
        self.world.zPosition = -1;
        self.addChild(world)
        self.addChild(UI)
        
        self.physicsWorld.gravity = CGVectorMake(0, -2.8)
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
    }
    
    func initUI()
    {
        addArrowPanel()
        addControllers()
        addSettingButton()
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
        self.controllers = Controller(UI: self.UI , scene: self)
        controllers.addLeftController()
        controllers.addRightController()
    }
    
    //add setting button to scene
    func addSettingButton()
    {
        
        let settings = SKSpriteNode(imageNamed: InGameSettingButton )
        settings.position = CGPointMake(size.width*0.95,size.height*0.95)
        settings.name = "settings"
        settings.size = CGSize(width: 16, height: 16)
        self.UI.addChild(settings)
        
    }

    
    //add one Buff to Scene
    func addBuffs()
    {

        
    }
    
    //add one Obstacle to Scene
    func addObstacle() {

        
    }
    
    //add arrow panel
    func addArrowPanel()
    {
        panel = ArrowPanel.init()
        panel.initCell(self)
        
        
        panel.position = CGPointMake(120, 335)
        panel.xScale = 0.2
        panel.yScale = 0.2
        self.addChild(panel)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if(self.touch_disable == true){
            for child in (self.world.children) {
                if child is ClickObersever{
                    let co = child as! ClickObersever
                    co.onClick()
                }
            }
            return
        }
        
        print(touchedNode.name)
        
        if(touchedNode.name == "settings"){
            
            if multiPlayerON {
                let dataDict = NSMutableDictionary()
                dataDict.setObject(NSString(string: "true"), forKey: "QuitGame")
                dataDict.setObject(AppWarpHelper.sharedInstance.playerName, forKey: "Sender")
                
                AppWarpHelper.sharedInstance.updatePlayerDataToServer(dataDict)
            }
            
           AppWarpHelper.sharedInstance.disconnectFromServer()
            
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(mainmenu,transition: transitionType)
        }
        else if(touchedNode.name == "controlBallLeft" ) {
            print("touchLeft: ")
            print(multiPlayerON)
            print(AppWarpHelper.sharedInstance.isRoomOwner)
            
            if (multiPlayerON && !AppWarpHelper.sharedInstance.isRoomOwner) {
                return
            }
            
            leftControllerOnTouchBegin()
        }else if(touchedNode.name == "controlBallRight"){
            print("touchRight: ")
            print(multiPlayerON)
            print(AppWarpHelper.sharedInstance.isRoomOwner)
            
            if (multiPlayerON && AppWarpHelper.sharedInstance.isRoomOwner) {
                return
            }
           rightControllerOnTouchBegin()
        }else if(touchedNode.name == "arrowPanel") {
            let panel:ArrowPanel = (touchedNode as? ArrowPanel)!
            if (panel.expanded) {
                panel.resume()
            } else {
                panel.expand()
            }
        }else if(touchedNode.name == "arrowCell") {
            let arrow:ArrowCell = (touchedNode as? ArrowCell)!
            if(arrow.mArrowNum != 0) {
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
            }
        }else{
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

            let  position = touch.locationInNode(self)
            
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
            }
            
        }
    }
    func leftControllerOnTouchBegin()
    {
        startpositionOfTouch = controllers.controllBallleft.position
        endpositionOfTouch = controllers.controllBallleft.position
        if(self.panel.cells[0].mArrowNum > 0) {
            isshooting = true
        }
    }
    func rightControllerOnTouchBegin()
    {
        startpositionOfTouch = controllers.controllBallright.position
        endpositionOfTouch = controllers.controllBallright.position
        isshooting = true
    }
    func controllerShoot(position: CGPoint){ }
    func leftControllerOnTouchEnded()
    {
        controllers.bezierLayerleft1.removeFromSuperlayer()
        controllers.bezierLayerleft2.removeFromSuperlayer()
        controllers.controllBallleft.position = CGPoint(x: 100 + self.controllPowerradius - self.controllBallradius, y: 120)
    }
    func rightControllerOnTouchEnded()
    {
        controllers.bezierLayerright1.removeFromSuperlayer()
        controllers.bezierLayerright2.removeFromSuperlayer()
        controllers.controllBallright.position = CGPoint(x: self.size.width - 90 - self.controllPowerradius + self.controllBallradius, y: 120)
    }
    func controllerOnTouchEnded(){}
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if(self.touch_disable == true){
            return
        }
        

        if(self.isshooting == true)
        {
            controllerOnTouchEnded()
            if(startpositionOfTouch.x == endpositionOfTouch.x && startpositionOfTouch.y == endpositionOfTouch.y)
            {
                return
            }
            let impulse = CGVectorMake((startpositionOfTouch.x - endpositionOfTouch.x) / 9, (startpositionOfTouch.y - endpositionOfTouch.y) / 9)
            
            GameController.getInstance().currentPlayerShoot(impulse, scene: self)
            
            self.touch_disable = true
            ShootingAngle.getInstance().hide()
            
            self.panel.updateArrowNum()
            
            //Multiplayer update enemy player
            
            if multiPlayerON {
            let dataDict = NSMutableDictionary()
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
        self.world.position = CGPointMake(-self.size.width, 0)
        
        let moveCamera = SKAction.moveTo(CGPointMake(0, 0), duration: 2)
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
            let gameoverScene = GameOverScene(size: UIScreen.mainScreen().bounds.size, mainmenu: self.mainmenu)
            gameoverScene.scaleMode = self.scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            self.removeFromParent()
            self.view?.presentScene(gameoverScene,transition: transitionType)
        }
    }
    
    //display the turn information on the screen
    func showTurns(){
        let text : SKLabelNode = SKLabelNode()
        if(!multiPlayerON){
        text.text = "Round \(self.rounds)"
        }
        else if (multiPlayerON){
            if(self.rounds%2 == 0){
                text.text = "Player 2 Turn"
            }
            else {
                text.text = "Player 1 Turn"
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
        
        enemyPlayer =  dataDict.objectForKey("userName") as! String
        print(enemyPlayer)
        let stringImpulse:String = dataDict.objectForKey("impulse") as! String
        let realImpulse:CGVector = CGVectorFromString(stringImpulse)
        GameController.getInstance().currentPlayerShoot(realImpulse, scene: self)
        
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
    
}