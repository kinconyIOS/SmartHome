//
//  EquipAddVC.swift
//  SmartHome
//
//  Created by kincony on 16/1/5.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class EquipAddVC: UITableViewController, UIGestureRecognizerDelegate {
    
    private var compeletBlock: ((Equip)->())?
    
    func configCompeletBlock(compeletBlock: (equip: Equip)->()) {
        self.compeletBlock = compeletBlock
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationItem.title = "添加设备"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "矢量智能对象"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleBack:"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleRightItem:"))
        
        self.tableView.registerNib(UINib(nibName: "EquipNameCell", bundle: nil), forCellReuseIdentifier: "equipnamecell")
        self.tableView.registerNib(UINib(nibName: "EquipConfigCell", bundle: nil), forCellReuseIdentifier: "equipconfigcell")
        self.tableView.registerNib(UINib(nibName: "EquipImageCell", bundle: nil), forCellReuseIdentifier: "equipimagecell")
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        self.tableView.addGestureRecognizer(tap)
        
    }
    
    func handleTap(tap: UITapGestureRecognizer) {
        self.tableView.endEditing(true)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
    
    func handleBack(barButton: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func handleRightItem(barButton: UIBarButtonItem) {
       // compeletBlock?(equip)
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
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
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("equipconfigcell", forIndexPath: indexPath) as! EquipConfigCell
            cell.cellTitle.text = "设备类型"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("equipnamecell", forIndexPath: indexPath) as! EquipNameCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("equipimagecell", forIndexPath: indexPath) as! EquipImageCell
            cell.cellTitleLabel.text = "设备图标"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("equipimagecell", forIndexPath: indexPath) as! EquipImageCell
            cell.cellTitleLabel.text = "学习界面"
            return cell
        default:
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reusetableview")
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 2:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! EquipImageCell
            
            let choosIconVC = ChooseIconVC(nibName: "ChooseIconVC", bundle: nil)
            choosIconVC.chooseImageBlock( { [unowned self,unowned cell] (imageName) -> () in
             
                cell.cellIconImage.image = UIImage(named: imageName)
             //self.equip.icon = imageName
                })
            self.navigationController?.pushViewController(choosIconVC, animated: true)
        case 3:
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
