//
//  GameViewController.swift
//  Test
//
//  Created by ZhangYu on 9/5/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData
extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var playAsGuestButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        AppWarpHelper.sharedInstance.initializeWarp()
        AppWarpHelper.sharedInstance.gameViewController = self
        //let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        //skView.showsPhysics = true
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func startGameScene()
    {
        var screensize = UIScreen.mainScreen().bounds.size;
        var scenesize : CGSize = CGSize(width: screensize.width * 2, height: screensize.height)

        let scene = GameScene(size: scenesize, mainmenu: StartGameScene(size: view.bounds.size))
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsPhysics = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = SKSceneScaleMode.AspectFill
        skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            AppWarpHelper.sharedInstance.gameScene = scene
            skView.presentScene(scene)
        
    }

    @IBAction func playAsGuest(sender: AnyObject) {
        userNameField?.resignFirstResponder()
        
        var uName = userNameField?.text
        var uNameLength = uName?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if uNameLength>0
        {
            AppWarpHelper.sharedInstance.playerName = uName!
            AppWarpHelper.sharedInstance.connectWithAppWarpWithUserName(uName!)
        }
    }
}
