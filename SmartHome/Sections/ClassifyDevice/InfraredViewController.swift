//
//  InfraredViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/4/18.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class InfraredViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    //modeltag
    var strArr:[String] = ["0","1","2","3"]
    var cellArr = []
    @IBOutlet weak var MyCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="红外设备"
       // self.navigationController!.navigationBar.setBackgroundImage(UIImage(imageLiteral: "透明图片.png"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //MyCollection.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let layout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsetsMake(5,5,5,5)
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake( (ScreenWidth - 16) / 3 - 15 , (ScreenWidth - 16) / 3 - 15);
        self.MyCollection.collectionViewLayout = layout
        self.MyCollection.backgroundColor = UIColor.whiteColor()
        //注册Cell，必须要有
//        let nib = UINib(nibName: "infCell", bundle: NSBundle.mainBundle())
//        self.MyCollection.registerNib(nib , forCellWithReuseIdentifier: "inf_cell")
        MyCollection.registerNib(UINib(nibName:"infCell", bundle: nil), forCellWithReuseIdentifier:"inf")
        MyCollection.dataSource = self
        MyCollection.delegate = self
        MyCollection.backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        MyCollection.layer.cornerRadius = 24.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //定义展示的UICollectionViewCell的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return strArr.count+1;
    }
    //定义展示的Section的个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    //每个UICollectionView展示的内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("inf", forIndexPath: indexPath) as? infCell
        if indexPath.row == strArr.count{
            cell?.but.setBackgroundImage(UIImage(imageLiteral: "红外线添加"), forState: UIControlState.Normal)
            cell?.but.setTitle("", forState: UIControlState.Normal)
        }
        else{
             let infCell1:Infrared = Infrared.init(aname: strArr[indexPath.row])
            cell?.but.setBackgroundImage(UIImage(imageLiteral: "红外线"), forState: UIControlState.Normal)
            cell?.tag = indexPath.row
            cell!.myClosure = somsomeFunctionThatTakesAClosure
            cell?.xiugai = xiugai
            cell?.addLongPass()
            //cell?.but.titleLabel?.font = UIFont.systemFontOfSize(13.0)
            //cell?.but.setTitle(cellArr[indexPath.row], forState: UIControlState.Normal)
            cell?.setinf(infCell1)
            
        }
        //cellArr.addObject(cell!)
       // cellArr.indexOfObject(cell!)
        return cell!
    }
    //闭包函数
    func somsomeFunctionThatTakesAClosure(string:Int) -> Void{
        print(string)
        //cellArr.removeObject(cellArr[string])
        strArr.removeAtIndex(string)
        
        MyCollection.reloadData()
    }
    
    //闭包函数修改
    func xiugai(string:Int,str:String) -> Void{
        print(string)
        //cellArr.removeObject(cellArr[string])
        //strArr.removeAtIndex(string)
        print("int = \(string) string=\(str)")
        strArr[string] = str
        MyCollection.reloadData()
    }
    //    #pragma mark --UICollectionViewDelegate
    //UICollectionView被选中时调用的方法
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    }
    
    //返回这个UICollectionView是否可以被选择
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
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
