//
//  GameViewController.swift
//  Test
//
//  Created by ZhangYu on 9/5/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import UIKit
import SpriteKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*** Set Delegate UIViewController ***/
        EasyGameCenter.sharedInstance(self)
        
        let scene = StartGameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsPhysics = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = SKSceneScaleMode.AspectFill
        skView.presentScene(scene)
        //skView.showsPhysics = true
    }
    
    /**
    Notifies the view controller that its view was added
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /*** Set View Controller delegate, that's when you change UIViewController ***/
        EasyGameCenter.delegate = self
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
}
