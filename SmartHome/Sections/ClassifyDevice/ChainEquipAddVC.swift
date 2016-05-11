//
//  EquipAddVC.swift
//  SmartHome
//
//  Created by kincony on 16/1/5.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class ChainEquipAddVC: UITableViewController, UIGestureRecognizerDelegate {
    var model: ChainModel? = ChainModel()
    var equipIndex :NSIndexPath?
    var NameText:String?//导航栏名

    
    var arr = [String]()
    private var compeletBlock: ((Equip,NSIndexPath)->())?
    
    func configCompeletBlock(compeletBlock: (equip: Equip,indexPath:NSIndexPath)->()) {
        self.compeletBlock = compeletBlock
    }
    
    
    var sunData:SunDataPicker? = SunDataPicker.init(frame: CGRectMake(0, 100,ScreenWidth-20 , (ScreenWidth-20)*3/3))
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        navigationItem.title = NameText
  
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
    //获取随机六位数ID
    func randomNumAndLetter()->String
    {
        let kNumber = 6;
        let sourceStr:NSString="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        var resultStr = ""
        srand(UInt32(time(nil)))
        
        for   _ in  0..<kNumber
        {
            let index = Int(rand())%sourceStr.length;
            let oneStr = sourceStr.substringWithRange(NSMakeRange(index, 1))
            resultStr += oneStr
        }
        return resultStr
    }
    func handleRightItem(barButton: UIBarButtonItem) {
        //保存 编辑
        if self.model?.modelId == ""{
           self.model?.modelId = self.randomNumAndLetter()
        }
        let parameters = ["modelId":self.model!.modelId
            ,"modelName":self.model!.modelName
            ,"ico":self.model!.modelIcon]
        BaseHttpService.sendRequestAccess(Add_addmodel, parameters: parameters) { [unowned self](back) -> () in
            print(back)
            
        }
        self.navigationController?.popViewControllerAnimated(true)
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
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("equipnamecell", forIndexPath: indexPath) as! EquipNameCell
            cell.leab.text = "模式名称"
            if self.model?.modelName != ""{
                cell.equipName.text = self.model?.modelName
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.complete = {[unowned self](name)in
                print(name)
               
                self.model?.modelName = name!
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("equipimagecell", forIndexPath: indexPath) as! EquipImageCell
            if self.model?.modelIcon != ""{
                cell.cellIconImage.image = UIImage(named: (self.model?.modelIcon)!)
                //cell.cellIconImage.contentMode = UIViewContentMode.ScaleAspectFill
            }
            cell.cellTitleLabel.text = "模式图标"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("equipconfigcell", forIndexPath: indexPath) as! EquipConfigCell
            cell.cellTitle.text = "模式设置"
            cell.cellDetail.text = "进入详细设置界面"
            return cell
        default:
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reusetableview")
            return cell
        }
        
        
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 1:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! EquipImageCell
            
            let choosIconVC = ChainVC(nibName: "ChainVC", bundle: nil)
            choosIconVC.chooseImageBlock( { [unowned self,unowned cell] (imageName) -> () in
                
                cell.cellIconImage.image = UIImage(named: imageName)
                self.model?.modelIcon = imageName
                })
            self.navigationController?.pushViewController(choosIconVC, animated: true)

            break
        case 2:
            let createVc = CreateModelVC(nibName: "CreateModelVC", bundle: nil)
            createVc.modelId = (self.model?.modelId)!
            self.navigationController?.pushViewController(createVc, animated: true)
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
