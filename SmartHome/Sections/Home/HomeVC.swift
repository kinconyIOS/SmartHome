//
//  HomeVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire
class HomeVC: UIViewController,UITableViewDataSource,UITableViewDelegate,TouchSXT{
//    let PLAYER_NEED_VALIDATE_CODE = -1   //播放需要安全验证
//    let PLAYER_REALPLAY_START     = 1    //直播开始
//    let PLAYER_VIDEOLEVEL_CHANGE  = 2    //直播流清晰度切换中
//    let PLAYER_STREAM_RECONNECT   = 3    //直播流取流正在重连
//    let PLAYER_PLAYBACK_START     = 11   //录像回放开始播放
//    let PLAYER_PLAYBACK_STOP      = 12   //录像回放结束播放
    var btnIsSeleted = false;
    @IBOutlet var popView: UIView!
    @IBOutlet var anfangCheck: UIButton!
    var bgView:UIButton?
    @IBOutlet var jiajuCheck: UIButton!
    var timer:NSTimer?
    var judge_refresh_timer:NSTimer?
    var judge_refresh_count = 0.0
    var showSXT:Bool = false
    var sideView:SZLSideView?
     var currentRoomCode = ""
    var _btn:UIButton = UIButton(frame: CGRectMake(0,0,50,50))
    
    var head  = 1
    var cameraId = ""
    var headCell:HeadCell?
    var orientationLast:UIInterfaceOrientation?=UIInterfaceOrientation.Portrait
    var roomArray:[String]?=[]
   // let  hscroll:HScrollView ?= HScrollView.init()
    var player:EZPlayer?
    
    var tableSideViewDataSource:NSMutableArray = NSMutableArray(capacity: 10)
    
    
     var deviceDataSource = []
     var sxtData = [Equip]()
    
    @IBOutlet var homeTableView: UITableView!
    lazy var  drakBtn:UIButton = {
        
        let dark:UIButton=UIButton()
        dark.hidden=true
        dark.backgroundColor=UIColor.blackColor()
        dark.alpha=0.3
        dark.userInteractionEnabled=true
        print("创建bg")
        
        return dark
        
    }()
    
 
 
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popView.frame = CGRectMake((ScreenWidth -  (280 * ScreenWidth/320))/2, (ScreenHeight - 280 * 5 * ScreenWidth / 320 / 7)/2-70, 280 * ScreenWidth/320, 280 * 5 * ScreenWidth / 320 / 7)
   
        popView.layer.cornerRadius = 7.0
        popView.layer.masksToBounds = true
        jiajuCheck.selected = true
        self.refreshWeather()
        configView()
        registerCell()
        
     
    }
    func registerCell(){
    
        self.homeTableView.registerNib(UINib(nibName: "LightCell", bundle: nil), forCellReuseIdentifier: "LightCell")
        
        
        self.homeTableView.registerNib(UINib(nibName: "ModulateCell", bundle: nil), forCellReuseIdentifier: "ModulateCell")
        self.homeTableView.registerNib(UINib(nibName: "HeadCell", bundle: nil), forCellReuseIdentifier: "HeadCell")
        self.homeTableView.registerNib(UINib(nibName: "RecentModelCell", bundle: nil), forCellReuseIdentifier: "RecentModelCell")
         self.homeTableView.registerNib(UINib(nibName: "UnkownCell", bundle: nil), forCellReuseIdentifier: "UnkownCell")
         self.homeTableView.registerNib(UINib(nibName: "NoDeviceCell", bundle: nil), forCellReuseIdentifier: "NoDeviceCell")
        self.homeTableView.registerNib(UINib(nibName: "InfraredCell", bundle: nil), forCellReuseIdentifier: "InfraredCell")
        self.homeTableView.registerNib(UINib(nibName: "ShotLightCell", bundle: nil), forCellReuseIdentifier: "ShotLightCell")
        self.homeTableView.registerNib(UINib(nibName: "ShotWindowCell", bundle: nil), forCellReuseIdentifier: "ShotWindowCell")
        
       self.homeTableView.registerNib(UINib(nibName: "ShotLockCell", bundle: nil), forCellReuseIdentifier: "ShotLockCell")
    }
    func runTime(){
        if self.judge_refresh_count == 3
        {
            self.refreshStatus()
        }
        if self.judge_refresh_count  == 5
        {
            self.judge_refresh_timer?.invalidate()
            
            self.judge_refresh_count = 0
            return
        }
        self.judge_refresh_count += 0.5
        
    }
    func refreshWeather(){
    
        MyLocationManager.sharedManager().callback={(str:String!)in
            //天气预报 闭包回调
            weatherWithProvince(BaseHttpService.userCity(), localCity:str) {[unowned self] (weather:WeatherModel?) -> () in
                if weather == nil{
                    return;
                }
                self.headCell?.setWeatherModel( weather!)
                
            }
            
        }
        print(BaseHttpService.userCity())
        MyLocationManager.sharedManager().configLocation()
        weatherWithProvince("杭州市", localCity:BaseHttpService.userCity()) {[unowned self] (weather:WeatherModel?) -> () in
            if weather == nil{
                return;
            }
            self.headCell?.setWeatherModel( weather!)
            
        }
    }
    func configView(){
        //下拉加载
        self.homeTableView.addLegendHeaderWithRefreshingBlock { [unowned self]() -> Void in
            if self.judge_refresh_count == 0 {
             self.refreshWeather()

             self.refreshStatus()
            self.judge_refresh_timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("runTime"), userInfo: nil, repeats: true)
            self.judge_refresh_timer?.fire()
            
            }
            
            self.homeTableView.header.endRefreshing();
        }
        ////标题栏去掉
        // hscroll!.frame=CGRectMake(0,20, ScreenWidth-60, 64);
        // self.navigationItem.titleView=hscroll
        //self.navigationItem.title = "首页"
        //修改导航栏按钮；
        //摄像头
