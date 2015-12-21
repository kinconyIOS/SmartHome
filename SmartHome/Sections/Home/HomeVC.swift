//
//  HomeVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class HomeVC: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    let array=["精选","电视剧","电影","综艺","娱乐","健康","科技","游戏","体育","搞笑"];
    let  hscroll:HScrollView?=HScrollView.init()
    var sideView:SZLSideView?
    var tableSideViewDataSource:NSMutableArray = NSMutableArray(capacity: 1)
   

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        self.view.addSubview(Waiting())
        // Do any additional setup after loading the view.
    }
    override  func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //侧滑
      
        if sideView==nil{
          sideView = NSBundle.mainBundle().loadNibNamed("SZLSideView", owner: self, options: nil)[0] as? SZLSideView
          sideView!.frame=CGRectMake(ScreenWidth, 0, sideView!.frame.size.width,ScreenHeight);
            sideView?.delegate=self
            self.tabBarController!.view.addSubview(sideView!)
           
        }
        
    }
    func configView(){
           self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        hscroll!.frame=CGRectMake(0,20, ScreenWidth-60, 64);
    
        self.navigationItem.titleView=hscroll;
        scrollAddBtn()
        let numOfFloor=3;
        for _ in 0..<numOfFloor{
        let floor = RoomListItem()
            floor.name = "层"
            floor.isSubItem = false
        let room  = RoomListItem()
            room.name = "房间"
            room.isSubItem = true
        floor.items.addObject(room)
       
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
        return 1
    }
    //返回某个节中的行数
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if tableView === sideView?.tableView{
        return tableSideViewDataSource.count+1
    
        }
    return 1;
    }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    
    if tableView===sideView?.tableView{
    
        if indexPath.row==0{
            let cell: AddCell = tableView.dequeueReusableCellWithIdentifier("addcell", forIndexPath: indexPath) as! AddCell
            cell.backgroundColor=UIColor.clearColor();
            return cell

        
        }else{
            let item:RoomListItem = self.tableSideViewDataSource[indexPath.row-1] as! RoomListItem;
            let cell: ItemCell = tableView.dequeueReusableCellWithIdentifier("itemcell", forIndexPath: indexPath) as! ItemCell
            cell.textLabel?.text=item.name
            cell.backgroundColor=UIColor.clearColor();
            return cell
            
        }
    
    }
        return UITableViewCell()
    }
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row>0{
           
            let item:RoomListItem =
            self.tableSideViewDataSource[indexPath.row-1] as! RoomListItem;
           let cell: ItemCell = tableView.dequeueReusableCellWithIdentifier("itemcell", forIndexPath: indexPath) as! ItemCell
            if item.isSubItem == false{//菜单选项
                if (item.isOpen) {
                    //收起
                           let indexSet = NSIndexSet(indexesInRange: NSMakeRange(indexPath.row-1, item.items.count))
                    tableSideViewDataSource.removeObjectsAtIndexes(indexSet)
                        //removeObjectsInArray(item.items as [AnyObject])
                   
               tableView.deleteRowsAtIndexPaths( self.indexPathsOfDeal(item, nowIndexPath: indexPath) as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
                    
                  
                    item.isOpen = false;
                } else {
                   // 按下
                  let indexSet = NSIndexSet(indexesInRange: NSMakeRange(indexPath.row-1, item.items.count))
                   
                    self.tableSideViewDataSource.insertObjects(item.items as [AnyObject], atIndexes:indexSet)
                   
                    
                    tableView.insertRowsAtIndexPaths(self.indexPathsOfDeal(item, nowIndexPath: indexPath) as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
                   
                    //cell.storeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", cell.imageName]];
                    item.isOpen = true;
                }
            } else {//非菜单选项
                if (item.isOpen) {
                    //收起
                    item.isOpen = false;
                } else {
                  self.tableView(tableView, closeItemExcept: indexPath)
                    //展开
                    item.isOpen =  true;
                }
            }
            
        }
        
    }
    
    func tableView(tableView:UITableView, closeItemExcept indexPath:NSIndexPath) {
        for index in 0..<self.tableSideViewDataSource.count
        {
            let item:RoomListItem = self.tableSideViewDataSource[index] as! RoomListItem
            if (item.isSubItem) {
                if (item.isOpen && indexPath.row-1 != index) {
                    // StoreTableCell *cell = (StoreTableCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    // cell.storeImage.image = [UIImage imageNamed:cell.imageName];
                    item.isOpen = false;
                }
            }
        }
    }
    //更改索引
    func indexPathsOfDeal(item:RoomListItem, nowIndexPath nowPath:NSIndexPath ) ->NSArray{
    if  item.items.count == 0 {
    return []
    }
        print(item.items.count)
    let mArr = NSMutableArray(capacity:1)
    for i in 0..<item.items.count{
         print("here7")
        let indexPath:NSIndexPath = NSIndexPath(forRow: nowPath.row+i+1, inSection: nowPath.section)
       
        mArr.addObject(indexPath)

    }
    return mArr;
    }

    
    //高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    //手势识别
    @IBAction func closeSideViewGesture(sender: AnyObject) {
        sideView?.closeTap()
    }
   
    @IBAction func openSideViewGesture(sender: AnyObject) {
        sideView?.openTap()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        sideView?.closeTap()
    }
}


