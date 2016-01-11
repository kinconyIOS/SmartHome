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
    func assembleFloor() -> [String : AnyObject] {
        var mDic: [String : AnyObject] = ["userCode" : userCode]
        var subArr: [[String : String]] = []
        for floor in floorArr {
            subArr.append(["floorName" : floor.buildName])
        }
        mDic["floorName"] = subArr
        return mDic
    }
    
    //房间信息组装
    func assembleRoom(code : [String : String]) -> [String : AnyObject] {
        var mDic: [String : AnyObject] = ["userCode" : userCode]
        var subArr: [[String : String]] = []
        for key in roomDic.keys {
            for value in roomDic[key]! {
                var suDic = ["roomName" : value.buildName]
                suDic["floorCode"] = code[key]
                subArr.append(suDic)
            }
        }
        mDic["roomName"] = subArr
        return mDic
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
        
        navigationItem.title = "创建我的家"
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "导航栏L"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleRightItem:"))
        
        tableView.registerNib(UINib(nibName: "FloorCell", bundle: nil), forCellReuseIdentifier: "floorcell")
        tableView.registerNib(UINib(nibName: "RoomCell", bundle: nil), forCellReuseIdentifier: "roomcell")
        tableView.registerNib(UINib(nibName: "AddRoomCell", bundle: nil), forCellReuseIdentifier: "addroomcell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let floor = Building(buildType: .BuildFloor, buildName: "楼层1", isAddCell: false)
        floorArr.append(floor)
        dataSource.append(floor)
        let add = Building(buildType: .BuildRoom, buildName: "添加", isAddCell: true)
        add.floor = floor
        roomDic[floor.buildName] = [add]
    }

    @IBAction func handleAddFloor(sender: UIButton) {
        let floor = Building(buildType: .BuildFloor, buildName: "楼层\(floorArr.count + 1)", isAddCell: false)
        floorArr.append(floor)
        dataSource.append(floor)
        let add = Building(buildType: .BuildRoom, buildName: "添加", isAddCell: true)
        add.floor = floor
        roomDic[floor.buildName] = [add]
//        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: dataSource.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
        tableView.reloadData()
    }
    func handleRightItem(barButton: UIBarButtonItem) {
        
        /*
        let parameter = assembleFloor()
        Alamofire.request(.GET, "http://192.168.1.120:8080/smarthome.IMCPlatform/xingUser/addfloor.action", parameters: parameter).responseJSON { [unowned self] (response) -> Void in
            if response.result.isFailure {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                print("error:\(response.result.error)")
                
            } else {
                print("result: \(response.result.value)")
                let dataArr = response.result.value!["data"] as! [[String : String]]
                var dic = [String : String]()
                for f in dataArr {
                    dic[f["floorName"]!] = f["floorCode"]
                    let floor = Floor(floorID: f["floorCode"]!)
                    floor.name = f["floorName"]
                    floor.userCode = userCode
                    floor.saveFloor()
                }
                let roomParameter = self.assembleRoom(dic)
                
                Alamofire.request(.GET, "http://192.168.1.120:8080/smarthome.IMCPlatform/xingUser/addroom.action", parameters: roomParameter).responseJSON(completionHandler: { (response) -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    if response.result.isFailure {
                        print("error:\(response.result.error)")
                    } else {
                        print("result: \(response.result.value)")
                        let dataArr = response.result.value!["data"] as! [[String : String]]
                        for r in dataArr {
                            let room = Room(roomID: r["roomCode"]!)
                            room.name = r["roomName"]
                            room.floorCode = r["floorCode"]
                            room.userCode = userCode
                            room.saveRoom()
                        }
                        
                        
                        let classifyVC = ClassifyHomeVC(nibName: "ClassifyHomeVC", bundle: nil)
                        self.navigationController?.pushViewController(classifyVC, animated: true)
                    }
                    
                })
                
            }
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        */
        
        let classifyVC = ClassifyHomeVC(nibName: "ClassifyHomeVC", bundle: nil)
        self.navigationController?.pushViewController(classifyVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkDuplicateName(text: String) -> Bool {
        for floor in floorArr {
            if text == floor.buildName {
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
                if text == "" {
                    let alert = SHAlertView(title: "提示", message: "楼层名不能为空", cancleButtonTitle: "取消", confirmButtonTitle: "确定")
                    cell.floorName.text = oldName
                    alert.show()
                }
                if self.checkDuplicateName(text) {
                    building.buildName = text
                    self.roomDic[text] = self.roomDic[oldName]
                    self.roomDic.removeValueForKey(oldName)
                } else if text != oldName {
                    let alert = SHAlertView(title: "提示", message: "楼层名重复", cancleButtonTitle: "取消", confirmButtonTitle: "确定")
                    cell.floorName.text = oldName
                    alert.show()
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
                    building.buildName = text
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

            let build = Building(buildType: .BuildRoom, buildName: "房间\((roomDic[building.floor!.buildName]?.count)!)", isAddCell: false)
            roomDic[building.floor!.buildName]?.insert(build, atIndex: (roomDic[building.floor!.buildName]?.endIndex)! - 1)
            dataSource.insert(build, atIndex: indexPath.row)
//            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.reloadData()
        }
        
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