//        let bbi_l1=UIBarButtonItem(image: UIImage(named: "sxt"), style:UIBarButtonItemStyle.Plain, target:self ,action:Selector("showEZ"));
//         bbi_l1.tintColor=UIColor.whiteColor()
         self.navigationItem.leftBarButtonItems = barButton() as? [UIBarButtonItem]
        
        //修改导航栏按钮；
        
       // let bbi_r1 = UIBarButtonItem(image: UIImage(named: "scan"), style:UIBarButtonItemStyle.Plain, target:self ,action:Selector("addMainDevcie"))
       // bbi_r1.tintColor=UIColor.whiteColor()
        let bbi_r2 = UIBarButtonItem(image: UIImage(named: "deviceList"), style:UIBarButtonItemStyle.Plain, target:self ,action:Selector("modifyDeviceInfo"))
        bbi_r2.tintColor=UIColor.whiteColor()
        let bbi_r3=UIBarButtonItem(image: UIImage(named: "menu"), style:UIBarButtonItemStyle.Plain, target:self ,action:Selector("showSide"));
        bbi_r3.tintColor=UIColor.whiteColor()
        self.navigationItem.rightBarButtonItems = [bbi_r3,bbi_r2/*，bbi_r1*/]
        
        //
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("statusBarOrientationChange:"), name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
        //    self.homeTableView.registerNib(UINib(nibName: "HomeTopTableViewCell", bundle: nil), forCellReuseIdentifier:"topcell")
      
        
    }
    func barButton()->NSArray{
        let item = UIBarButtonItem(customView: createButtonWithX(0, aSelector: Selector("showEZ")))
        //  let negativeSeperator = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        return [item]//,negativeSeperator]
    }
    func createButtonWithX(x:Float,aSelector: Selector)->UIView{
       
       
        _btn.addTarget(self, action: aSelector, forControlEvents: UIControlEvents.TouchUpInside)
        _btn.setImage(UIImage(named: "sxt"), forState: UIControlState.Normal)
         _btn.setImage(UIImage(named: "sxt3"), forState: UIControlState.Selected)
        // _switch.onTintColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        
      
        return _btn
    }

    //添加主机
    func addMainDevcie(){
        let addDeviceVC: AddDeviceViewController = AddDeviceViewController(nibName: "AddDeviceViewController", bundle: nil)
        addDeviceVC.setCompeletBlock { [unowned self]() -> () in
         
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        self.navigationController?.pushViewController(addDeviceVC, animated: true)
    
    }
    //修改设备信息
    func modifyDeviceInfo(){
        let classifyVC = ClassifyHomeVC(nibName: "ClassifyHomeVC", bundle: nil)
        classifyVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(classifyVC, animated: true)
    }
    //修改房间信息
    func modifyRoomInfo(){
        let creatHomeVC = CreatHomeViewController(nibName: "CreatHomeViewController", bundle: nil)
        creatHomeVC.isSimple = true
        creatHomeVC.hidesBottomBarWhenPushed = true
       self.navigationController?.pushViewController(creatHomeVC, animated: true)
    }
    //摄像头
    func showEZ(){
        if(sxtData.count <= 0){
            showMsg("该房间没有摄像头")
            return
        }else{
            print("-----")
        showSXT = !showSXT
        _btn.selected = showSXT
        self.homeTableView.reloadData()
        
        }
       
//        let cameraType = CameraTypeTVC();
//        cameraType.hidesBottomBarWhenPushed
//            = true
//        self.navigationController?.pushViewController(cameraType, animated: true)
    }
    func getRoomInfo(){
        print("刷新侧滑菜单")
        tableSideViewDataSource.removeAllObjects()
        
        let floors = dataDeal.getModels(DataDeal.TableType.Floor) as! Array<Floor>
        for _floor in floors{
            let floor = RoomListItem()
            floor.name = _floor.name
            floor.iconName = "Floor"
            floor.isSubItem = false
            let rooms = dataDeal.getRoomsByFloor(_floor)
         
            for _room in rooms{
                
                let room  = RoomListItem()
                room.name = _room.name
                room.roomCode = _room.roomCode
                room.iconName = "Home"
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
        
        //增加默认选项
        let _floors = dataDeal.getModels(DataDeal.TableType.Floor) as! Array<Floor>
        if _floors.count > 0{
            let rooms = dataDeal.getRoomsByFloor(_floors[0])

        if rooms.count > 0 //当
        {
            
            if app.App_room == ""{
                app.App_room  = rooms[0].roomCode;
            }
            self.deviceDataSource = dataDeal.getEquipsByRoomCodeExceptSXT(app.App_room)
            print("\(self.deviceDataSource.count)")
            sxtData = [Equip]()
            sxtData = dataDeal.searchSXTModel(byRoomCode: app.App_room)
              refreshStatus()
            self.homeTableView.reloadData()
           // currentRoomCode  = rooms[0].roomCode;
//            if self.timer != nil
//            {
//                self.timer?.invalidate()
//            }
//            self.timer = nil
           // self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("refreshStatus"), userInfo: nil, repeats: true)
          
//            self.timer?.fire()
            //timer = nil;
            //run timer ;
            
              //刷新顶部按钮
        // scrollAddBtn()
            }
        }
        
    }
            
            
        func   refreshStatus(){
          
          
                let param = ["roomCode":app.App_room]
                print("----0.01\(app.App_room)0.0----")
                BaseHttpService.sendRequestAccess(deviceStatus_do, parameters: param, success: { (back) -> () in
                    print(back)
                    if back.count > 0{
                        for dic in (back as![[String:String]])
                        {
                            if self.getEquip(dic["deviceAddress"]!) != nil
                            {
                                self.getEquip(dic["deviceAddress"]!)?.status = dic["state"]!
                            }
                            
                        }
                        let indexSet = NSIndexSet(index: 2)
                        self.homeTableView.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)
                        
                    }
                    
                })
                
            }
   
//    @IBAction func closeSideViewGesture(sender: AnyObject) {
//        sideView?.closeTap()
//       
//    }
//    
//    @IBAction func openSideViewGesture(sender: AnyObject) {
//        sideView?.openTap()
//       
//    }
    func showSide(){
        print(self.sideView!.isOpen)
        if self.sideView!.isOpen
        {
            self.drakBtn.hidden=true
          self.sideView?.closeTap()
        }else{
          self.drakBtn.hidden=false
         self.sideView?.openTap()
        }
  
    }
    func passTouch(dict: [NSObject : AnyObject]!) {
        Wrapper().pushCamera(self, dict: dict)
       
    }
    override  func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
  
        self.navigationController?.navigationBarHidden  = false
//        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
       //刷新房间信息
    updateRoomInfo { () -> () in
    updateDeviceInfo({ () -> () in
         self.getRoomInfo()
    })
    }
        
        //侧滑
        if sideView==nil{
            sideView = NSBundle.mainBundle().loadNibNamed("SZLSideView", owner: self, options: nil)[0] as? SZLSideView
            sideView!.frame=CGRectMake(ScreenWidth, 0, sideView!.frame.size.width,ScreenHeight-114);
            sideView?.delegate=self
            
        }
        sideView?.hidden = false
       
        
        self.drakBtn.frame=CGRectMake(0, 0, ScreenWidth,ScreenHeight)
        self.view.addSubview(self.drakBtn)
        
        self.view.addSubview(sideView!)
        self.homeTableView.reloadData()
    }
    

   
    
        // MARK: - Table view data source
    //返回节的个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView === sideView?.tableView{ return 1}
        if tableView===self.homeTableView{return 3}
        return 1
    }
    //返回某个节中的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === sideView?.tableView{
            return tableSideViewDataSource.count+1
            
        }
        if tableView===self.homeTableView && section == 2{
            if deviceDataSource.count>1{
                return deviceDataSource.count}
            else {return 1}
        }
        if tableView===self.homeTableView && section == 0{
            return head
        }
        return 1;
    }
    //轮播摄像头的点击事件
