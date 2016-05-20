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
    var name = ["相库","资讯","圈子","分享"]
    var arr = [UIImage(imageLiteral: "xc.png"),UIImage(imageLiteral: "zx.png"),UIImage(imageLiteral: "qz.png"),UIImage(imageLiteral: "share.png")]
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden  = false
        //        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        //self.navigationController?.navigationBar.backgroundColor =  UIColor(patternImage: navBgImage!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.backgroundColor =  UIColor(patternImage: navBgImage!)
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        let layout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.itemSize = CGSizeMake(ScreenWidth / 4 - 10, ScreenWidth / 4 - 10);
        self.modelCollectionView.collectionViewLayout = layout
        self.modelCollectionView.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "发现"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //注册Cell，必须要有
        //let nib = UINib(nibName: "ModelCell", bundle: NSBundle.mainBundle())
        //self.modelCollectionView.registerNib(nib , forCellWithReuseIdentifier: "model_cell")
        modelCollectionView.registerNib(UINib(nibName:"ModelCell", bundle: nil), forCellWithReuseIdentifier:"model_cell")
        // Do any additional setup after loading the view.
    }
    //定义展示的UICollectionViewCell的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4;
    }
    //定义展示的Section的个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    //每个UICollectionView展示的内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //        var cell:UICollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier("model_cell", forIndexPath:indexPath)
        //        if (cell == nil) {
        //            cell = NSBundle.mainBundle().loadNibNamed("ModelCell", owner: self, options: nil).first as? UICollectionViewCell
        //
        //        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("model_cell", forIndexPath: indexPath) as? ModelCell
        cell?.icon.image = arr[indexPath.row]
         cell?.name.text = name[indexPath.row]
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
