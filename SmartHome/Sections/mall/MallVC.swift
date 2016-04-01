//
//  MallVC.swift
//  SmartHome
//
//  Created by kincony on 16/3/31.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class MallVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var cell:CommodityTableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.title = "智能商场"
        
        tableView.dataSource=self
        tableView.delegate=self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //拉出cell
        tableView.registerNib(UINib(nibName:"CommodityTableViewCell", bundle: nil), forCellReuseIdentifier:"Commod")
        // Do any additional setup after loading the view.
    }
    //分区
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //节
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    //cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCellWithIdentifier("Commod") as? CommodityTableViewCell
        return cell!
    }
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 120
    }
//    //分区头
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return " "
//    }
    //cell点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let view:DetailsViewController=DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        view.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(view, animated: true)
    }
    @IBOutlet var tableView: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
