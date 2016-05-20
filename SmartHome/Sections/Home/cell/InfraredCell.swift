//
//  InfraredCell.swift
//  SmartHome
//
//  Created by sunzl on 16/5/9.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class InfraredCell: UITableViewCell {
    
    @IBOutlet weak var txtLabel: UIButton!
    @IBOutlet var name: UILabel!
    @IBOutlet var icon: UIImageView!
      @IBOutlet var delayBtn: UIButton!
    var index:NSIndexPath?
    var equip:Equip?
    var isMoni:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //闭包获取姓名

    func setModel(e:Equip){
         self.equip = e
        self.name.text = e.name
        self.icon.image = UIImage(named: e.icon)
        if isMoni
        {
        //情景界面
        self.delayBtn.hidden = false
            var str = ""
            switch(self.equip!.delay){
            case "300":str = "立即执行"//ms
                break
            case "600":str = "延迟0.5秒"
                break
            case "1000":str = "延迟1秒"
                break
            case "2000":str = "延迟2秒"
                break
            case "3000":str = "延迟3秒"
                break
            case "4000":str = "延迟4秒"
                break
            case "5000":str = "延迟5秒"
                break
            case "10000":str = "延迟10秒"
                break
            case "15000":str = "延迟15秒"
                break
            case "30000":str = "延迟30秒"
                break
            default:break
                
            }
            self.delayBtn.setTitle(str, forState: UIControlState.Normal)
        //1 txtLabel显示的文字
            if e.status != ""{
                //e.status "1,name"
                let arrayStr = e.status.componentsSeparatedByString(",")
                self.txtLabel.setTitle(arrayStr[1], forState: UIControlState.Normal) 
            }

        }else{
        //控制界面
        //1
        self.delayBtn.hidden = true
        }
        
    }
    @IBAction func controlTap(sender: AnyObject) {
        
        //----------
        let infraredVC = InfraredViewController(nibName: "InfraredViewController", bundle: nil)
        infraredVC.swif = 0
        BaseHttpService .sendRequestAccess(Get_gaininfraredbuttonses, parameters:["deviceAddress":self.equip!.equipID]) { (response) -> () in
            print(response)
            if response.count != 0{
                infraredVC.cellArr = response as! NSArray
            }
            //print(infraredVC.cellArr)
            infraredVC.WillAppear()
        }
        infraredVC.Address = self.equip!.equipID
        infraredVC.equip = self.equip
        infraredVC.index = self.index
        infraredVC.isMoni = self.isMoni
        infraredVC.swif = 1
        
        
        self.parentController()!.navigationController?.pushViewController(infraredVC, animated: true)
    }
    @IBAction func delayChoseTap(sender: AnyObject) {
        let parent =  self.parentController() as! CreateModelVC
        parent.sunData?.setNumberOfComponents(1, SET:["立即执行","延迟0.5秒","延迟1秒","延迟2秒","延迟3秒","延迟4秒","延迟5秒","延迟10秒","延迟15秒","延迟30秒"], addTarget:parent.navigationController!.view , complete: { [unowned self](one, two, three) -> Void in
            let a = "\(one)"
            self.delayBtn.setTitle(a, forState: UIControlState.Normal)
            switch(a){
            case "立即执行":self.equip?.delay = "300"//ms
                break
            case "延迟0.5秒":self.equip?.delay = "600"
                break
            case "延迟1秒":self.equip?.delay = "1000"
                break
            case "延迟2秒":self.equip?.delay = "2000"
                break
            case "延迟3秒":self.equip?.delay = "3000"
                break
            case "延迟4秒":self.equip?.delay = "4000"
                break
            case "延迟5秒":self.equip?.delay = "5000"
                break
            case "延迟10秒":self.equip?.delay = "10000"
                break
            case "延迟15秒":self.equip?.delay = "15000"
                break
            case "延迟30秒":self.equip?.delay = "30000"
                break
            default:break
                
            }

             app.modelEquipArr.replaceObjectAtIndex((self.index?.row)!, withObject: self.equip!)
            print(a)
        })
    }
    
    func parentController()->UIViewController?
    {
        for (var next = self.superview; next != nil; next = next!.superview) {
            let nextr = next?.nextResponder()
            if nextr!.isKindOfClass(UIViewController.classForCoder()){
                return (nextr as! UIViewController)
            }
            
        }
        return nil
    }
 
    


}
