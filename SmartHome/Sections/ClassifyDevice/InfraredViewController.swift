//
//  InfraredViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/4/18.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit


class InfraredViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,pusView{

    //代理
    func pus() {
        //从xib拉去
//        let indvc:AlterViewController=AlterViewController(nibName: "AlterViewController", bundle: nil)
//        indvc.alteText = "添加红外线";
//        indvc.textName = ""
//        //将当前someFunctionThatTakesAClosure函数指针传到第二个界面，第二个界面的闭包拿到该函数指针后会进行回调该函数
//        indvc.myClosure = somsomeFunctionThatTakesAClosure1
        //self.navigationController!.pushViewController(indvc, animated:true)
    }
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

        //导航栏右边按钮
        self.navigationItem.rightBarButtonItems = self.barButton() as? [UIBarButtonItem]
        
    }

    func inconAction(sender:UISwitch){
        if sender.on
        {
        print("open")
        }
        else
        {
        print("close")
        }
    }

    func barButton()->NSArray{
        let item = UIBarButtonItem(customView: createButtonWithX(0, aSelector: Selector("inconAction:")))
      //  let negativeSeperator = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        return [item]//,negativeSeperator]
    }
    func createButtonWithX(x:Float,aSelector: Selector)->UISwitch{
        let _switch = UISwitch()
    
        _switch.addTarget(self, action: aSelector, forControlEvents: UIControlEvents.ValueChanged)
       // _switch.onTintColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
       
        let _label1 = UILabel(frame:CGRectMake(0,0,_switch.frame.size.width/2,_switch.frame.size.height));
        _label1.textAlignment = NSTextAlignment.Center
        _label1.textColor = UIColor.whiteColor()

        _label1.font = UIFont.systemFontOfSize(12)
        _label1.text = "控"
        
        let _label2 = UILabel(frame:CGRectMake(_switch.frame.size.width/2,0,_switch.frame.size.width/2,_switch.frame.size.height));
        _label2.textAlignment = NSTextAlignment.Center
        _label2.textColor = UIColor.whiteColor()
        
        _label2.font = UIFont.systemFontOfSize(12)
        _label2.text =  "学"
       
        _switch.addSubview(_label1)
         _switch.addSubview(_label2)
        return _switch
    }
    //添加红外线 界面
    func addinf1(notification: NSNotification){
        //从xib拉去
        let indvc:AlterViewController=AlterViewController(nibName: "AlterViewController", bundle: nil)
        indvc.alteText = "添加红外线";
        indvc.textName = ""
        //将当前someFunctionThatTakesAClosure函数指针传到第二个界面，第二个界面的闭包拿到该函数指针后会进行回调该函数
        indvc.myClosure = somsomeFunctionThatTakesAClosure1
        self.navigationController!.pushViewController(indvc, animated:true)
        
    }
    //闭包函数 获取姓名
    func somsomeFunctionThatTakesAClosure1(string:String) -> Void{
        print(string)
        strArr.append(string)
        self.MyCollection.reloadData()
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
        //注册消息点击添加红外线
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addinf1:", name: "a", object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        print("tuochu")
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
            cell?.JudgeI = 1
            cell?.delegate = self
        }
        else{
             let infCell1:Infrared = Infrared.init(aname: strArr[indexPath.row])
            cell?.but.setBackgroundImage(UIImage(imageLiteral: "红外线"), forState: UIControlState.Normal)
            cell?.JudgeI = 0
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
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//
//    }
    
    //返回这个UICollectionView是否可以被选择
//    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
