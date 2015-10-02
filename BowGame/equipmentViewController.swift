//
//  EquipmentViewController.swift
//  BowGame
//
//  Created by ZhangYu on 10/1/15.
//  Copyright (c) 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import CoreData
class EquipmentViewController: UIViewController {
    
    @IBOutlet weak var  mBowRow : UICollectionView!
    @IBOutlet weak var  mArrowRow : UICollectionView!
    @IBOutlet weak var  mPlayerRow : UICollectionView!
    @IBOutlet weak var  mArrowDamageText : UILabel!
    var  mCellMap : [String : UICollectionView]!
    var  mNameMap : [UICollectionView : String]!
    let mCellName = "EquipmentItem"
    
    override  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil,bundle: nibBundleOrNil)
    }
    
    convenience init(){
        
        var nibNameOrNil = String?("EquipmentViewController")
        
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mCellMap = ["ArrowItem" : mArrowRow, "BowItem" : mBowRow, "PlayerItem" : mPlayerRow]
        mNameMap = [mArrowRow : "ArrowItem", mBowRow :"BowItem",  mPlayerRow : "PlayerItem"]

        for name in mCellMap.keys{
            mCellMap[name]!.registerNib( UINib(nibName: mCellName, bundle: nil), forCellWithReuseIdentifier: mCellName)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func buttonTouched(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
extension EquipmentViewController : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EquipmentItem.itemNum(mNameMap[collectionView]!)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(mCellName, forIndexPath: indexPath) as! EquipmentItem
        cell.customize(mNameMap[collectionView]!, index: indexPath.item)
        return cell
    }
    
}
extension EquipmentViewController : UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as!EquipmentItem
       
        cell.layer.backgroundColor = UIColor.blueColor().CGColor
        cell.changeEquipment(mNameMap[collectionView]!, index: indexPath.item)
        mArrowDamageText.text = EquipmentItem.mArrowDamage[indexPath.item].description
    }
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)
    {
        var cell = collectionView.cellForItemAtIndexPath(indexPath)!
        
        cell.layer.backgroundColor = UIColor.clearColor().CGColor
    }
}