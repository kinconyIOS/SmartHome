//
//  EquipTypeChoseTVC.swift
//  SmartHome
//
//  Created by sunzl on 16/4/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class DeviceManagerVC: UITableViewController {
    var roomCode:String?
    let dataSource = ["添加主机","删除主机"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "主机管理"
        self.navigationItem.title="主机管理"
        self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
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
            let addDeviceVC: AddDeviceViewController = AddDeviceViewController(nibName: "AddDeviceViewController", bundle: nil)
            addDeviceVC.setCompeletBlock { [unowned self]() -> () in
                
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(addDeviceVC, animated: true)
            break
            
        default:
            BaseHttpService .sendRequestAccess(getallhost_do, parameters:[:]) { (response) -> () in
                print(response)
                if response.count == 0{
                    let alert = UIAlertView(title: "提示", message: "您还没添加主机", delegate: self, cancelButtonTitle: "我知道了")
                    alert.tag = 2
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
                        let parameters=["deviceCode":a]
                        BaseHttpService.sendRequestAccess(Dele_tallhost, parameters:parameters) { [unowned dataDeal] (response) -> () in
                            dataDeal.clearEquipTable()
                        }
                    })
                    
                }
            }

            break
            
        }
    }
    
}
