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
    var arr = [String]()
   // let dataSource = ["射频设备","红外设备","WIFI单品","摄像头","门锁"]
    let dataSource = ["射频设备","WIFI单品","摄像头","门锁"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "完善设备信息"
        self.navigationItem.title="完善设备信息"
        BaseHttpService.sendRequestAccess(getallhost_do, parameters: [:]) { [unowned self](back) -> () in
            print(back)
            
            if(back.count <= 0)
            {return}
            for dic in back as![[String:String]]
            {
                print(dic )
                self.arr.append(dic["deviceCode"]!)
            }
  
        }
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
            if self.arr.count == 0{
                showMsg("请先扫描主机")
                return
            }
            let equipAddVC = ShotEquipAddVC()
            equipAddVC.equip = Equip(equipID: randomCode())
            equipAddVC.equip?.num = "1"
            equipAddVC.equip?.roomCode = self.roomCode!
            equipAddVC.NameText = "添加设备"
            equipAddVC.EquType = indexPath.row
            self.navigationController?.pushViewController(equipAddVC, animated:true)
            break
//        case 1:
//            let equipAddVC = RedEquipAddVC()
//            
//            equipAddVC.roomCode = self.roomCode!
//            equipAddVC.NameText = "红外设备"
//            
//            equipAddVC.hidesBottomBarWhenPushed=true
//            self.navigationController?.pushViewController(equipAddVC, animated:true)
//            break
        case 2:
            let cameraType = CameraTypeTVC();
            print("----\(self.roomCode)")
               cameraType.roomCode = self.roomCode!
            cameraType.hidesBottomBarWhenPushed
                = true
            self.navigationController?.pushViewController(cameraType, animated: true)
            break
        case 3:
            let eq = Equip(equipID: "11111")
            eq.type = "999"
            eq.roomCode = self.roomCode!
            ///sunDataPicker 
            BaseHttpService .sendRequestAccess(getallhost_do, parameters:[:]) { (response) -> () in
                print(response)
                if response.count == 0{
                    let alert = UIAlertView(title: "提示", message: "您还没添加主机", delegate: self, cancelButtonTitle: "我知道了")
                    alert.show()
                }else{
                    let sunData:SunDataPicker? = SunDataPicker.init(frame: CGRectMake(0, 100,ScreenWidth-20 , (ScreenWidth-20)*3/3))
                    sunData?.title.text = "主机"
                    var arr1 = [String]()
                    for dic in (response as![[String:String]])
                    {
                        print(dic)
                        arr1.append(dic["deviceCode"]!)
                    }
                    sunData?.setNumberOfComponents(1, SET: arr1, addTarget:self.navigationController!.view , complete: { (one, two, three) -> Void in
                        let a = "\(one)"
                        print(a)
                        eq.hostDeviceCode = a
                        //
                        eq.icon = "门锁"
                        let parameter = [
                            "roomCode":self.roomCode!,
                            "deviceAddress":eq.equipID,
                            "nickName":eq.name,
                            "ico":eq.icon,
                            "deviceType":eq.type,
                            "deviceCode":eq.hostDeviceCode]
                        print("\(parameter)")
                        BaseHttpService.sendRequestAccess(addEq_do, parameters:parameter, success: { [unowned self](data) -> () in
                            print(data)
                            eq.saveEquip()
                            showMsg("添加成功")
                            for temp in self.navigationController!.viewControllers {
                                if temp.isKindOfClass(ClassifyHomeVC.classForCoder()) {
                                    self.navigationController?.popToViewController(temp , animated: true)
                                }/*else if temp.isKindOfClass(c.classForCoder()){
                                    self.navigationController?.popToViewController(temp , animated: true)
                                }*/
                            }
                            
                            })
                        
                       
                        //
                    })
                }
            }
             break
            //---

        default:
            showMsg("暂未开放敬请期待")
            break
    
        }
    }
    
}
