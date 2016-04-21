//
//  RecentModelCell.swift
//  SmartHome
//
//  Created by sunzl on 16/4/8.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class RecentModelCell: UITableViewCell ,UICollectionViewDataSource,UICollectionViewDelegate{
    @IBOutlet var collectionView: UICollectionView!
     var arr = [UIImage(imageLiteral: "but1.png"),UIImage(imageLiteral: "but2.png"),UIImage(imageLiteral: "but3.png"),UIImage(imageLiteral: "but4.png"),UIImage(imageLiteral: "but5.png"),UIImage(imageLiteral: "but6.png"),UIImage(imageLiteral: "but7.png"),UIImage(imageLiteral: "but8.png"),]
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.itemSize = CGSizeMake(ScreenWidth / 4 - 10, ScreenWidth / 4 - 10);
        self.collectionView.collectionViewLayout = layout
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        //注册Cell，必须要有
        let nib = UINib(nibName: "ModelCell", bundle: NSBundle.mainBundle())
        self.collectionView.registerNib(nib , forCellWithReuseIdentifier: "model_cell")
        print("sssss")
        self.collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    //定义展示的UICollectionViewCell的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6;
    }
    //定义展示的Section的个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    //每个UICollectionView展示的内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("model_cell", forIndexPath: indexPath) as? ModelCell
        cell?.but.setImage(arr[indexPath.row], forState: UIControlState.Normal)
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
    
   

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
