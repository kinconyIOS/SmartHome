//
//  ClassifyHomeVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/30.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class RoomOrEquip {
    enum ItemType {
        case Room, Equip, Add
    }
    var room: Room?
    var equip: Equip?
    var type: ItemType {
        if room != nil {
            return .Room
        }
        if equip != nil {
            return .Equip
        }
        return .Add
    }
    var isUnfold: Bool = false
    init(room: Room?, equip: Equip?) {
        self.room = room
        self.equip = equip
    }
}

class ClassifyHomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var deviceSegement: SHSegement! {
        didSet {
            deviceSegement.leftLabel.text = "未分类"
            deviceSegement.rightLabel.text = "已分类"
            deviceSegement.selectAction(.Left) { [unowned self] () -> () in
                self.view.bringSubviewToFront(self.collectionView)
            }
            deviceSegement.selectAction(.Right) { [unowned self] () -> () in
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }

    var cDataSource: [Equip] = []
    var tDataSource: [RoomOrEquip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "我的设备"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "矢量智能对象"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleBack:"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleRightItem:"))
        
//        let room1 = Room(); room1.name = "客厅"
//        room1.equips = [Equip(), Equip(), Equip()]
//        let room2 = Room(); room2.name = "厨房"
//        room2.equips = [Equip(), Equip()]
//        let room3 = Room(); room3.name = "卧室"
//        room3.equips = [Equip(), Equip(), Equip()]
//        tDataSource = [RoomOrEquip(room: room1, equip: nil), RoomOrEquip(room: room2, equip: nil), RoomOrEquip(room: room3, equip: nil)]
        
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
        
    }
    
    func handleBack(barButton: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func handleRightItem(barButton: UIBarButtonItem) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("equipcollectioncell", forIndexPath: indexPath)
        
        return cell
    }
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < cDataSource.count {
            let equipSetVC = EquipSetVC(nibName: "EquipSetVC", bundle: nil)
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
        case .Room:
            let cell = tableView.dequeueReusableCellWithIdentifier("equiptableroomcell", forIndexPath: indexPath) as! EquipTableRoomCell
            cell.roomName.text = model.room!.name
            if model.isUnfold {
                cell.unfoldImage.image = UIImage(named: "楼层按下")
            } else {
                cell.unfoldImage.image = UIImage(named: "楼层未按下")
            }
            return cell
        case .Equip:
            let cell = tableView.dequeueReusableCellWithIdentifier("equiptableequipcell", forIndexPath: indexPath) as! EquipTableEquipCell
//            cell.nameLabel.text = model.equip!.name
            cell.nameLabel.text = "测试"
            return cell
        case .Add:
            let cell = tableView.dequeueReusableCellWithIdentifier("addroomcell", forIndexPath: indexPath) as! AddRoomCell
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
                for i in 0..<(model.room?.equips.count)! {
                    let subIndexPath = NSIndexPath(forRow: indexPath.row + 1 + i, inSection: 0)
                    indexPaths.append(subIndexPath)
                }
                indexPaths.append(NSIndexPath(forRow: indexPath.row + 1 + (model.room?.equips.count)!, inSection: 0))
                tDataSource.removeRange(Range(start: indexPath.row + 1, end: indexPath.row + 1 + (model.room?.equips.count)! + 1))
                tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Bottom)
            } else {
                
                model.isUnfold = true
                cell.unfoldImage.image = UIImage(named: "楼层按下")
                var indexPaths = [NSIndexPath]()
                var equips = [RoomOrEquip]()
                for i in 0..<(model.room?.equips.count)! {
                    let subIndexPath = NSIndexPath(forRow: indexPath.row + 1 + i, inSection: 0)
                    indexPaths.append(subIndexPath)
                    equips.append(RoomOrEquip(room: nil, equip: model.room?.equips[i]))
                }
                
                indexPaths.append(NSIndexPath(forRow: indexPath.row + 1 + (model.room?.equips.count)!, inSection: 0))
                equips.append(RoomOrEquip(room: nil, equip: nil))
                tDataSource.insertContentsOf(equips, at: indexPath.row + 1)
                tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Bottom)
            }
        }
        
        if model.type == .Add {
            let equipAddVC = EquipAddVC(nibName: "EquipAddVC", bundle: nil)
            equipAddVC.configCompeletBlock({ [unowned self, unowned indexPath, unowned tableView] (equip) -> () in
//                self.tDataSource[indexPath.row]
                self.tDataSource.insert(RoomOrEquip(room: nil, equip: equip), atIndex: indexPath.row)
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            })
            self.navigationController?.pushViewController(equipAddVC, animated: true)
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
