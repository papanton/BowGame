//
//  StageInfo.swift
//  BowGame
//
//  Created by Antonis papantoniou on 11/21/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//


import UIKit

@IBDesignable class StageInfo: UIView {
    
    // Our custom view from the XIB file

    @IBOutlet var view: UIView!
    var nibName = "StageInfo"
    // Outlets
    

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet var textView: UILabel!
    
    @IBOutlet weak var goButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib ()
    }
    
    /*
    Function loading nib data from xib.
    
    */
    func loadViewFromNib() {
        view = loadHudFromNib()
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.blackColor().CGColor
//        view.backgroundColor=UIColor(patternImage: UIImage(named:"textBackground")!)
        
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        view.layer.cornerRadius = 10
        textView.backgroundColor = UIColor.clearColor()
        addSubview(view)

        
        
    }
    
    func loadHudFromNib() ->UIView {
        
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
        
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if (CGRectContainsPoint(imageView.frame, point) || CGRectContainsPoint(textView.frame,point) || CGRectContainsPoint(title.frame,point) || CGRectContainsPoint( self.view.frame,point) ) {
            return true
        }
        return false
    }
    /*
    Function to round UIImageView that contains users profile picture
    */
    func roundProfileImage() {
        self.imageView.layer.borderWidth = 1
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.borderColor = UIColor.blackColor().CGColor
        self.imageView.layer.cornerRadius = imageView.frame.height/2
        self.imageView.clipsToBounds = true
    }
    
}
