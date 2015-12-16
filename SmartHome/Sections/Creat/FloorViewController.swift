//
//  FloorViewController.swift
//  SmartHome
//
//  Created by kincony on 15/12/16.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class FloorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var isShowRoom = false
    
    var count = 5
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "创建楼层"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "矢量智能对象"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleBack:"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleRightItem:"))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.bounces = false
        tableView.registerNib(UINib(nibName: "FloorRoomCell", bundle: nil), forCellReuseIdentifier: "floorroomcell")
        tableView.registerNib(UINib(nibName: "AddRoomCell", bundle: nil), forCellReuseIdentifier: "addroomcell")
        
    }
    
    func handleBack(barButton: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func handleRightItem(barButton: UIBarButtonItem) {
        
    }
    
    @IBOutlet var floorTF: UITextField!
    @IBOutlet var detailBtn: UIButton!
    @IBAction func handleDetailBtn(sender: UIButton) {
        isShowRoom = true
        tableView.reloadData()
    }
    @IBAction func exitAction(sender: UITextField) {
        
    }
    
    // MARK: -Table View DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowRoom {
            return count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.row + 1 == count {
            let cell: AddRoomCell = tableView.dequeueReusableCellWithIdentifier("addroomcell", forIndexPath: indexPath) as! AddRoomCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        let cell: FloorRoomCell = tableView.dequeueReusableCellWithIdentifier("floorroomcell", forIndexPath: indexPath) as! FloorRoomCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row + 1 == tableView.numberOfRowsInSection(0) {
            let roomVC = RoomAndRenameVC()
            roomVC.viewType = .RoomType
            navigationController?.pushViewController(roomVC, animated: true)
        }
    }
    
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
