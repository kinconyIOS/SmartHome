//
//  HomeVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire

class CreateModelVC: UIViewController,UITableViewDataSource,UITableViewDelegate{

 
   
    var isEdit = true
    var modelId = ""
    var sunData:SunDataPicker? = SunDataPicker.init(frame: CGRectMake(0, 100,ScreenWidth-20 , (ScreenWidth-20)*3/3))
    @IBOutlet var homeTableView: UITableView!
  
    
 
 
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
 
        configView()
        registerCell()
     
     
    }

    func registerCell(){
    
       
        
        
        self.homeTableView.registerNib(UINib(nibName: "ModulateCell", bundle: nil), forCellReuseIdentifier: "ModulateCell")
      
         self.homeTableView.registerNib(UINib(nibName: "UnkownCell", bundle: nil), forCellReuseIdentifier: "UnkownCell")
         self.homeTableView.registerNib(UINib(nibName: "NoDeviceCell", bundle: nil), forCellReuseIdentifier: "NoDeviceCell")
       self.homeTableView.registerNib(UINib(nibName: "LightCell", bundle: nil), forCellReuseIdentifier: "LightCell")
    }
    func configView(){
      
        let bbi_r3=UIBarButtonItem(title: "调整", style:UIBarButtonItemStyle.Plain, target:self ,action:Selector("submit"));
        bbi_r3.tintColor=UIColor.whiteColor()
        self.navigationItem.rightBarButtonItems = [bbi_r3]
    
        
    }
  
   
    func submit(){
        isEdit = !isEdit
        print("")
        self.homeTableView.setEditing(isEdit, animated: true)
        if isEdit == false
        {
        print("\(getJsonStrOfDeviceData())")
            BaseHttpService.sendRequestAccess(addmodelinfo, parameters: ["modelInfo":getJsonStrOfDeviceData()], success: { (back) -> () in
                print(back)
            })
            
        }
    }

    override  func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden  = false
//        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        
          self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
      
       
        self.homeTableView.reloadData()
    }
    
//[{'modelId':'abcdefgh','deviceAddress':'56194','deviceType':'2','controlCommand':'50','delayValues':'10'}]
    func getJsonStrOfDeviceData()->String{
       
       let arr = NSMutableArray()
        for  e in app.modelEquipArr
        {
            let eq = e as! Equip
            let dict = ["modelId":self.modelId,"deviceAddress":eq.equipID,"deviceType":eq.type,"controlCommand":eq.status,"delayValues":eq.delay]
            arr.addObject(dict)
        }
    
        return dataDeal.toJSONString(arr)
    }
    
        // MARK: - Table view data source
    //返回节的个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
      
        return 1
    }
    //返回某个节中的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        
        return app.modelEquipArr.count + 1
      
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
     
            if app.modelEquipArr.count ==  indexPath.row
            {
            
             cell = self.homeTableView.dequeueReusableCellWithIdentifier("NoDeviceCell", forIndexPath: indexPath)
                  (cell as! NoDeviceCell).showLabel.text = "点击为情景模式添加设备"
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
                return cell!
                
            
            }
            let equip = app.modelEquipArr[indexPath.row] as! Equip
            if equip.type == "1"||judgeType(equip.type, type: "1")
            {//开关设备
                 cell = self.homeTableView.dequeueReusableCellWithIdentifier("LightCell", forIndexPath: indexPath)
                 cell?.backgroundColor = UIColor.whiteColor()
                 tableView.bringSubviewToFront(cell!)
                (cell as! LightCell).isMoni = true
                (cell as! LightCell).index = indexPath
                (cell as!LightCell).setModel(equip)
             
            }
            else if equip.type == "2" || equip.type == "4"||judgeType(equip.type, type: "3")||judgeType(equip.type, type: "2")
            {//可调设备
             cell = self.homeTableView.dequeueReusableCellWithIdentifier("ModulateCell", forIndexPath: indexPath)
                 cell?.backgroundColor = UIColor.whiteColor()
                 tableView.bringSubviewToFront(cell!)
                (cell as! ModulateCell).isMoni = true
                 (cell as! ModulateCell).index = indexPath
                 (cell as! ModulateCell).setModel(equip)
                
            }
        else if equip.type == "99" || equip.type == "98"
            {//红外学习设备
                cell = self.homeTableView.dequeueReusableCellWithIdentifier("InfraredCell", forIndexPath: indexPath)
                cell?.backgroundColor = UIColor.whiteColor()
                tableView.bringSubviewToFront(cell!)
                (cell as! InfraredCell).isMoni = true
                (cell as! InfraredCell).index = indexPath
                (cell as! InfraredCell).setModel(equip)
        }
        else{
            
                cell = self.homeTableView.dequeueReusableCellWithIdentifier("UnkownCell", forIndexPath: indexPath)
                 cell?.backgroundColor = UIColor.whiteColor()
                 tableView.bringSubviewToFront(cell!)
                //(cell as! UnkownCell).setModel(equip)
            
            }
         
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    
    func judgeType(str:String,type:String)->Bool
   {
    if str.trimString() == ""
    {
    return false
    }
    let str1 = str as NSString

    return  str1.substringToIndex(1) == type && str1.length == 4
    }
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            
        self.navigationController?.pushViewController(ChoseDeviceForModel(nibName: "ChoseDeviceForModel", bundle: nil), animated: true)
            
    }
        
       //高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView===self.homeTableView{
          
            if app.modelEquipArr.count  == indexPath.row{
            return 44
            }
            let equip = app.modelEquipArr[indexPath.row] as! Equip
        

            
            if equip.type == "1" || judgeType(equip.type, type: "1")
                
            {
                return 65
            }
            else if equip.type == "2" || equip.type == "4"||judgeType(equip.type, type: "3")||judgeType(equip.type, type: "2")
                
            {
                return 65
            }
            else if equip.type == "99" || equip.type == "98"
            {
                
                return 65
            }
            return 50
        }
      
        return 55
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
        return 0.001
        }
        return 30
    }
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        return view
//    }
    //手势识别
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return app.modelEquipArr.count != indexPath.row;
    }
    
    //cell点击事件
    //单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if app.modelEquipArr.count != indexPath.row{
            return UITableViewCellEditingStyle(rawValue:UITableViewCellEditingStyle.Delete.rawValue|UITableViewCellEditingStyle.Insert.rawValue)!
        }else{
             return UITableViewCellEditingStyle.None
        }
    }
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
      if  app.modelEquipArr.count > 0
      {
        let fromRow = sourceIndexPath.row;
        //    获取移动某处的位置
        let toRow = destinationIndexPath.row;
        //    从数组中读取需要移动行的数据
        let object = app.modelEquipArr[fromRow];
        //    在数组中移动需要移动的行的数据
        app.modelEquipArr.removeObjectAtIndex(fromRow)
        app.modelEquipArr.insertObject(object, atIndex: toRow)
        self.homeTableView.reloadData();
        } //    把需要移动的单元格数据在数组中，移动到想要移动的数据前面
        
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete && app.modelEquipArr.count > 0
        {
            let fromRow = indexPath.row;
            
            //    在数组中移动需要移动的行的数据
            app.modelEquipArr.removeObjectAtIndex(fromRow)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.homeTableView.reloadData();
        }
    }
    
 
      //
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
 
        
    }

    
}