//    func scrollPassTouch(dict: [NSObject : AnyObject]!) {
//        Wrapper().pushCamera(self, dict: dict)
//    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        if tableView===sideView?.tableView{
            
          
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
            
            
        }else if tableView===self.homeTableView{
            if indexPath.section == 0
                //摄像头及天气预报
            {
//                headCell = self.homeTableView.dequeueReusableCellWithIdentifier("HeadCell", forIndexPath: indexPath) as? HeadCell
//                headCell!.configHeadView()
//                headCell!.myScorllView.images = [UIImag e(named: "lb1")!,UIImage(named: "lb2")!]
//                headCell!.myScorllView.setupPage()
                
            
                headCell = self.homeTableView.dequeueReusableCellWithIdentifier("HeadCell", forIndexPath: indexPath) as? HeadCell
               
                if sxtData.count > 0 && showSXT{
                    print("有摄像头了")
                headCell!.configHeadView()
                var cameras = [HTCameras]()
                for equip in sxtData
                {
                    let  c = HTCameras()
                    c.ID = equip.equipID;
                    c.Name = "admin"
                    c.PassWord = equip.num
                    c.deviceType = equip.type
                    //"hificat"
                    cameras.append(c)
                }
              
                headCell!.myScorllView.dataArray = cameras
                headCell!.myScorllView.config()
                headCell!.myScorllView.setupPage()
                headCell?.myScorllView.delegate = self
                }else
                {
                  headCell!.removeHeadView()
                    
                }
                return headCell!
                
            }
         
            if indexPath.section == 1
            {
                cell = self.homeTableView.dequeueReusableCellWithIdentifier("RecentModelCell", forIndexPath: indexPath)
                cell?.backgroundColor = UIColor.whiteColor()
                
                //                BaseHttpService .sendRequestAccess(Get_gainmodel, parameters:["":""]) { (response) -> () in
                //                    print(response)
                //                    (cell as? RecentModelCell)?.models = [ChainModel]()
                //                    for model in (response as! Array<Dictionary<String,String>>)
                //                    {
                //                        let modele = ChainModel()
                //                        modele.modelName = model["modelName"]!
                //                        modele.modelId = model["modelId"]!
                //                        //modele.modelIcon = model["modelIcon"]!
                //                        (cell as? RecentModelCell)?.setmodelss(modele)
                //
                //                    }
                //                    (cell as? RecentModelCell)?.collectionView.reloadData()
                //                }
                
                //                BaseHttpService.sendRequestAccess(Get_gainmodel, parameters: [:], success: { (back) -> () in
                //                    print(back)
                //                    //放入model
                //                    var modele = ChainModel()
                //                    
                //                    })
                // (cell as? RecentModelCell)?.setmodelss()
                (cell as? RecentModelCell)?.getModel()
                tableView.bringSubviewToFront(cell!)
                return cell!
                
            }
            if deviceDataSource.count < 1
            {
            
             cell = self.homeTableView.dequeueReusableCellWithIdentifier("NoDeviceCell", forIndexPath: indexPath)
                (cell as! NoDeviceCell).showLabel.text = "该房间暂无设备，点击添加"
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
                return cell!
                
            
            }
            let equip = deviceDataSource[indexPath.row] as! Equip
            if equip.type == "1"
            {//开关设备
                 cell = self.homeTableView.dequeueReusableCellWithIdentifier("LightCell", forIndexPath: indexPath)
                 cell?.backgroundColor = UIColor.whiteColor()
                 tableView.bringSubviewToFront(cell!)
                (cell as!LightCell).setModel(equip)
            }
            else if Int(equip.type) >= 1000 && Int(equip.type)<2000 {
                //开关分开
                cell = self.homeTableView.dequeueReusableCellWithIdentifier("ShotLightCell", forIndexPath: indexPath)
                cell?.backgroundColor = UIColor.whiteColor()
                tableView.bringSubviewToFront(cell!)
                (cell as! ShotLightCell).setModel(equip)
            }
            else if Int(equip.type) >= 3000 && Int(equip.type)<4000 {
                //开关停 窗帘
                cell = self.homeTableView.dequeueReusableCellWithIdentifier("ShotWindowCell", forIndexPath: indexPath)
                cell?.backgroundColor = UIColor.whiteColor()
                tableView.bringSubviewToFront(cell!)
                (cell as! ShotWindowCell).setModel(equip)
            }
            else if equip.type == "999"{
                cell = self.homeTableView.dequeueReusableCellWithIdentifier("ShotLockCell", forIndexPath: indexPath)
                cell?.backgroundColor = UIColor.whiteColor()
                tableView.bringSubviewToFront(cell!)
                (cell as! ShotLockCell).setModel(equip)
            }
            else if equip.type == "2" || equip.type == "4"||judgeType(equip.type, type: "2")
            {//可调设备
             cell = self.homeTableView.dequeueReusableCellWithIdentifier("ModulateCell", forIndexPath: indexPath)
                 cell?.backgroundColor = UIColor.whiteColor()
                 tableView.bringSubviewToFront(cell!)
                 (cell as! ModulateCell).setModel(equip)
            }
                //todo
            else if equip.type == "99" || equip.type == "98"
                {//红外学习设备
                    cell = self.homeTableView.dequeueReusableCellWithIdentifier("InfraredCell", forIndexPath: indexPath)
                    cell?.backgroundColor = UIColor.whiteColor()
                    tableView.bringSubviewToFront(cell!)
                    (cell as! InfraredCell).setModel(equip)
            }
            else
          {
            
                cell = self.homeTableView.dequeueReusableCellWithIdentifier("UnkownCell", forIndexPath: indexPath)
                 cell?.backgroundColor = UIColor.whiteColor()
                 tableView.bringSubviewToFront(cell!)
                //(cell as! UnkownCell).setModel(equip)
            
            }
         
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
 
    func judgeType(str:String,type:String)->Bool
   {
    if str.trimString() == ""
    {
    return false
    }
    let str1 = str as NSString

    return  str1.substringToIndex(1) == type && str1.length == 4
    }
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView===sideView?.tableView{//侧滑
            if indexPath.row == 0 {
                modifyRoomInfo()
            
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
                    if (sxtData.count > 0){
                     headCell!.removeHeadView()
                    }
                    
                    self.deviceDataSource = dataDeal.getEquipsByRoomExceptSXT(Room(roomCode: item.roomCode))
                    sxtData = [Equip]()
                    sxtData = dataDeal.searchSXTModel(byRoomCode: item.roomCode)
                    //非菜单选项
                    print("点到具体房间。。\(item.roomCode)..\(self.deviceDataSource.count)---\(sxtData.count)")
                    self.homeTableView.reloadData()
                    //
                    self.sideView?.closeTap()
                     self.drakBtn.hidden=true
                   // self.currentRoomCode = item.roomCode;
                    app.App_room = item.roomCode
                    //
//                    if self.timer != nil
//                    {
//                        self.timer?.invalidate()
//                    }
//                    self.timer = nil
                    //self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("refreshStatus"), userInfo: nil, repeats: true)
                    
//                    self.timer?.fire()
                    
                    //self.timer = nil;
                    //run timer ;
                   
                   // tableView.deselectRowAtIndexPath(indexPath,animated:false)
                    refreshStatus()
                }
                
            }
        }else{//主tableview被点中
            
            if deviceDataSource.count < 1
            {
                self.modifyDeviceInfo()
                return
            }
            
        }
        
    }
   
    func getEquip(equip_id:String)->Equip?
    {
        for e in self.deviceDataSource
        {
            
            if (e as! Equip).equipID == equip_id
            {
            return e as? Equip
            }
        }
        return nil
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
            if indexPath.section == 0{
            return ScreenWidth  * 139 / 320
            }
            if indexPath.section == 1
            {
                return ScreenWidth / 4.5 - 10
            }
            if deviceDataSource.count < 1{
            return 44
            }
            let equip = deviceDataSource[indexPath.row] as! Equip
        

            if equip.type == "1" || judgeType(equip.type, type: "1")

            {
                return 65
            }
            else if equip.type == "2" || equip.type == "4"||judgeType(equip.type, type: "3")||judgeType(equip.type, type: "2")

            {
                return 65
            }
             else if equip.type == "99" || equip.type == "98"
            {
            
             return 65
            }
            return 50
        }
        if tableView === sideView?.tableView{
            
            return 55
        }
        return 55
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
        return 0.001
        }
        return 30
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRectMake(0,0,60,30))
         label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(13.0)
       
        let view = UIView(frame:  CGRectMake(0,0,ScreenWidth,30))
        view.addSubview(label)
        switch(section){
        case 0:
            
            label.text = ""
           
            break
        case 1:
            
            label.text = "  情景模式"
            let btn = UIButton(frame:  CGRectMake(60,0,ScreenWidth-120,30))
                btn.setImage(UIImage(named: "hua2"), forState: UIControlState.Normal)
                btn.setImage(UIImage(named: "hua1"), forState: UIControlState.Selected)
            btn.addTarget(self, action: Selector("open:"), forControlEvents: UIControlEvents.TouchUpInside)
            btn.selected = btnIsSeleted
            view.addSubview(btn)
            break
            
        default: label.text = "  房间设备"
        
        }
        
        return view
    }
    //手势识别
  
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        if self.timer != nil
//        {
//            self.timer?.invalidate()
//        }
//        self.timer = nil
        sideView?.closeTap()
        self.drakBtn.hidden=true
        popView .removeFromSuperview()
        sideView?.hidden = true
         headCell!.removeHeadView()
        
    }

    func open(sender:UIButton){
    sender.selected = !sender.selected
        btnIsSeleted = sender.selected
        if sender.selected
        {
            removeOneCell()
        }else{
            addOneCell()
        }
        
    print("点击----")
    }
   func addOneCell()
     {
        head = 1
        self.homeTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Middle)
      
        
      
    }
    func removeOneCell()
    {
        

        head = 0
        self.homeTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Middle)
      
   
      
    }
    
    @IBAction func checkTap(sender: UIButton) {
        anfangCheck.selected = anfangCheck.tag == sender.tag
        jiajuCheck.selected = jiajuCheck.tag == sender.tag
    }
   
    @IBAction func qxTap(sender: UIButton) {
        popView.removeFromSuperview()
        drakBtn.hidden = true
    }
   
    @IBAction func qrTap(sender: AnyObject) {
       
        let chainView = ChainEquipAddVC()
        
        self.navigationController?.pushViewController(chainView, animated: true)
     
    }
    
    //    //MARK-转屏适配-optional
