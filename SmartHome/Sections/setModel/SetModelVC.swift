//
//  SetModelVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class SetModelVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet var modelCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        let layout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.itemSize = CGSizeMake(ScreenWidth / 3 - 10, ScreenWidth / 3 - 10);
        self.modelCollectionView.collectionViewLayout = layout
        self.modelCollectionView.backgroundColor = UIColor.whiteColor()
        //注册Cell，必须要有
        let nib = UINib(nibName: "ModelCell", bundle: NSBundle.mainBundle())
        self.modelCollectionView.registerNib(nib , forCellWithReuseIdentifier: "model_cell")
        // Do any additional setup after loading the view.
    }
    //定义展示的UICollectionViewCell的个数
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7;
    }
    //定义展示的Section的个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    //每个UICollectionView展示的内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier("model_cell", forIndexPath:indexPath)
        if (cell == nil) {
            cell = NSBundle.mainBundle().loadNibNamed("ModelCell", owner: self, options: nil).first as? UICollectionViewCell
            
        }
        return cell!
    }

 //    #pragma mark --UICollectionViewDelegate
    //UICollectionView被选中时调用的方法
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //返回这个UICollectionView是否可以被选择
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
 

}
