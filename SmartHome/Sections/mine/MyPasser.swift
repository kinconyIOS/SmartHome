//
//  EquipTypeChoseTVC.swift
//  SmartHome
//
//  Created by sunzl on 16/4/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class MyPasser: UITableViewController {
    var roomCode:String?
    let dataSource = ["修改密码","取消密码"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="安全中心"
        self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
         navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "矢量智能对象"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleBack:"))
    }
    func handleBack(barButton: UIBarButtonItem) {
        for temp in self.navigationController!.viewControllers {
            if temp.isKindOfClass(HomeVC.classForCoder()) {
                self.navigationController?.popToViewController(temp , animated: true)
            }else if temp.isKindOfClass(MineVC.classForCoder()){
                self.navigationController?.popToViewController(temp , animated: true)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
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
            let vc1 = DBGViewController()
            
            vc1.isLogin = false
            self.navigationController!.pushViewController(vc1, animated:true)
            break
            
        default:
            NSUserDefaults.standardUserDefaults().setObject("0", forKey: "password")
            showMsg("取消成功！")
            break
            
        }
    }
    
}
