//
//  ModulateCell.swift
//  SmartHome
//
//  Created by sunzl on 16/4/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class ModulateCell: UITableViewCell {
  @IBOutlet var delayBtn: UIButton!
    @IBOutlet var iconImg: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var slider: UISlider!
    var index:NSIndexPath?
    var equip:Equip?
    var isMoni:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        slider.setThumbImage(UIImage(named: "silder"), forState: UIControlState.Normal)
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func valueChangeTap(sender: UISlider) {
       print("------\(self.index?.row)")
       let commad = Int(sender.value * 100)
        print(sender.value)
        print(commad)
        
        
        if isMoni
        {
         
            ( app.modelEquipArr[(self.index?.row)!] as! Equip).status = String(commad)
             print("------\((app.modelEquipArr[0] as! Equip).status)")
             print("------\((app.modelEquipArr[1] as! Equip).status)")
             print("------\((app.modelEquipArr[2] as! Equip).status)")
            return
        }
        let address = self.equip?.equipID
        let dic = ["deviceAddress":address!,"command":commad,"keyvalue":1,"":""]
        BaseHttpService.sendRequestAccess(commad_do, parameters: dic) { (back) -> () in
            print(back)
        }
    }
    func setModel(e:Equip){
        self.equip = e
        self.iconImg.image = UIImage(named: e.icon)
        self.nameLabel.text = e.name
      
        if isMoni
        {  print("------\(self.index?.row)")
            self.equip?.status = String(Int(slider.value * 100))
             app.modelEquipArr.replaceObjectAtIndex((self.index?.row)!, withObject: self.equip!)
            self.delayBtn.hidden = false
            return
        }
        self.delayBtn.hidden = true
        
        if e.status != ""{
        self.slider.value = Float(e.status)! * 0.01
        }
    }
    @IBAction func delayChoseTap(sender: AnyObject) {
        let parent =  self.parentController() as! CreateModelVC
        parent.sunData?.setNumberOfComponents(1, SET:["立即执行","延迟0.5秒","延迟1秒","延迟2秒","延迟3秒","延迟4秒","延迟5秒","延迟10秒","延迟15秒","延迟30秒"], addTarget:parent.navigationController!.view , complete: { [unowned self](one, two, three) -> Void in
            let a = "\(one)"
            self.delayBtn.setTitle(a, forState: UIControlState.Normal)
            switch(a){
            case "立即执行":self.equip?.delay = "200"//ms
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
            if nextr!.isKindOfClass(CreateModelVC.classForCoder()){
                return (nextr as! UIViewController)
            }
            
        }
        return nil
    }
    
}
