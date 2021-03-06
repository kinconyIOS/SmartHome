//
//  ClassifyHomeVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/30.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire

class FloorOrRoomOrEquip {
    enum ItemType {
        case Floor,Room, Equip, Add
    }
     var floor:Floor?
    var room: Room?
    var equip: Equip?
    var addRoom: Room?

    var type: ItemType {
        if floor != nil {
            return .Floor
        }
        if equip != nil {
            return .Equip
        }
        if room != nil {
            return .Room
        }
        if equip != nil {
            return .Equip
        }
        return .Add
    }
    var isUnfold: Bool = false
    init(floor:Floor?,room: Room?, equip: Equip?) {
        self.floor = floor
        self.room = room
        self.equip = equip
    }
}

class ClassifyHomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var deviceSegement: SHSegement! {
        didSet {
            deviceSegement.backgroundColor = UIColor(red: 230 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 1)

            deviceSegement.leftLabel.text = "未分类"
            deviceSegement.rightLabel.text = "已分类"
            deviceSegement.selectAction(.Left) { [unowned self] () -> () in
                self.view.bringSubviewToFront(self.collectionView)
                self.reloadUnClassifyDataSource()
                
                
            }
            deviceSegement.selectAction(.Right) { [unowned self] () -> () in
                self.view.bringSubviewToFront(self.tableView)
                self.reloadClassifyDataSource()
            }
        }
    }

    var cDataSource: [Equip] = []
    var tDataSource: [FloorOrRoomOrEquip] = []
    var tDic: [String : [Equip]] = [String : [Equip]]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadUnClassifyDataSource()
        self.reloadClassifyDataSource()
       // self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func reloadUnClassifyDataSource() {
        getUnEquips()
       
        
        let parameter = ["userCode" : userCode]
        BaseHttpService.sendRequestAccess(unclassifyEquip_do, parameters: parameter) { (data) -> () in
            let arr = data as! [[String : AnyObject]]
            print(arr)
             self.cDataSource = []
            for e in arr {
                let equip = Equip(equipID: e["deviceAddress"] as! String)
                equip.userCode = e["userCode"] as! String
                equip.type = e["deviceType"] as! String
                equip.num  = e["deviceNum"] as! String
                equip.icon  = e["icon"] as! String

                if equip.icon == ""{
                equip.icon = getIconByType(equip.type)
                }
                equip.saveEquip()
                self.cDataSource.append(equip)
            }
            self.collectionView.reloadData()
        }
        
    }
    func getUnEquips(){
       self.cDataSource = []
        //先去更新数据库 再从数据库中解析
        let equips = dataDeal.getModels(.Equip) as! [Equip]
        for equip in equips
        {
            if  equip.roomCode == ""{
             self.cDataSource.append(equip)
            }
        }
            
        self.collectionView.reloadData()
     
    }
    
    func reloadClassifyDataSource() {
    
       self.getRoomInfoFotClassify()
        
        let parameter = ["userCode" : userCode]
        BaseHttpService.sendRequestAccess(classifyEquip_do, parameters: parameter) { (data) -> () in
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
                let equips = dataDeal.getEquipsByRoom(room)
                self.tDic[room.roomCode] = equips
            }
            
            
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadUnClassifyDataSource()
        self.reloadClassifyDataSource()
        
        
        navigationItem.title = "我的设备"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "矢量智能对象"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleBack:"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleRightItem:"))
        

        
        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(ScreenWidth / 3 - 1, ScreenWidth / 3 - 1)
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.registerNib(UINib(nibName: "EquipCollectionCell", bundle: nil), forCellWithReuseIdentifier: "equipcollectioncell")
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCellReuse")
        
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
        
        let homevc:HomeVC=HomeVC(nibName: "HomeVC", bundle: nil)
        homevc.tabBarItem.title=NSLocalizedString("首页", comment: "")
        homevc.tabBarItem.image=homeIcon
        homevc.tabBarItem.selectedImage=homeIconSelected
        let homeNav:UINavigationController = AutorotateNavC(rootViewController: homevc)
        
        let setModelVC:SetModelVC=SetModelVC(nibName: "SetModelVC", bundle: nil)
        setModelVC.tabBarItem.title=NSLocalizedString("情景模式", comment: "")
        setModelVC.tabBarItem.image=modelIcon
        setModelVC.tabBarItem.selectedImage=modelIconSelected
        let setModelNav:UINavigationController = UINavigationController(rootViewController: setModelVC)
        
        let mallvc:MallVC=MallVC(nibName: "MallVC", bundle: nil)
        mallvc.tabBarItem.title=NSLocalizedString("商城", comment: "")
        mallvc.tabBarItem.image=mallIcon
        mallvc.tabBarItem.selectedImage=mallIconSelected
        let mallNav:UINavigationController = UINavigationController(rootViewController:mallvc)
        
        let minevc:MineVC=MineVC(nibName: "MineVC", bundle: nil)
        minevc.tabBarItem.title=NSLocalizedString("我的", comment: "")
        minevc.tabBarItem.image=mineIcon
        minevc.tabBarItem.selectedImage=mineIconSelected
        let mineNav:UINavigationController = UINavigationController(rootViewController: minevc)
        let tab=AutoTabC()
        tab.viewControllers=[homeNav,setModelNav,mallNav,mineNav];
        tab.tabBar.tintColor=mainColor
        //  let navigationC = UINavigationController(rootViewController: addDeviceVC)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController = tab
    }

   
    
    // MARK: - UICollectionView data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cDataSource.count < 15 {
            return 15
        }
        let temp = cDataSource.count % 3
        return cDataSource.count + temp
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row >= cDataSource.count {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCellReuse", forIndexPath: indexPath)
            cell.backgroundColor = UIColor.whiteColor()
            return cell
        }
        let equip = cDataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("equipcollectioncell", forIndexPath: indexPath) as! EquipCollectionCell
        cell.equipName.text = equip.name
        cell.equipImage.image = UIImage(named: equip.icon)
        return cell
    }
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < cDataSource.count {
            let equipSetVC = EquipSetVC(nibName: "EquipSetVC", bundle: nil)
            equipSetVC.equip = cDataSource[indexPath.row]
            equipSetVC.configCompeletBlock({ [unowned self] (equip) -> () in
              
                //添加设备
                  let parameter = [
                    "roomCode":equip.roomCode,
                    "deviceAddress":equip.equipID,
                    "nickName":equip.name,
                    "ico":equip.icon]
                BaseHttpService.sendRequestAccess(addEq_do, parameters:  parameter, success: { (data) -> () in
                    print(data)
                    equip.saveEquip()
                })
                //上传更新设备
                for i in 0..<self.cDataSource.count {
                    if self.cDataSource[i].equipID == equip.equipID {
                        self.cDataSource.removeAtIndex(i)
                        break
                    }
                }
                self.collectionView.reloadData()
            })
            self.navigationController?.pushViewController(equipSetVC, animated: true)
        }
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
                cell.unfoldImage.image = UIImage(named: "楼层按下")
            } else {
                cell.unfoldImage.image = UIImage(named: "楼层未按下")
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
                tDataSource.removeRange(Range(start: indexPath.row + 1, end: indexPath.row + 1 + (tDic[model.room!.roomCode]?.count)! + 1))
                
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
                let add = FloorOrRoomOrEquip(floor:nil,room: nil, equip: nil)
                add.addRoom = model.room
                equips.append(add)
                tDataSource.insertContentsOf(equips, at: indexPath.row + 1)
                tableView.reloadData()
            }
        }
        
        if model.type == .Add {
               let equipTypeChoseTVC = EquipTypeChoseTVC()
            equipTypeChoseTVC.roomCode = model.addRoom!.roomCode
          self.navigationController?.pushViewController(equipTypeChoseTVC, animated: true)
//            let equipAddVC = EquipAddVC(nibName: "EquipAddVC", bundle: nil)
//            equipAddVC.equip = Equip(equipID: randomCode())
//            equipAddVC.equip?.num = "1"
//            equipAddVC.equip?.roomCode = model.addRoom!.roomCode
//            equipAddVC.equipIndex = indexPath
//            equipAddVC.configCompeletBlock({ [unowned self] (equip,indexPath) -> () in
//                 equip.saveEquip()
//                //添加设备
//                let parameter = ["userCode" : userCode,
//                    "roomCode":equip.roomCode,
//                    "deviceAddress":equip.equipID,
//                    "nickName":equip.name,
//                    "ico":equip.icon,
//                "deviceType":equip.type]
//                print("\(parameter)")
//                BaseHttpService.sendRequestAccess(addEq_do, parameters:  parameter, success: { (data) -> () in
//                    print(data)
//                   
//                })
//
//                self.tDic[model.addRoom!.roomCode]?.append(equip)
//               print("\(indexPath.row)")
//               self.tDataSource.insert(FloorOrRoomOrEquip(floor:nil,room: nil, equip: equip), atIndex: indexPath.row)
//                
//                self.tableView.reloadData()
//            })
//            self.navigationController?.pushViewController(equipAddVC, animated: true)
        }
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let model = tDataSource[indexPath.row]
        if model.type == .Floor  {
            return 30
        }
        return 44
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         let model = tDataSource[indexPath.row]
        if model.type == .Floor || model.type == .Room || model.type == .Add{
            return false
        }
        return true
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let model = tDataSource[indexPath.row]
        //从数据库删除该设备
        model.equip?.delete()
            if model.equip?.equipID != ""{
                let parameter = ["deviceAddress" :model.equip!.equipID]
                BaseHttpService.sendRequestAccess(deletedevice_do, parameters: parameter) { (back) -> () in
                }
            }
        let arr:[Equip] = tDic[(model.equip?.roomCode)!]!
        print(arr)
            let correctArray = getRemoveIndex(model.equip!,array:arr)
            //从原数组中删除指定元素
            
            for index in correctArray{
               tDic[model.equip!.roomCode]!.removeAtIndex(index)
            }
            self.tDataSource.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
            
        
        
    }


}
