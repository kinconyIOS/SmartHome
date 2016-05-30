//
//  EquipAddVC.swift
//  SmartHome
//
//  Created by kincony on 16/1/5.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class ShotEquipAddVC: UITableViewController, UIGestureRecognizerDelegate {
    var equip: Equip?
    var equipIndex :NSIndexPath?
    var NameText:String?//导航栏名
    var EquType:Int?//类型

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
       
  
    
        if self.equip!.name == ""
        {
            showMsg("名字不能为空")
            return
        }
        if self.equip!.type == ""
        {
            showMsg("类型不能为空")
            return
        }
        if self.equip!.hostDeviceCode == "load"
        {
            showMsg("请先扫描主机")
            return
        }
             //添加设备
        let parameter = [
            "roomCode":self.equip!.roomCode,
            "deviceAddress":self.equip!.equipID,
            "nickName":self.equip!.name,
            "ico":self.equip!.icon,
            "deviceType":self.equip!.type,
            "deviceCode":self.equip!.hostDeviceCode]
        print("\(parameter)")
        BaseHttpService.sendRequestAccess(addEq_do, parameters:parameter, success: { (data) -> () in
             self.equip!.saveEquip()
            print(data)
            for temp in self.navigationController!.viewControllers {
                print("-------");
                if temp.isKindOfClass(ClassifyHomeVC.classForCoder()) {
                    self.navigationController?.popToViewController(temp , animated: true)
                }/*else if temp.isKindOfClass(MineVC.classForCoder()){
                    self.navigationController?.popToViewController(temp , animated: true)
                }*/
            }
            
        })

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
        return 3
      }
        
        return 4
        
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
                let cell = tableView.dequeueReusableCellWithIdentifier("equipconfigcell", forIndexPath: indexPath) as! EquipConfigCell
                cell.cellTitle.text = "设备类型"
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("equipnamecell", forIndexPath: indexPath) as! EquipNameCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.complete = {[unowned self](name)in
                    print(name)

                    
                self.equip?.name = name!
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier("equipimagecell", forIndexPath: indexPath) as! EquipImageCell
                cell.cellTitleLabel.text = "设备图标"
                return cell
            case 3:
                let cell = tableView.dequeueReusableCellWithIdentifier("equipconfigcell", forIndexPath: indexPath) as! EquipConfigCell
                cell.cellTitle.text = "选择主机"
                return cell
            default:
                let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reusetableview")
                return cell
            }
        
        
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("equipconfigcell", forIndexPath: indexPath) as! EquipConfigCell
                let choseDeviceType = ChoseDeviceTypeVC(nibName:"ChoseDeviceTypeVC",bundle: nil)
                choseDeviceType.configCompeletBlock({  [unowned self,unowned cell] (equipType, v) -> () in
                    print("\(equipType)+\(v)")
                   
                    cell.cellDetail.text = equipType
                    self.equip!.type = String(v)
                    self.tableView.reloadData()
                    })
                self.navigationController?.pushViewController(choseDeviceType, animated: true)
                break
            case 2:
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! EquipImageCell
                
                let choosIconVC = ChooseIconVC(nibName: "ChooseIconVC", bundle: nil)
                choosIconVC.chooseImageBlock( { [unowned self,unowned cell] (imageName) -> () in
                    
                    cell.cellIconImage.image = UIImage(named: imageName)
                    self.equip!.icon = imageName
                    })
                self.navigationController?.pushViewController(choosIconVC, animated: true)
            case 3:
                self.sunData?.title.text = "选择主机"
                self.sunData?.setNumberOfComponents(1, SET:self.arr, addTarget:self.navigationController!.view) {[unowned self] (one, two, three) -> Void in
                    self.equip?.hostDeviceCode = one
                }
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
