//
//  CreatRootVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/10.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

enum CreatType {
    case CreatTypeRoom, CreatTypeFloor
}

class CreatRootVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dataSource: NSMutableArray?
    
    @IBOutlet var tableView: UITableView!
    var creatType: CreatType = .CreatTypeRoom {
        willSet {
            switch newValue {
            case .CreatTypeRoom:
                navigationItem.title = "创建房间"
            case .CreatTypeFloor:
                navigationItem.title = "创建楼层"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "矢量智能对象"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleBack:"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "添加"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleRightItem:"))
        
        
        tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.registerNib(UINib(nibName: "RoomAndFloorCell", bundle: nil), forCellReuseIdentifier: "roomandfloorcell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
    }
    
    func handleBack(barButton: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func handleRightItem(barButton: UIBarButtonItem) {
        switch creatType {
        case .CreatTypeRoom:
            let roomVC = RoomAndRenameVC(nibName: "RoomAndRenameVC", bundle: nil)
            roomVC.viewType = RoomOrRenameType.RoomType
            navigationController?.pushViewController(roomVC, animated: true)
        case .CreatTypeFloor:
            let floorVC = FloorViewController(nibName: "FloorViewController", bundle: nil)
            navigationController?.pushViewController(floorVC, animated: true)
            
        }
        
    }
    

    @IBAction func handleCreat(sender: UIButton) {
        
    }
    
    //MARK tableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: RoomAndFloorCell = tableView.dequeueReusableCellWithIdentifier("roomandfloorcell", forIndexPath: indexPath) as! RoomAndFloorCell

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if creatType == CreatType.CreatTypeRoom {
            cell.creatType = CreatType.CreatTypeRoom
            cell.handleEditAction = {
                [unowned self]
                () -> () in
                let renameVC = RoomAndRenameVC()
                renameVC.viewType = RoomOrRenameType.RenameType
                self.navigationController?.pushViewController(renameVC, animated: true)
            }
        } else if creatType == CreatType.CreatTypeFloor {
            cell.creatType = CreatType.CreatTypeFloor
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 53
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if creatType == .CreatTypeFloor {
            let floorVC = FloorViewController()
            navigationController?.pushViewController(floorVC, animated: true)
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
