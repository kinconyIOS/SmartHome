//
//  EquipTypeChoseTVC.swift
//  SmartHome
//
//  Created by sunzl on 16/4/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class EquipTypeChoseTVC: UITableViewController {
    var roomCode:String?
    let dataSource = ["射频设备","红外设备","WIFI单品","摄像头"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "完善设备信息"
        self.navigationItem.title="完善设备信息"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")

        if cell == nil
        {
        cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reuseIdentifier")
        }
        cell?.textLabel?.text = dataSource[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFontOfSize(13)
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        return cell!
    }
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.row){
        case 0:
            let equipAddVC = ShotEquipAddVC()
            equipAddVC.equip = Equip(equipID: randomCode())
            equipAddVC.equip?.num = "1"
            equipAddVC.equip?.roomCode = self.roomCode!
            equipAddVC.NameText = "添加设备"
            equipAddVC.EquType = indexPath.row
            self.navigationController?.pushViewController(equipAddVC, animated:true)
            break
        case 1:
            let equipAddVC = RedEquipAddVC()
            
            equipAddVC.roomCode = self.roomCode!
            equipAddVC.NameText = "红外设备"
            
            equipAddVC.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(equipAddVC, animated:true)
            break
        case 3:
            let cameraType = CameraTypeTVC();
               cameraType.roomCode = self.roomCode!
            cameraType.hidesBottomBarWhenPushed
                = true
            self.navigationController?.pushViewController(cameraType, animated: true)
            break
        default:
            showMsg("暂未开放敬请期待")
            break
    
        }
    }
    
}
