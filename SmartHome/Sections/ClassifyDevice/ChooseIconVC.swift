//
//  ChooseIconVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/31.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit


class ChooseIconVC: UICollectionViewController {
    
    var itemDataSource: [String : [String]] = ["为你的设备选取图标" : ["调光灯泡", "开关灯泡", "普通灯泡", "挂式空调", "立式空调","中央空调", "窗帘", "电视"]]
    var sectionDataSource: [String] = ["为你的设备选取图标"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(ScreenWidth / 3 - 1, ScreenWidth / 3 - 1)
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 30)
        self.collectionView!.collectionViewLayout = flowLayout
        
        self.collectionView!.registerNib(UINib(nibName: "ChooseHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "chooseheaderview")
        self.collectionView!.registerNib(UINib(nibName: "EquipCollectionCell", bundle: nil), forCellWithReuseIdentifier: "equipcollectioncell")

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionDataSource.count
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return itemDataSource[sectionDataSource[section]]!.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("equipcollectioncell", forIndexPath: indexPath) as! EquipCollectionCell
        cell.equipName.text = itemDataSource[sectionDataSource[indexPath.section]]![indexPath.item]
        cell.equipImage.image = UIImage(named: itemDataSource[sectionDataSource[indexPath.section]]![indexPath.item])
        // Configure the cell
    
        return cell
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "chooseheaderview", forIndexPath: indexPath) as! ChooseHeaderView
            headerView.viewTitleLabel.text = sectionDataSource[indexPath.section]
        
        return headerView
    }
    
    
    
    
    
    // MARK: UICollectionViewDelegate
    
    private var imageAction: ((imageName:String) -> ())?
    
    func chooseImageBlock(block: (imageName:String) -> ()) {
        imageAction = block
    }
    

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        imageAction?(imageName:itemDataSource[sectionDataSource[indexPath.section]]![indexPath.item])
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
}
