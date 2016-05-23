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
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "矢量智能对象"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleBack:"))
        }
    func handleBack(barButton: UIBarButtonItem) {
        //self.navigationController?.popViewControllerAnimated(true)
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
                if( GlobalKit.shareKit().accessToken==nil){
                 showMsg("您暂时没有萤石设备")
                }
                else{
                 EZOpenSDK.setAccessToken(GlobalKit.shareKit().accessToken)
                    let cam = CameraCollectionView(nibName: "CameraCollectionView", bundle: nil)
                    cam.roomCode = self.roomCode
                     print("1----\(self.roomCode)")
                    self.navigationController?.pushViewController(cam, animated: true)
                }
               
                break
                
            }
        }
}
