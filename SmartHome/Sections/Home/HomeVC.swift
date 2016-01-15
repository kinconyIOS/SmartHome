//
//  HomeVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire
class HomeVC: UIViewController ,UITableViewDataSource,UITableViewDelegate ,EZPlayerDelegate{
    let PLAYER_NEED_VALIDATE_CODE = -1 //播放需要安全验证
    let PLAYER_REALPLAY_START = 1   //直播开始
    let PLAYER_VIDEOLEVEL_CHANGE = 2 //直播流清晰度切换中
    let PLAYER_STREAM_RECONNECT = 3  //直播流取流正在重连
    let PLAYER_PLAYBACK_START = 11 //录像回放开始播放
    let PLAYER_PLAYBACK_STOP = 12   //录像回放结束播放
    
    var sideView:SZLSideView?
    var headView : HomeTopView?
    
    var flag = false
    var cameraId = ""
    let vfcode="at.6wm8ormqcy03shfib5yeb9yyah3r2cp4-171ujmx9ol-0oc00e3-seti9m9p5"
    var orientationLast:UIInterfaceOrientation?=UIInterfaceOrientation.Portrait
    var roomArray:[String]?=[]
    let  hscroll:HScrollView?=HScrollView.init()
    var player:EZPlayer?
    
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
    
    
    var tableSideViewDataSource:NSMutableArray = NSMutableArray(capacity: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("configView"), userInfo: nil, repeats: false)
        configView()
        
        
        //  self.view.addSubview(Waiting())
        // Do any additional setup after loading the view.
    }
    func configView(){
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        hscroll!.frame=CGRectMake(0,20, ScreenWidth-60, 64);
        
        self.navigationItem.titleView=hscroll
       
        
        //修改导航栏按钮；
        let bbi_r=UIBarButtonItem(image: UIImage(named: ""), style:UIBarButtonItemStyle.Plain, target:self ,action:Selector("showSide"));
        bbi_r.tintColor=UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem=bbi_r;
        
        //
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("statusBarOrientationChange:"), name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
        //    self.homeTableView.registerNib(UINib(nibName: "HomeTopTableViewCell", bundle: nil), forCellReuseIdentifier:"topcell")
        getRoomInfo()

     }
    func getRoomInfo(){
    

       let floors = dataDeal.getModels(DataDeal.TableType.Floor) as! Array<Floor>
        for _floor in floors{
                     let floor = RoomListItem()
                       floor.name = _floor.name
                    floor.iconName = "1楼"
                      floor.isSubItem = false
            let rooms = dataDeal.getRoomsByFloor(_floor)
            for _room in rooms{
            
                let room  = RoomListItem()
                            room.name = _room.name
                            room.iconName = "地下室"
                            room.isSubItem = true
             floor.items.addObject(room)
            
            }
            tableSideViewDataSource.addObject(floor)
            
        }
        //刷新数据
        self.sideView?.tableView.reloadData()
        roomArray=[]
        let allrooms = dataDeal.getModels(DataDeal.TableType.Room) as! Array<Room>
        for room in allrooms{
         roomArray?.append(room.name)
        }
        //刷新顶部按钮
         scrollAddBtn()

    }
    func loadEZplay() {
        //加载视频
        if(GlobalKit.shareKit().accessToken != nil)
        {
            EZOpenSDK.setAccessToken(GlobalKit.shareKit().accessToken)
            self.addRefreshKit()
        }
        else
        {
            
            
            dispatch_after(UInt64(1), dispatch_get_main_queue(), { () -> Void in
                EZOpenSDK.openLoginPage({ (accessToken:EZAccessToken!) -> Void in
                    
                    GlobalKit.shareKit().accessToken=accessToken.accessToken
                    self.addRefreshKit()
                })
            })
        }

    }

   
    func addRefreshKit()
    {
        EZOpenSDK.getCameraList(0, pageSize: 1) { (cameraList:[AnyObject]!, error:NSError!) -> Void in
            
            let camera = cameraList.first as!EZCameraInfo
            self.cameraId = camera.cameraId
            self.player = EZPlayer.createPlayerWithCameraId(camera.cameraId!)
            self.player?.delegate = self;
            
            self.player?.startRealPlay()
           
            self.player?.setPlayerView(self.headView?.playView)
           }
    }
    

    
    override  func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        flag = false
        //加载
        loadEZplay()
      //侧滑
        if sideView==nil{
            sideView = NSBundle.mainBundle().loadNibNamed("SZLSideView", owner: self, options: nil)[0] as? SZLSideView
            sideView!.frame=CGRectMake(ScreenWidth, 0, sideView!.frame.size.width,ScreenHeight);
            sideView?.delegate=self
            
        }
         sideView?.hidden = false
        if headView == nil{
            headView = NSBundle.mainBundle().loadNibNamed("HomeTopView", owner:self, options: nil)[0] as? HomeTopView
            
          //  headView!.frame=;
            self.homeTableView.tableHeaderView = headView
              self.homeTableView.tableHeaderView?.frame=CGRectMake(0, 0, ScreenWidth,ScreenWidth)
            headView?.playView.userInteractionEnabled = true
            let tapGR = UITapGestureRecognizer(target: self, action: "tapHandler:")
            headView?.playView.addGestureRecognizer(tapGR)
            headView?.backgroundColor=UIColor.brownColor()
            //设置轮播图
            headView!.images = [UIImage(named: "轮播1")!,UIImage(named: "轮播2")!,UIImage(named: "轮播3")!]
            headView!.setupPage()
            //设置轮播图和摄像头
            configEZopenImg()
            //设置天气
            if (app.weather == nil) {
                weatherWithProvince("北京市", localCity:"北京市") { (weather:WeatherModel) -> () in
                    app.weather = weather
                    self.headView?.setWeatherModel(weather)
                }
            }else{
                self.headView?.setWeatherModel(app.weather!)
            }
        }
        
        self.drakBtn.frame=CGRectMake(0, 64, ScreenWidth,ScreenHeight)
        self.tabBarController!.view.addSubview(self.drakBtn)
        
        self.tabBarController!.view.addSubview(sideView!)
    }
    //////手势处理函数
    func tapHandler(sender:UITapGestureRecognizer) {
        ///////todo....
                    let storyBoard=UIStoryboard(name: "EZMain", bundle: nil);
                    let livePlayViewController = storyBoard.instantiateViewControllerWithIdentifier("EZLivePlayViewController") as! EZLivePlayViewController
                    livePlayViewController.cameraId = self.cameraId
                    livePlayViewController.cameraName = "测试"
        livePlayViewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(livePlayViewController, animated: true)
    }
    func configEZopenImg(){
        headView?.playView.hidden = !flag
        headView?.pageControl.hidden = flag
        headView?.scrollView.hidden = flag
        
    }
 
    //MARK- ezplayer delegate
    func player(player: EZPlayer!, didPlayFailed error: NSError!) {
        flag = false
        configEZopenImg()
    }
    func player(player: EZPlayer!, didReceviedMessage messageCode: Int) {
        if(messageCode == PLAYER_REALPLAY_START)
        {
            print("开始播放");
            flag = true
            self.player?.stopVoiceTalk()
            self.player?.closeSound()
            configEZopenImg()
        }
        else if (messageCode == PLAYER_NEED_VALIDATE_CODE)
        {
            print("需要短信验证")
            EZOpenSDK.secureSmsValidate("BJLKLK"){
                (error:NSError!) in
               // self.player?.startRealPlay()
                
            }
        }
    }
    //导航栏scollView
    func scrollAddBtn()
    {
        for index in 0..<roomArray!.count
        {
            let btn:UIButton=UIButton.init(frame: CGRectMake(0, 2, ScreenWidth/6, 30))
            //设置倒角
            btn.layer.cornerRadius=15;
            btn.setTitleColor(UIColor.blackColor(),forState:UIControlState.Normal);
            btn.backgroundColor=UIColor.clearColor()
            if index==0 {
                btn.backgroundColor=UIColor.whiteColor();
                btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            }
            btn.setTitle(roomArray![index], forState: UIControlState.Normal)
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
  
            
        }
        return UITableViewCell()
    }
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView===sideView?.tableView{//侧滑
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
        }else{//主tableview被点中
        
        
        
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
        super.viewWillDisappear(animated)
        sideView?.closeTap()
        self.drakBtn.hidden=true
        sideView?.hidden = true
    }
    //MARK-转屏适配-optional
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


