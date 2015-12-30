//
//  HomeVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class HomeVC: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    var orientationLast:UIInterfaceOrientation?=UIInterfaceOrientation.Portrait
    let array=["精选","电视剧","电影","综艺","娱乐","健康","科技","游戏","体育","搞笑"];
    let  hscroll:HScrollView?=HScrollView.init()
    
    @IBOutlet var homeTableView: UITableView!
    lazy var  drakBtn:UIButton = {
        
        let dark:UIButton=UIButton()
            dark.hidden=true
            dark.backgroundColor=UIColor.blackColor()
            dark.alpha=0.3
            dark.userInteractionEnabled=false
            print("创建bg")
        
            return dark
        
        }()
    
    var sideView:SZLSideView?
    var tableSideViewDataSource:NSMutableArray = NSMutableArray(capacity: 1)
   

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
      //  self.view.addSubview(Waiting())
        // Do any additional setup after loading the view.
    }
    override  func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //侧滑
      
        if sideView==nil{
          sideView = NSBundle.mainBundle().loadNibNamed("SZLSideView", owner: self, options: nil)[0] as? SZLSideView
          sideView!.frame=CGRectMake(ScreenWidth, 0, sideView!.frame.size.width,ScreenHeight);
            sideView?.delegate=self
            self.drakBtn.frame=CGRectMake(0, 64, ScreenWidth,ScreenHeight)
           self.tabBarController!.view.addSubview(self.drakBtn)

            self.tabBarController!.view.addSubview(sideView!)
           
        }
        
    }
    func configView(){
           self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        hscroll!.frame=CGRectMake(0,20, ScreenWidth-60, 64);
    
        self.navigationItem.titleView=hscroll
               scrollAddBtn()

        //修改导航栏按钮；
        let bbi_r=UIBarButtonItem(image: UIImage(named: ""), style:UIBarButtonItemStyle.Plain, target:self ,action:Selector("showSide"));
        bbi_r.tintColor=UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem=bbi_r;

        //
      NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("statusBarOrientationChange:"), name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
            self.homeTableView.registerNib(UINib(nibName: "HomeTopTableViewCell", bundle: nil), forCellReuseIdentifier:"topcell")

        
       //模拟数据源
        let numOfFloor=4;
        for index in 1...numOfFloor{
        let floor = RoomListItem()
            floor.name = "\(index)楼"
            floor.iconName = "\(index)楼"
            floor.isSubItem = false
        let room  = RoomListItem()
            room.name = "地下室"
            room.iconName = "地下室"
            room.isSubItem = true
        let room2  = RoomListItem()
            room2.name = "花园"
            room2.iconName="花园"
            room2.isSubItem = true
        floor.items.addObject(room)
          floor.items.addObject(room2)
        tableSideViewDataSource.addObject(floor)
        }
        
  
      

    }
    
    //导航栏scollView
    func scrollAddBtn()
    {
        for index in 1...array.count
        {
            let btn:UIButton=UIButton.init(frame: CGRectMake(0, 2, ScreenWidth/6, 30))
            //设置倒角
            btn.layer.cornerRadius=15;
            btn.setTitleColor(UIColor.blackColor(),forState:UIControlState.Normal);
            btn.backgroundColor=UIColor.clearColor()
            if index==1 {
                btn.backgroundColor=UIColor.whiteColor();
                btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            }
            btn.setTitle(array[index-1], forState: UIControlState.Normal)
            btn.tag=index
            
            btn.titleLabel?.font=UIFont.systemFontOfSize(15)
            btn.addTarget(self,action: Selector("newTap:"), forControlEvents: UIControlEvents.TouchUpInside)
            hscroll?.addButton(btn, with: 45)
        }
    }
    func newTap(btn:UIButton)
    {
        hscroll?.clearColor();
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.backgroundColor=UIColor.whiteColor();
        // selectMenuId=(int)btn.tag-1;
    }
    // MARK: - Table view data source
    //返回节的个数
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView === sideView?.tableView{ return 1}
        if tableView===self.homeTableView{return 1}
        return 1
    }
    //返回某个节中的行数
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if tableView === sideView?.tableView{
        return tableSideViewDataSource.count+1
    
        }
     if tableView===self.homeTableView{
        return 1
    }
    return 1;
    }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    
    if tableView===sideView?.tableView{
    
        var cell:UITableViewCell?
        if indexPath.row==0{
            cell = tableView.dequeueReusableCellWithIdentifier("addcell", forIndexPath: indexPath)
         
           

        
        }else{
            let item:RoomListItem = self.tableSideViewDataSource[indexPath.row-1] as! RoomListItem;
            cell = tableView.dequeueReusableCellWithIdentifier("itemcell", forIndexPath: indexPath)
            (cell! as!ItemCell).nameLabel?.text=item.name
            (cell! as!ItemCell).icon.image=UIImage(named: item.iconName)
            if item.isSubItem {
            
            cell!.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
            }
            
            
        }
        cell!.selectionStyle=UITableViewCellSelectionStyle.None
        cell!.backgroundColor=UIColor.clearColor();
        return cell!
    
    }else if tableView===self.homeTableView{
        if indexPath.row == 0{
         let cell:HomeTopTableViewCell? = tableView.dequeueReusableCellWithIdentifier("topcell",forIndexPath: indexPath) as? HomeTopTableViewCell
        let app=UIApplication.sharedApplication().delegate as! AppDelegate
        if (app.weather != nil) {
            //设置轮播图
            (cell!).images = [UIImage(named: "1.jpg")!,UIImage(named: "2.jpg")!,UIImage(named: "3.jpg")!]
             cell!.setupPage(nil)
            
             cell!.currentAddressLabel.text="当前位置:"+(app.weather?.address)!
             cell!.weatherName.text=(app.weather?.aWeather)!
             cell!.wind.text=(app.weather?.aWind)!
             cell!.maxTemp.text="最高"+(app.weather?.aMaxTemp)!+"°C"
             cell!.minTemp.text="最低"+(app.weather?.aSmallTemp)!+"°C"
             cell!.weatherIcon.sd_setImageWithURL(NSURL(string: (app.weather?.nightPictureUrl)!))
        }
        }else{
        
        
        }
    
    }
        return UITableViewCell()
    }
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            
            
        }
        
        if indexPath.row>0{
           
            let item:RoomListItem =
            self.tableSideViewDataSource[indexPath.row-1] as! RoomListItem;
          // let cell: ItemCell = tableView.dequeueReusableCellWithIdentifier("itemcell", forIndexPath: indexPath) as! ItemCell
            if item.isSubItem == false{//菜单选项
                if (item.isOpen) {
                    //收起
                 let indexSet = NSIndexSet(indexesInRange: NSMakeRange(indexPath.row, item.items.count))
                 tableSideViewDataSource.removeObjectsAtIndexes(indexSet)
                 tableView.deleteRowsAtIndexPaths( self.indexPathsOfDeal(item, nowIndexPath: indexPath) as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
                 item.isOpen = false;
                    
                } else {
                   // 按下
                  let indexSet = NSIndexSet(indexesInRange: NSMakeRange(indexPath.row, item.items.count))
                    self.tableSideViewDataSource.insertObjects(item.items as [AnyObject], atIndexes:indexSet)
                tableView.insertRowsAtIndexPaths(self.indexPathsOfDeal(item, nowIndexPath: indexPath) as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
                  item.isOpen = true;
                }
            } else {
                
                //非菜单选项
                 print("点到具体房间。。")
                tableView.deselectRowAtIndexPath(indexPath,animated:false)

            }
            
        }
        
    }
 
    //更改索引
    func indexPathsOfDeal(item:RoomListItem, nowIndexPath nowPath:NSIndexPath ) ->NSArray{
    if  item.items.count == 0 {
    return []
    }
    let mArr = NSMutableArray(capacity:1)
        //
    for i in 0..<item.items.count{
        let indexPath:NSIndexPath = NSIndexPath(forRow: nowPath.row+i+1, inSection: nowPath.section)
         mArr.addObject(indexPath)

    }
    return mArr;
    }

    
    //高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView===self.homeTableView{
        return 220
        }
        if tableView === sideView?.tableView{return 55 }
        return 55
    }
    //手势识别
    @IBAction func closeSideViewGesture(sender: AnyObject) {
        sideView?.closeTap()
        self.drakBtn.hidden=true
    }
   
    @IBAction func openSideViewGesture(sender: AnyObject) {
        sideView?.openTap()
        self.drakBtn.hidden=false
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        sideView?.closeTap()
        self.drakBtn.hidden=true
    }
    //转屏适配
    func statusBarOrientationChange(notification:NSNotification)
    
    {
    
      let  orientation:UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        if orientation == UIInterfaceOrientation.LandscapeRight||orientation == UIInterfaceOrientation.LandscapeLeft && !(orientationLast==UIInterfaceOrientation.LandscapeRight)// home键靠右
    {
        
       orientationLast=UIInterfaceOrientation.LandscapeRight
       sideView!.frame=CGRectMake(ScreenHeight-(ScreenWidth-sideView!.frame.origin.x),-35, sideView!.frame.size.width,ScreenWidth+35);
       hscroll!.frame=CGRectMake(0,20, ScreenHeight-60, 64);
        self.drakBtn.frame=CGRectMake(0, 31,ScreenHeight, ScreenWidth)
        
    }
    
    if orientation == UIInterfaceOrientation.Portrait && !(orientationLast==UIInterfaceOrientation.Portrait)
    
    {
        orientationLast=UIInterfaceOrientation.Portrait
         sideView!.frame=CGRectMake(ScreenWidth-(ScreenHeight-sideView!.frame.origin.x), 0, sideView!.frame.size.width,ScreenHeight);
        hscroll!.frame=CGRectMake(0,20, ScreenWidth-60, 64);
        self.drakBtn.frame=CGRectMake(0, 64, ScreenWidth,ScreenHeight)
    }
    
    
    if (orientation == UIInterfaceOrientation.PortraitUpsideDown)
    
    {
    
    //
    
    }
    
    }

}