//    func statusBarOrientationChange(notification:NSNotification)
//        
//    {
//        
//        let  orientation:UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
//        if orientation == UIInterfaceOrientation.LandscapeRight||orientation == UIInterfaceOrientation.LandscapeLeft && !(orientationLast==UIInterfaceOrientation.LandscapeRight)// home键靠右
//        {
//            
//            orientationLast=UIInterfaceOrientation.LandscapeRight
//            sideView!.frame=CGRectMake(ScreenHeight-(ScreenWidth-sideView!.frame.origin.x),-35, sideView!.frame.size.width,ScreenWidth+35);
//           // hscroll!.frame=CGRectMake(0,20, ScreenHeight-60, 64);
//            self.drakBtn.frame=CGRectMake(0, 31,ScreenHeight, ScreenWidth)
//            
//        }
//        
//        if orientation == UIInterfaceOrientation.Portrait && !(orientationLast==UIInterfaceOrientation.Portrait)
//            
//        {
//            orientationLast=UIInterfaceOrientation.Portrait
//            sideView!.frame=CGRectMake(ScreenWidth-(ScreenHeight-sideView!.frame.origin.x), 0, sideView!.frame.size.width,ScreenHeight);
//           // hscroll!.frame=CGRectMake(0,20, ScreenWidth-60, 64);
//            self.drakBtn.frame=CGRectMake(0, 64, ScreenWidth,ScreenHeight)
//        }
//        
//        
//        if (orientation == UIInterfaceOrientation.PortraitUpsideDown)
//            
//        { 
//            //
//            
//        }
//        
//    }
    
}


