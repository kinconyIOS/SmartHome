//
//  CreatHomeViewController.swift
//  SmartHome
//
//  Created by kincony on 15/12/25.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire


enum BuildType {
    case BuildFloor, BuildRoom
}

func ==(lhs: Building, rhs: Building) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class Building : Hashable {
    var buildType = BuildType.BuildRoom
    var buildName: String = ""
    var buildCode: String = ""
    var isAddCell = false
    var floor: Building?
    var isUnfold: Bool = false
    
    
    init(buildType: BuildType, buildName: String, isAddCell: Bool) {
        self.buildType = buildType
        self.buildName = buildName
        self.isAddCell = isAddCell
    }
    
    var hashValue: Int {
        return "\(buildType),\(buildName),\(isAddCell),\(floor),\(isUnfold)".hashValue
    }
    
}

class CreatHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    var isSimple = false
    @IBOutlet var tableView: UITableView! {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self

        }
    }
    @IBOutlet var addFloorBtn: UIButton! {
        didSet{
            addFloorBtn.layer.cornerRadius = 5
            addFloorBtn.layer.masksToBounds = true
            addFloorBtn.backgroundColor = themeColors
        }
    }
    
    var floorArr: [Building] = []
    var roomDic: [String : [Building]] = [String : [Building]]()
    var dataSource: [Building] = []
    
    
    
    //楼层信息组装
    func assembleFloor() -> String {
        var subArr = [[String : String]]()
        for floor in floorArr {
            subArr.append(["floorName" : floor.buildName,"floorCode" : floor.buildCode])
           
        }
        
        return dataDeal.toJSONString(subArr)
    }
    
    //房间信息组装
    func assembleRoom() -> String {
    
        var subArr: [[String : String]] = []
        for key in roomDic.keys {
            for value in roomDic[key]! {
                if value != roomDic[key]?.last {
                    var suDic = ["roomName" : value.buildName]
                    suDic["floorName"] = key
                    suDic["roomCode"] = value.buildCode
                    subArr.append(suDic)
                }
            }
        }
       
        return dataDeal.toJSONString(subArr)
    }
    
    
    
    @IBAction func handleTapTableView(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBOutlet var tapTableView: UITapGestureRecognizer! {
        didSet {
            tapTableView.delegate = self
        }
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        navigationItem.title = "创建我的家"
        //navigationController?.navigationBar.setBackgroundImage(UIImage(named: "导航栏L"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleRightItem:"))
        
        tableView.registerNib(UINib(nibName: "FloorCell", bundle: nil), forCellReuseIdentifier: "floorcell")
        tableView.registerNib(UINib(nibName: "RoomCell", bundle: nil), forCellReuseIdentifier: "roomcell")
        tableView.registerNib(UINib(nibName: "AddRoomCell", bundle: nil), forCellReuseIdentifier: "addroomcell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        updateRoomInfo { () -> () in
        
        self.getRoomInfoForCreate()
            self.tableView.reloadData()
        }
        
    }
    func getRoomInfoForCreate(){
        
        //得到所有floor
        let floors = dataDeal.getModels(DataDeal.TableType.Floor) as! Array<Floor>
        for _floor in floors{
            let floor = Building(buildType: .BuildFloor, buildName:  _floor.name, isAddCell: false)
            floor.buildCode = _floor.floorCode
            floorArr.append(floor)
            dataSource.append(floor)
            let rooms = dataDeal.getRoomsByFloor(_floor)
           floor.isUnfold = false//打开
            
             var roomArr: [Building] = []
            for _room in rooms{
                let room = Building(buildType: .BuildRoom, buildName: _room.name, isAddCell: false)
                room.buildCode = _room.roomCode
                print(room.buildName)
                room.floor = floor
                roomArr.append(room)
               dataSource.append(room)//添加房间
                
                
            }
            
            let add = Building(buildType: .BuildRoom, buildName: "添加", isAddCell: true)
            add.floor = floor
            roomArr.append(add)
             dataSource.append(add)//添加房间
            roomDic[floor.buildName] = roomArr
           
            
        }
       

        
    }
    @IBAction func handleAddFloor(sender: UIButton) {
        var floor:Building?
        if floorArr.count == 0{
         floor = Building(buildType: .BuildFloor, buildName: "楼层", isAddCell: false)
        }else{
         floor = Building(buildType: .BuildFloor, buildName: "\(floorArr[floorArr.count-1].buildName)_1", isAddCell: false)
        }
        floorArr.append(floor!)
        dataSource.append(floor!)
        let add = Building(buildType: .BuildRoom, buildName: "添加", isAddCell: true)
        add.floor = floor
        roomDic[floor!.buildName] = [add]
//        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: dataSource.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
        tableView.reloadData()
    }
    func handleRightItem(barButton: UIBarButtonItem) {
        
        var parameter: [String : AnyObject] = [:]
        parameter["roomInfo"] = assembleRoom()
        parameter["floorInfo"] = assembleFloor()
        print("------\(parameter["roomInfo"])")
        print("------\(parameter["floorInfo"])")
        BaseHttpService .sendRequestAccess(updatinfo, parameters: parameter) { (back) -> () in
            // 更新一个版本号上传到服务器上面
            
            
           
            
         
                updateRoomInfo({ () -> () in
                    showMsg("保存成功");
                    if self.isSimple {
                        
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        return
                    }
                    let addDeviceVC: AddDeviceViewController = AddDeviceViewController(nibName: "AddDeviceViewController", bundle: nil)
                    addDeviceVC.setCompeletBlock { () -> () in
//                        let classifyVC = ClassifyHomeVC(nibName: "ClassifyHomeVC", bundle: nil)
//                        self.navigationController?.pushViewController(classifyVC, animated: true)
                        app.window!.rootViewController = TabbarC()
                    }
                    self.navigationController?.pushViewController(addDeviceVC, animated: true)
                })
            
                        
            
                }
       
    

    }
 
    
    func checkDuplicateName(text: String) -> Bool {
        for floor in floorArr {
            if text == floor.buildName {
                return false
            }
        }
        return true
    }
    func checkDuplicateRoomName(text: String,floorName:String) -> Bool {
        
        for room in roomDic[floorName]! {
            if text == room.buildName {
                return false
            }
        }
        return true
    }
    
    // MARK - tableView data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let building = dataSource[indexPath.row]
        switch building.buildType {
        case .BuildFloor:
            let cell = tableView.dequeueReusableCellWithIdentifier("floorcell", forIndexPath: indexPath) as! FloorCell
            cell.indexPath = indexPath
            cell.floorName.text = building.buildName
            cell.unfoldBtn.selected = building.isUnfold
            
            cell.configEndEditing({ [unowned self, unowned cell] (text) -> () in
                let oldName = building.buildName
                if text.trimString() == "" {
                    print("oldName=\(oldName)")
                     showMsg("楼层名不能为空")
                    // cell.floorName.text = oldName
               
                }else if self.checkDuplicateName(text) {
                    building.buildName = text
                    self.roomDic[text] = self.roomDic[oldName]
                    self.roomDic.removeValueForKey(oldName)
                } else if text != oldName {
                  
                    cell.floorName.text = oldName
                      showMsg("楼层名已存在")
                    
                }
            })
            
            cell.configKeyboardAdpt({ [unowned self] (index: NSIndexPath) -> () in
                let nowCell = self.tableView.cellForRowAtIndexPath(index)
                let rect = UIApplication.sharedApplication().keyWindow?.convertRect((nowCell?.frame)!, fromView: self.tableView)
                let maxY = CGRectGetMaxY(rect!)
                if ScreenHeight - maxY < 300 {
                    let offSet = tableView.contentOffset
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        tableView.contentOffset = CGPointMake(offSet.x, offSet.y + 300 - ScreenHeight + maxY)
                    })
                }
            })
            
            
            cell.configUnfoldBlock({ [unowned self] (isUnfold: Bool) -> () in
                let building = self.dataSource[indexPath.row]
                let rooms = self.roomDic[building.buildName]
                if !isUnfold {
                    var indexPaths = [NSIndexPath]()
                    for i in 0..<rooms!.count {
                        indexPaths.append(NSIndexPath(forRow: indexPath.row + 1 + i, inSection: 0))
                        self.dataSource.removeAtIndex(indexPath.row + 1)
                    }
//                    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
                    building.isUnfold = false
                    self.tableView.reloadData()
                    
                } else {
                    var indexPaths = [NSIndexPath]()
                    for i in 0..<rooms!.count {
                        indexPaths.append(NSIndexPath(forRow: indexPath.row + 1 + i, inSection: 0))
                        self.dataSource.insert(rooms![i], atIndex: indexPath.row + 1 + i)
                    }
//                    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
                    building.isUnfold = true
                    self.tableView.reloadData()
                }
            })
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        case .BuildRoom:
            if building.isAddCell {
                let cell = tableView.dequeueReusableCellWithIdentifier("addroomcell", forIndexPath: indexPath) as! AddRoomCell
                cell.building = building
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("roomcell", forIndexPath: indexPath) as! RoomCell
                cell.roomName.text = building.buildName
                cell.indexPath = indexPath
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.configEndEditing({ (text) -> () in
                    let oldName = building.buildName
                    if text.trimString() == "" {
                         showMsg("房间名不能为空")
                        //cell.roomName.text = oldName
                        
                    
                    }else if self.checkDuplicateRoomName(text,floorName: (building.floor?.buildName)!) {
                        building.buildName = text
                       
                    } else if text != oldName {
                       
                        cell.roomName.text = oldName
                         showMsg("房间名已存在")
                        
                    }

                   
                })
                cell.configKeyboardAdpt({ [unowned self] (index: NSIndexPath) -> () in
                    let nowCell = self.tableView.cellForRowAtIndexPath(index)
                    let rect = UIApplication.sharedApplication().keyWindow?.convertRect((nowCell?.frame)!, fromView: self.tableView)
                    let maxY = CGRectGetMaxY(rect!)
                    if ScreenHeight - maxY < 300 {
                        let offSet = tableView.contentOffset
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
                            tableView.contentOffset = CGPointMake(offSet.x, offSet.y + 300 - ScreenHeight + maxY)
                        })
                        
                    }
                    
                    })
                return cell
            }
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let building = dataSource[indexPath.row]
        if building.isAddCell {
            let roomArr = roomDic[building.floor!.buildName]
            var build:Building?
            if roomArr!.count == 1{
                 build = Building(buildType: .BuildRoom, buildName: "房间", isAddCell: false)
            }else {
                 build = Building(buildType: .BuildRoom, buildName: "\(roomArr![roomArr!.count-2].buildName)_1", isAddCell: false)
            }
          
            build!.floor = building.floor
            roomDic[building.floor!.buildName]?.insert(build!, atIndex: (roomDic[building.floor!.buildName]?.endIndex)! - 1)
            dataSource.insert(build!, atIndex: indexPath.row)
//            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let building = dataSource[indexPath.row]
        if building.buildType == BuildType.BuildRoom
        {
            return 45
        }else{
            return 56
        }

    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        print("-----------\(indexPath.row)")
        if dataSource.count == 0{
            return false
        }
        let building = dataSource[indexPath.row]
        if building.isAddCell{
        return false
        }
        return true
       
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if dataSource.count == 0{
            return
        }
        let building = dataSource[indexPath.row]
        if building.buildType == BuildType.BuildRoom
        {
            if building.buildCode != ""{
            let parameter = ["roomCode" :building.buildCode]
              BaseHttpService .sendRequestAccess(deleteroom_do, parameters: parameter) { [unowned self](back) -> () in
              
                    
                    Room( roomCode:building.buildCode).delete()
                
                    showMsg("删除成功");
                    let correctArray = getRemoveIndex(building,array: (self.roomDic[building.floor!.buildName])!)
                    //从原数组中删除指定元素
                    
                     for index in correctArray{
                        self.roomDic[building.floor!.buildName]?.removeAtIndex(index)
                     }
                    self.dataSource.removeAtIndex(indexPath.row)
                    self.tableView.reloadData()
                    
               
                
              }
            }else{
                let correctArray = getRemoveIndex(building,array: (self.roomDic[building.floor!.buildName])!)
                //从原数组中删除指定元素
                
                for index in correctArray{
                    self.roomDic[building.floor!.buildName]?.removeAtIndex(index)
                }
                self.dataSource.removeAtIndex(indexPath.row)
                self.tableView.reloadData()
          
            }
       //
        }else
        {
            if(building.isUnfold){
                print("房间打开");
                let correctArray = getRemoveIndex(building,array:self.floorArr)
                //从原数组中删除指定元素
                
                if self.roomDic.keys.contains(building.buildName)
                {
                    //var indexPaths = [NSIndexPath]()
                    let arr = self.roomDic[building.buildName]
                    
                    for _ in 0 ..< arr!.count+1
                    {
                        self.dataSource.removeAtIndex(indexPath.row)
                    }
                    self.roomDic.removeValueForKey(building.buildName)
                    
                }
                for index in correctArray{
                    self.floorArr.removeAtIndex(index)
                }
                self.tableView.reloadData()
                
            }

            
            if building.buildCode != ""{

             let parameter = ["floorCode" :building.buildCode]
                BaseHttpService .sendRequestAccess(deletefloor_do, parameters: parameter) {[unowned self](back) -> () in
                    
                         Floor( floorCode:building.buildCode).delete()
                        
                        showMsg("删除成功");
                        let correctArray = getRemoveIndex(building,array:self.floorArr)
                        //从原数组中删除指定元素
                        if self.roomDic.keys.contains(building.buildName)
                        {
                            self.roomDic.removeValueForKey(building.buildName)
                        }
                        for index in correctArray{
                            self.floorArr.removeAtIndex(index)
                        }
                        self.dataSource.removeAtIndex(indexPath.row)
                 print("self.dataSource.count-----------\(self.dataSource.count)")
                        self.tableView.reloadData()
                  
                }
            }else{
                let correctArray = getRemoveIndex(building,array:self.floorArr)
                //从原数组中删除指定元素
                if self.roomDic.keys.contains(building.buildName)
                {
                    self.roomDic.removeValueForKey(building.buildName)
                }
                for index in correctArray{
                    self.floorArr.removeAtIndex(index)
                }
                self.dataSource.removeAtIndex(indexPath.row)
                self.tableView.reloadData()
            }
            
            
        }
     
       
        //            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
        
        
    }
    
    //获取正确的删除索引
      /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
