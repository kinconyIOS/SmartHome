//
//  CameraCollectionView.swift
//  SmartHome
//
//  Created by sunzl on 16/4/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class CameraCollectionView: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    var dataSource = []
    var currentPageIndex = 0
    var needRefresh = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1)
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing  = 1;
        layout.itemSize = CGSizeMake(ScreenWidth / 2 - 2, (ScreenWidth / 2 - 2 ) / 144 * 129);
        self.collectionView.collectionViewLayout = layout
        self.collectionView.backgroundColor = UIColor.whiteColor()
        //注册Cell，必须要有
        let nib = UINib(nibName: "CameraCell", bundle: NSBundle.mainBundle())
        self.collectionView.registerNib(nib , forCellWithReuseIdentifier: "CameraCell")
        
        self.collectionView.addLegendHeaderWithRefreshingBlock { [unowned self]() -> Void in
            self.currentPageIndex = 0;
            print("刷新界面")
            EZOpenSDK.getCameraList(self.currentPageIndex++, pageSize: 10, completion: { (cameraList, error) -> Void in
                self.dataSource = []
                 print("得到结果")
                print("cameraList.count==\(cameraList.count)")
                self.dataSource = cameraList
                 print(" self.dataSource.count==\( self.dataSource.count)")
                self.collectionView.reloadData()
                self.collectionView.header.endRefreshing()
            })
    
        }
        self.collectionView.addLegendFooterWithRefreshingBlock { () -> Void in
          
            EZOpenSDK.getCameraList(self.currentPageIndex++, pageSize: 10, completion: { (cameraList, error) -> Void in
                if self.dataSource.count == 0
                {
                    self.collectionView.footer.hidden = true;
                    return;
                }
                self.dataSource.arrayByAddingObjectsFromArray(cameraList)
                self.collectionView.reloadData()
                self.collectionView.header.endRefreshing()
            })
            

        }
        self.loadEZplay();
                   // Do any additional setup after loading the view.
    }
    func loadEZplay() {
        //加载视频
        print("加载视频")
        if(GlobalKit.shareKit().accessToken != nil)
        {
            EZOpenSDK.setAccessToken(GlobalKit.shareKit().accessToken)
            print("加载已存在的AT")
        }
        else
        {
            dispatch_after(UInt64(1), dispatch_get_main_queue(), { () -> Void in
                EZOpenSDK.openLoginPage({ (accessToken:EZAccessToken!) -> Void in
                    
                    GlobalKit.shareKit().accessToken=accessToken.accessToken
                   
                })
            })
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (self.needRefresh)
        {
            self.needRefresh = false;
            self.collectionView.header.beginRefreshing()
        }
        self.collectionView.reloadData()
    }
  
    //定义展示的UICollectionViewCell的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count;
    }
    //定义展示的Section的个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    //每个UICollectionView展示的内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:CameraCell? = collectionView.dequeueReusableCellWithReuseIdentifier("CameraCell", forIndexPath:indexPath) as? CameraCell
        if (cell == nil) {
            cell = NSBundle.mainBundle().loadNibNamed("CameraCell", owner: self, options: nil).first as? CameraCell
        }
        cell?.setCameraInfo(dataSource[indexPath.row] as! EZCameraInfo)
        return cell!
    }
    
    //    #pragma mark --UICollectionViewDelegate
    //UICollectionView被选中时调用的方法
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 点击进入摄像头详情界面
                let storyBoard=UIStoryboard(name: "EZMain", bundle: nil);
        let ezlive:EZLivePlayViewController = storyBoard.instantiateViewControllerWithIdentifier("EZLivePlayViewController") as! EZLivePlayViewController
        ezlive.cameraId = (dataSource[indexPath.row] as! EZCameraInfo).cameraId
                ezlive.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(ezlive, animated: true)
    }
    
    //返回这个UICollectionView是否可以被选择
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    
}
