//
//  ChoseDeviceTypeVC.swift
//  SmartHome
//  射频
//  Created by sunzl on 16/4/7.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class ChoseDeviceTypeVC: UIViewController {
    
    private var compeletBlock: ((String,Int)->())?
  
    
    func configCompeletBlock(compeletBlock: (equipType: String,v:Int)->()) {
        self.compeletBlock = compeletBlock
        
    }
    let typeDataSource = ["普通灯","调光灯","窗帘"]
    let codeDataSource = ["2262","1527"]
    let hzDataSource = ["315HZ","433HZ"]
    let ohmDataSource = ["1.2Ω","1.5Ω","2.2Ω","3.3Ω","4.7Ω"]
    @IBOutlet var typeBtn: UIButton!
    @IBOutlet var codeBtn: UIButton!

    @IBOutlet var hzBtn: UIButton!
    @IBOutlet var ohmBtn: UIButton!
     var type_value = -1
     var code_value = 1
     var hz_value = 1
     var ohm_value = 4
    
    @IBOutlet var tables: [UITableView]!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeBtn.layer.borderWidth = 1.0
        typeBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
        codeBtn.layer.borderWidth = 1.0
        codeBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
        hzBtn.layer.borderWidth = 1.0
        hzBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
        ohmBtn.layer.borderWidth = 1.0
        ohmBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
        for table in tables
        {
            table.hidden = true
        }
        //修改导航栏按钮；
         let bbi_r1 = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveChose:"))
        
        bbi_r1.tintColor=UIColor.whiteColor()
      
        self.navigationItem.rightBarButtonItems = [bbi_r1]
        // Do any additional setup after loading the view.
    }
    func saveChose(){
        if type_value == -1
        {
        showMsg("请确认类型")
        }
        let type = typeBtn.titleLabel?.text
      //  let code = codeBtn.titleLabel?.text
      //  let hz = hzBtn.titleLabel?.text
      //  let ohm = ohmBtn.titleLabel?.text
        let str = type!// + " " + code! + " " + hz! + " " + ohm!
        self.compeletBlock!(str,type_value*1000+code_value*100+hz_value*10+ohm_value)
        self.navigationController?.popViewControllerAnimated(true)
    
    }
    @IBAction func hideTable(sender: UIView) {
        for table in tables
        {
            table.hidden = true
        }
    }
 
    @IBAction func tap(sender: UIButton) {
        for table in tables
        {
        table.hidden = !(table.tag-200 == sender.tag-100)
        }
    }
    // MARK: - Table view data source
    //返回节的个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
  
        return 1
    }
    //返回某个节中的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(tableView.tag)
        {
        case 200:
         return   typeDataSource.count
     
        case 201:
            return codeDataSource.count

        case 202:
            return hzDataSource.count
      
        default:
            return ohmDataSource.count
       
        }
        
       
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil{
        cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        var dataSource  = []
        switch(tableView.tag)
        {
        case 200:
           dataSource = typeDataSource
            break
            
        case 201:
          dataSource = codeDataSource
            break
            
        case 202:
            dataSource = hzDataSource
            break
            
        default:
            dataSource = ohmDataSource
            break
        }
        cell?.textLabel?.font = UIFont.systemFontOfSize(13.0)
        cell?.textLabel?.text = dataSource[indexPath.row] as? String
        cell?.backgroundColor = UIColor .whiteColor()
        return cell!
    }
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(tableView.tag)
        {
        case 200:
            typeBtn.setTitle(typeDataSource[indexPath.row], forState: UIControlState.Normal)
            type_value = indexPath.row + 1
            break
            
        case 201:
            codeBtn.setTitle(codeDataSource[indexPath.row], forState: UIControlState.Normal)
            code_value = indexPath.row + 1
            break
            
        case 202:
            hzBtn.setTitle(hzDataSource[indexPath.row], forState: UIControlState.Normal)
            hz_value = indexPath.row + 1
            break
            
        default:
            ohmBtn.setTitle(ohmDataSource[indexPath.row], forState: UIControlState.Normal)
            ohm_value = indexPath.row+1
            break
        }
    }
    

    
    //高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 40
    }
}
