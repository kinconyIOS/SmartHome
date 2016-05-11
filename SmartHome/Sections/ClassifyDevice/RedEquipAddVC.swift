//
//  EquipAddVC.swift
//  SmartHome
//
//  Created by kincony on 16/1/5.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class RedEquipAddVC: UITableViewController, UIGestureRecognizerDelegate,QRCodeReaderDelegate {
    static let myreader=QRCodeReaderViewController(cancelButtonTitle:"取消识别")
    var roomCode:String?
    var equip: Equip? = Equip.init(equipID: "")
    var equipIndex :NSIndexPath?
    var NameText:String?//导航栏名
    var EquType:Int?//类型
    var RedCell:RedsTableViewCell?
    var arr = [String]()
    private var compeletBlock: ((Equip,NSIndexPath)->())?
    
    func configCompeletBlock(compeletBlock: (equip: Equip,indexPath:NSIndexPath)->()) {
        self.compeletBlock = compeletBlock
    }
    
    
       var sunData:SunDataPicker? = SunDataPicker.init(frame: CGRectMake(0, 100,ScreenWidth-20 , (ScreenWidth-20)*3/3))
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        navigationItem.title = NameText
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "矢量智能对象"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleBack:"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleRightItem:"))
        
        self.tableView.registerNib(UINib(nibName: "EquipNameCell", bundle: nil), forCellReuseIdentifier: "equipnamecell")
        self.tableView.registerNib(UINib(nibName: "EquipConfigCell", bundle: nil), forCellReuseIdentifier: "equipconfigcell")
        self.tableView.registerNib(UINib(nibName: "EquipImageCell", bundle: nil), forCellReuseIdentifier: "equipimagecell")
        self.tableView.registerNib(UINib(nibName: "RedsTableViewCell", bundle: nil), forCellReuseIdentifier: "redsTableViewCell")
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        self.tableView.addGestureRecognizer(tap)
        
        BaseHttpService.sendRequestAccess(getallhost_do, parameters: [:]) { [unowned self](back) -> () in
              print(back)
           
            if(back.count <= 0)
            {return}
            for dic in back as![[String:String]]
            {
                    print(dic )
             self.arr.append(dic["deviceCode"]!)
            }
            print(self.arr)
            if self.arr.count >= 1
            {
               self.equip?.hostDeviceCode = (self.arr[0] as? String)!
            }else
            {
               self.equip?.hostDeviceCode  = "load"
            }
            if self.arr.count <= 1
            {
                self.tableView.reloadData();
            }
       
        
          }
    }
    
    func handleTap(tap: UITapGestureRecognizer) {
        self.tableView.endEditing(true)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
    
    func handleBack(barButton: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func handleRightItem(barButton: UIBarButtonItem) {
//        self.equip!.saveEquip()
//  
//    
//        if self.equip!.name == ""
//        {
//            showMsg("类型不能为空")
//            return
//        }
//        if self.equip!.type == ""
//        {
//            showMsg("类型不能为空")
//            return
//        }
//        if self.equip!.hostDeviceCode == "load"
//        {
//            showMsg("请先扫描主机")
//            return
//        }
//             //添加设备
//        let parameter = ["userCode" : userCode,
//            "roomCode":self.equip!.roomCode,
//            "deviceAddress":self.equip!.equipID,
//            "nickName":self.equip!.name,
//            "ico":self.equip!.icon,
//            "deviceType":self.equip!.type,
//            "deviceCode":self.equip!.hostDeviceCode]
//        print("\(parameter)")
//        BaseHttpService.sendRequestAccess(addEq_do, parameters:parameter, success: { (data) -> () in
//            print(data)
//            
//        })
//        for temp in self.navigationController!.viewControllers {
//            if temp.isKindOfClass(ClassifyHomeVC.classForCoder()) {
//                self.navigationController?.popToViewController(temp , animated: true)
//            }
//        }
        
       // self.equip?.equipID = RedCell!.code.text!//设备的唯一标识 地址码
        self.equip?.num = "1"
        self.equip?.type = "99"//zigbee 红外99
        self.equip?.status = RedCell!.identification.text!//设备验证码
        self.equip?.roomCode = self.roomCode!//房间号
        if self.equip?.equipID == "" || self.equip?.icon == "" || self.equip?.status == "" || self.equip?.name == ""{
            showMsg("请完善信息")
            return
        }
       // self.equip?.saveEquip()//存储数据库
        let parameters = ["deviceType":self.equip!.type,
                    "deviceAddress":self.equip!.equipID,
                    "validationCode":self.equip!.status,
                    "nickName":self.equip!.name,
                    "ico":self.equip!.icon,
                    "roomCode":self.equip!.roomCode]
        print(parameters)
        BaseHttpService .sendRequestAccess(Set_setinfrareddeviceinfo, parameters:parameters) { [unowned self](response) -> () in
            print(response)
            self.equip?.saveEquip()//存储数据库
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
      if  self.arr.count <= 1
      {
        return 4
      }
        
        return 4
        
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 3{
            return 100
        }
        return 40
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            switch indexPath.section {
            case 0:
                //                let cell = tableView.dequeueReusableCellWithIdentifier("equipconfigcell", forIndexPath: indexPath) as! EquipConfigCell
                //                cell.cellTitle.text = "设备类型"
                //                return cell
                let cell = tableView.dequeueReusableCellWithIdentifier("equipnamecell", forIndexPath: indexPath) as! EquipNameCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.complete = {[unowned self](name)in
                    self.equip?.name = name!//设备名称
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("equipimagecell", forIndexPath: indexPath) as! EquipImageCell
                cell.cellTitleLabel.text = "设备图标"
                return cell
            case 3:
                 RedCell = tableView.dequeueReusableCellWithIdentifier("redsTableViewCell", forIndexPath: indexPath) as? RedsTableViewCell
                RedCell!.sao.addTarget(self, action: Selector("butt:"), forControlEvents: UIControlEvents.TouchUpInside )
                return RedCell!
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier("equipimagecell", forIndexPath: indexPath) as! EquipImageCell
                cell.cellTitleLabel.text = "设置控制界面"
                return cell
            default:
                let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reusetableview")
                return cell
            }
        
        
    }
    func butt(but:UIButton){
        if (QRCodeReader.supportsMetadataObjectTypes([AVMetadataObjectTypeQRCode])) {
            
            RedEquipAddVC.myreader.modalPresentationStyle = UIModalPresentationStyle.FormSheet
            RedEquipAddVC.myreader.delegate = self
            RedEquipAddVC.myreader.setCompletionWithBlock({ (resultAsString) -> Void in
                
            })
            self.presentViewController(RedEquipAddVC.myreader, animated: true, completion: nil)
        }
        else {
            print("设备不支持照相功能")
        }
    }
     func reader(reader: QRCodeReaderViewController!, didScanResult result: String!) {
        //self.deviceCode = result
        //self.serialNumberTF.text = result
        let arrayStr = result.componentsSeparatedByString(",")
        RedCell!.code.text = arrayStr[0]
        self.equip?.equipID = arrayStr[0]
        self.equip?.status = arrayStr[1]
        RedCell!.identification.text = arrayStr[1]
        print(result)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func readerDidCancel(reader: QRCodeReaderViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
 
            switch indexPath.section {
            case 1:
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! EquipImageCell
                
                let choosIconVC = ChooseIconVC(nibName: "ChooseIconVC", bundle: nil)
                choosIconVC.chooseImageBlock( { [unowned self,unowned cell] (imageName) -> () in
                    
                    cell.cellIconImage.image = UIImage(named: imageName)
                    print("imageName")
                    self.equip!.icon = imageName//设备的图标
                    })
                self.navigationController?.pushViewController(choosIconVC, animated: true)
            case 2:
                if self.equip?.equipID == ""{
                    showMsg("请扫描设备二维码")
                    return
                }
                //----------
                let infraredVC = InfraredViewController(nibName: "InfraredViewController", bundle: nil)
                   infraredVC.swif = 0
                BaseHttpService .sendRequestAccess(Get_gaininfraredbuttonses, parameters:["deviceAddress":self.equip!.equipID]) { (response) -> () in
                    print(response)
                    if response.count != 0{
                        infraredVC.cellArr = response as! NSArray
                    }
                    //print(infraredVC.cellArr)
                    infraredVC.WillAppear()
                }
                infraredVC.Address = self.equip!.equipID
                self.navigationController?.pushViewController(infraredVC, animated: true)
                break
            default:
                break
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
