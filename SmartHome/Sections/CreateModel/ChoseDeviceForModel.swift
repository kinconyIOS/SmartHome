//
//  ChoseDeviceForModel.swift
//  SmartHome
//
//  Created by sunzl on 16/5/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class ChoseDeviceForModel: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
   
    
  
    var tDataSource: [FloorOrRoomOrEquip] = []
    var tDic: [String : [Equip]] = [String : [Equip]]()
    var modelId = ""
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
   
        self.reloadClassifyDataSource()
       
    }
    
   
 
    
    func reloadClassifyDataSource() {
        
        self.getRoomInfoFotClassify()
        
        
        BaseHttpService.sendRequestAccess(classifyEquip_do, parameters: [:]) { (data) -> () in
            print(data)
            if data.count != 0{
                
                let arr = data as! [[String : AnyObject]]
                for e in arr {
                    let equip = Equip(equipID: e["deviceAddress"] as! String)
                    equip.name = e["nickName"] as! String
                    equip.roomCode = e["roomCode"] as! String
                    equip.userCode = e["userCode"] as! String
                    equip.type = e["deviceType"] as! String
                    equip.num  = e["deviceNum"] as! String
                    equip.icon  = e["icon"] as! String
                    if equip.icon == ""{
                        equip.icon = getIconByType(equip.type)
                    }
                    equip.saveEquip()
                    
                }
                
            }
            //先去更新数据库 再从数据库中解析
            self.getRoomInfoFotClassify()
            
        }
        
        self.tableView.reloadData()
        
        
        
    }
    func getRoomInfoFotClassify(){
        self.tDic.removeAll()
        self.tDataSource.removeAll()
        //先去更新数据库 再从数据库中解析
        let floors = dataDeal.getModels(.Floor) as! [Floor]
        for floor in floors
        {
            let f = FloorOrRoomOrEquip(floor: floor,room: nil, equip: nil)
            self.tDataSource.append(f)
            let rooms = dataDeal.getRoomsByFloor(floor)
            for room in rooms {
                let r = FloorOrRoomOrEquip(floor: nil,room: room, equip: nil)
                self.tDataSource.append(r)
                let equips = dataDeal.getEquipsByRoomExceptSXT(room)
                self.tDic[room.roomCode] = equips
            }
            
            
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        
        
        navigationItem.title = "我的设备"
        //  navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "矢量智能对象"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleBack:"))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleRightItem:"))
        
        
        
     
        self.tableView.addLegendHeaderWithRefreshingBlock {[unowned self] () -> Void in
            
            print("刷新界面")
            self.reloadClassifyDataSource()
            self.tableView.header.endRefreshing()
        }
        
       
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "EquipTableRoomCell", bundle: nil), forCellReuseIdentifier: "equiptableroomcell")
        self.tableView.registerNib(UINib(nibName: "EquipTableEquipCell", bundle: nil), forCellReuseIdentifier: "equiptableequipcell")
        self.tableView.registerNib(UINib(nibName: "AddRoomCell", bundle: nil), forCellReuseIdentifier: "addroomcell")
        self.tableView.registerNib(UINib(nibName: "EquipTableFloorCell", bundle: nil), forCellReuseIdentifier: "equiptablefloorcell")
        
    }
    
    func handleBack(barButton: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func handleRightItem(barButton: UIBarButtonItem) {
     
    }
    
    
    
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tDataSource.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = tDataSource[indexPath.row]
        switch model.type {
        case .Floor:
            let cell = tableView.dequeueReusableCellWithIdentifier("equiptablefloorcell", forIndexPath: indexPath) as! EquipTableFloorCell
            let floor = dataDeal.searchModel(.Floor, byCode: (model.floor?.floorCode)!) as! Floor
            let floorName = floor.name
            cell.roomName.text = "\(floorName)"
            return cell
        case .Room:
            let cell = tableView.dequeueReusableCellWithIdentifier("equiptableroomcell", forIndexPath: indexPath) as! EquipTableRoomCell
            
            
            cell.roomName.text = "\(model.room!.name)"
            if model.isUnfold {
                cell.unfoldImage.image = UIImage(named: "hua1")
            } else {
                cell.unfoldImage.image = UIImage(named: "hua2")
            }
            return cell
        case .Equip:
            let cell = tableView.dequeueReusableCellWithIdentifier("equiptableequipcell", forIndexPath: indexPath) as! EquipTableEquipCell
            cell.nameLabel.text = model.equip!.name
            cell.iconImage.image = UIImage(named: model.equip!.icon)
            return cell
        case .Add:
            let cell = tableView.dequeueReusableCellWithIdentifier("addroomcell", forIndexPath: indexPath) as! AddRoomCell
            cell.addLabel.text = "添加设备"
            return cell
        }
        
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = tDataSource[indexPath.row]
        if model.type == .Room {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! EquipTableRoomCell
            if model.isUnfold {
                model.isUnfold = false
                cell.unfoldImage.image = UIImage(named: "楼层未按下")
                var indexPaths = [NSIndexPath]()
                for i in 0..<(tDic[model.room!.roomCode]?.count)! {
                    let subIndexPath = NSIndexPath(forRow: indexPath.row + 1 + i, inSection: 0)
                    indexPaths.append(subIndexPath)
                }
                indexPaths.append(NSIndexPath(forRow: indexPath.row + 1 + (tDic[model.room!.roomCode]?.count)!, inSection: 0))
                tDataSource.removeRange(Range(start: indexPath.row + 1, end: indexPath.row + 1 + (tDic[model.room!.roomCode]?.count)! ))
                
                tableView.reloadData()
            } else {
                
                model.isUnfold = true
                cell.unfoldImage.image = UIImage(named: "楼层按下")
                var indexPaths = [NSIndexPath]()
                var equips = [FloorOrRoomOrEquip]()
                for i in 0..<(tDic[model.room!.roomCode]?.count)! {
                    let subIndexPath = NSIndexPath(forRow: indexPath.row + 1 + i, inSection: 0)
                    indexPaths.append(subIndexPath)
                    equips.append(FloorOrRoomOrEquip(floor:nil,room: nil, equip: tDic[model.room!.roomCode]?[i]))
                }
                
                indexPaths.append(NSIndexPath(forRow: indexPath.row + 1 + (tDic[model.room!.roomCode]?.count)!, inSection: 0))
//                let add = FloorOrRoomOrEquip(floor:nil,room: nil, equip: nil)
//                add.addRoom = model.room
//                equips.append(add)
              tDataSource.insertContentsOf(equips, at: indexPath.row + 1)
                tableView.reloadData()
            }
        }
        
        if model.type == .Equip {
            let eq = Equip(equipID: model.equip!.equipID)
            eq.name = model.equip!.name
            eq.userCode = model.equip!.userCode
            eq.roomCode = model.equip!.roomCode
            eq.type = model.equip!.type
            eq.icon  = model.equip!.icon
            eq.num = model.equip!.num
            eq.status = model.equip!.status
            app.modelEquipArr.addObject(eq)
            print("\(getJsonStrOfDeviceData())")
//            BaseHttpService.sendRequestAccess(addmodelinfo, parameters: ["modelInfo":getJsonStrOfDeviceData(),"modelId":self.modelId], success: {[unowned self] (back) -> () in
//                print(back)
//                self.navigationController?.popViewControllerAnimated(true)
//                })
            showMsg("添加成功");
        }
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let model = tDataSource[indexPath.row]
        if model.type == .Floor  {
            return 30
        }
        return 44
    }
    //-----------添加数组
    func getJsonStrOfDeviceData()->String{
        
        let arr = NSMutableArray()
        for  e in app.modelEquipArr
        {
            let eq = e as! Equip
            let dict = ["deviceAddress":eq.equipID,"deviceType":eq.type,"controlCommand":eq.status,"delayValues":eq.delay]
            arr.addObject(dict)
        }
        
        return dataDeal.toJSONString(arr)
    }
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        let model = tDataSource[indexPath.row]
//        if model.type == .Floor || model.type == .Room || model.type == .Add {
//            return false
//        }
//        return true
//    }
//    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
//        return "选择"
//    }
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let model = tDataSource[indexPath.row]
//      
//     
//       
//       
//        
//        
//        
//    }
}
    

