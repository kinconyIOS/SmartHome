//
//  CameraTypeTVC.swift
//  SmartHome
//
//  Created by sunzl on 16/4/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class CameraTypeTVC: UITableViewController {

        let dataSource = ["普通摄像头","萤石摄像头"]
        var roomCode:String = ""
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.title = "选择摄像头种类"
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
              navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
            self.tableView.tableFooterView = UIView()
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
            cell?.textLabel?.font = UIFont.systemFontOfSize(14)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        
            return cell!
        }
        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            switch(indexPath.row){
            case 0:
              
                let w = Wrapper()
                w.push(self,roomCode: self.roomCode)
               
                break
            default:
                showMsg("暂未开放敬请期待")
                break
                
            }
        }
}
