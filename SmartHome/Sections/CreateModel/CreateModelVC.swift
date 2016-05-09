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

 
    var deviceDataSource = []
    
    
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
      
    
        
    }

    override  func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden  = false
//        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        
          self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
       
        self.homeTableView.reloadData()
    }
    

   
    
        // MARK: - Table view data source
    //返回节的个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
      
        return 1
    }
    //返回某个节中的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        
        return deviceDataSource.count + 1
      
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
     
            if deviceDataSource.count < 1
            {
            
             cell = self.homeTableView.dequeueReusableCellWithIdentifier("NoDeviceCell", forIndexPath: indexPath)
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
                return cell!
                
            
            }
            let equip = deviceDataSource[indexPath.row] as! Equip
            if equip.type == "1"||judgeType(equip.type, type: "1")
            {//开关设备
                 cell = self.homeTableView.dequeueReusableCellWithIdentifier("LightCell", forIndexPath: indexPath)
                 cell?.backgroundColor = UIColor.whiteColor()
                 tableView.bringSubviewToFront(cell!)
                (cell as!LightCell).setModel(equip)
            }
            else if equip.type == "2" || equip.type == "4"||judgeType(equip.type, type: "3")||judgeType(equip.type, type: "2")
            {//可调设备
             cell = self.homeTableView.dequeueReusableCellWithIdentifier("ModulateCell", forIndexPath: indexPath)
                 cell?.backgroundColor = UIColor.whiteColor()
                 tableView.bringSubviewToFront(cell!)
                 (cell as! ModulateCell).setModel(equip)
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
          
            if deviceDataSource.count < 1{
            return 44
            }
            let equip = deviceDataSource[indexPath.row] as! Equip
        

            if equip.type == "1" || judgeType(equip.type, type: "1")

            {
                return 53
            }
            else if equip.type == "2" || equip.type == "4"||judgeType(equip.type, type: "3")||judgeType(equip.type, type: "2")

            {
                return 47
            }
            return 47
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
  
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
 
        
    }

    
}


