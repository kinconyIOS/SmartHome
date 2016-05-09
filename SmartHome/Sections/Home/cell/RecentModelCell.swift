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
  var arr = [UIImage(imageLiteral: "icon1.png"),UIImage(imageLiteral: "icon2.png"),UIImage(imageLiteral: "icon3.png"),UIImage(imageLiteral: "icon4.png"),UIImage(imageLiteral: "icon5.png"),UIImage(imageLiteral: "icon6.png"),UIImage(imageLiteral: "icon7.png"),UIImage(imageLiteral: "icon8.png"),]
    var name = ["回家","上班","娱乐","就餐","回家","上班","娱乐","就餐"]
    var models = [ChainModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.itemSize = CGSizeMake(ScreenWidth / 4.5 - 10, ScreenWidth / 4.5 - 10);
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
        return name.count + 1;
    }
    //定义展示的Section的个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    //每个UICollectionView展示的内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        if indexPath.row == name.count
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("model_cell", forIndexPath: indexPath) as? ModelCell
            cell?.icon.image = UIImage(named: "icon_add_model")
            cell?.name.text = "添加"
            return cell!
        
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("model_cell", forIndexPath: indexPath) as? ModelCell
        cell?.icon.image = arr[indexPath.row]
        cell?.name.text = name[indexPath.row]
        return cell!
    }
    
    //    #pragma mark --UICollectionViewDelegate
    //UICollectionView被选中时调用的方法
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == name.count
        {
         let homevc = self.parentController() as! HomeVC
            homevc.drakBtn.hidden=false
            homevc.view .addSubview(homevc.popView)
            print("点击添加");
        }else
        {
        // 使用
        }
    }
    
    func parentController()->UIViewController?
    {
        for (var next = self.superview; (next != nil); next = next!.superview) {
            let nextr = next?.nextResponder()
            if nextr!.isKindOfClass(HomeVC.classForCoder()){
            return (nextr as! UIViewController)
            }
           
        }
        return nil
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
