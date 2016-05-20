//
//  EquipTypeChoseTVC.swift
//  SmartHome
//
//  Created by sunzl on 16/4/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class MySetUp: UITableViewController ,UIAlertViewDelegate{
    var roomCode:String?
    let dataSource = ["安全中心","意见反馈","清除缓存","功能说明","关于我们"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="我的设置"
        self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
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
            //安全设置

            let vc1 = MyPasser()
            self.navigationController!.pushViewController(vc1, animated:true)
            break
        case 1:
            let indvc:FeedbackViewController=FeedbackViewController(nibName: "FeedbackViewController", bundle: nil)
            indvc.hidesBottomBarWhenPushed=true
            self.navigationController!.pushViewController(indvc, animated:true)
            break
        case 2:
            let cachPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
            let num = FileManager().folderSizeAtPath(cachPath)
            
            let alert = UIAlertView(title: "提示", message: "缓存大小为\(String(format: "%.2f", num) )M确定要清理吗?", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消")
            alert.tag = 1
            alert.show()
            break
        default:
            break
        }
    }
    //清除缓存
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 1{
            if buttonIndex == 0{
                let cachPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
                let files = NSFileManager.defaultManager().subpathsAtPath(cachPath )
                for p in files!{
                    
                    let path = (cachPath as NSString).stringByAppendingPathComponent(p)
                    if NSFileManager.defaultManager().fileExistsAtPath(path){
                        do{
                            try NSFileManager.defaultManager().removeItemAtPath(path)
                        }catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        
        
    }

}
