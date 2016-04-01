//
//  EquipSetVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/30.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class EquipSetVC: UITableViewController, UIGestureRecognizerDelegate {
    private var compeletBlock: ((Equip)->())?
    var equip: Equip?
    
    func configCompeletBlock(compeletBlock: (equip: Equip)->()) {
        self.compeletBlock = compeletBlock
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationItem.title = "我的设备"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "矢量智能对象"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleBack:"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleRightItem:"))
        
        
        self.tableView.registerNib(UINib(nibName: "EquipNameCell", bundle: nil), forCellReuseIdentifier: "equipnamecell")
        self.tableView.registerNib(UINib(nibName: "EquipConfigCell", bundle: nil), forCellReuseIdentifier: "equipconfigcell")
        self.tableView.registerNib(UINib(nibName: "EquipImageCell", bundle: nil), forCellReuseIdentifier: "equipimagecell")
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        self.tableView.addGestureRecognizer(tap)
        
        
    }
    
    func handleBack(barButton: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func handleRightItem(barButton: UIBarButtonItem) {
       
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! EquipNameCell
          equip!.name = (cell.equipName.text?.trimString())!
        print("\(equip?.name)-\(equip?.icon)-\(equip?.roomCode)")
        compeletBlock?(equip!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
           let cell = tableView.dequeueReusableCellWithIdentifier("equipimagecell", forIndexPath: indexPath) as! EquipImageCell
           cell.cellTitleLabel.text = "设备图标:"
           cell.cellIconImage.image = UIImage(named:(equip?.icon)!)
           
           return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("equipconfigcell", forIndexPath: indexPath) as! EquipConfigCell
            cell.cellTitle.text = "所属房间:"
            if equip?.roomCode != "" {
                let room = dataDeal.searchModel(.Room, byCode: (equip?.roomCode)!) as! Room
                cell.cellDetail.text = room.name
            } else {
                cell.cellDetail.text = ""
            }
            
            return cell
        default:
           let cell = tableView.dequeueReusableCellWithIdentifier("equipnamecell", forIndexPath: indexPath) as! EquipNameCell
           cell.selectionStyle = UITableViewCellSelectionStyle.None
           return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! EquipImageCell
            
            let choosIconVC = ChooseIconVC(nibName: "ChooseIconVC", bundle: nil)
            choosIconVC.chooseImageBlock({ [unowned cell] (imageStr) -> () in
                self.equip?.icon = imageStr
                cell.cellIconImage.image = UIImage(named: imageStr)
            })
            self.navigationController?.pushViewController(choosIconVC, animated: true)
        case 2:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as! EquipConfigCell
            let floorArr = dataDeal.getModels(.Floor) as! [Floor]
            var codeArr = [String]()
            var nameArr = [String]()
            for floor in floorArr {
                let roomArr = dataDeal.getRoomsByFloor(floor)
                for room in roomArr {
                    codeArr.append(room.roomCode)
                    nameArr.append("\(floor.name)   \(room.name)")
                }
            }
            
            let chooseAlert = SHChooseAlertView(title: "所属房间", dataSource: nameArr, cancleButtonTitle: "取消", confirmButtonTitle: "确定")
            chooseAlert.alertAction({ [unowned cell, unowned self] (alert, buttonIndex) -> () in
                switch buttonIndex {
                case 0:
                    break
                case 1:
                    cell.cellDetail.text = alert.selectItem
                    self.equip?.roomCode = codeArr[alert.selectRow]
                default:
                    break
                }
            })
            chooseAlert.show()
            tableView.deselectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2), animated: true)
            break
        default:
            break
        }
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
