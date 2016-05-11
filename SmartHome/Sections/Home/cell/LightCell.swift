//
//  LightCell.swift
//  SmartHome
//
//  Created by sunzl on 16/1/15.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class LightCell: UITableViewCell {
    @IBOutlet var delayBtn: UIButton!
    
    @IBOutlet var btn: UIButton!

    @IBOutlet var iswitch: UISwitch!

    @IBOutlet var nameLabel: UILabel!
    
    var isMoni:Bool = false
    var index:NSIndexPath?
    var equip:Equip?
    override func awakeFromNib() {
        super.awakeFromNib()
        btn.setImage(UIImage(imageLiteral: "普通灯泡"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named:"dark"), forState: UIControlState.Selected)
        // Initialization code
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
            if nextr!.isKindOfClass(UIViewController.classForCoder()){
                return (nextr as! UIViewController)
            }
            
        }
        return nil
    }
  
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(e:Equip){
        
        self.equip = e
        self.nameLabel.text = e.name
        
        if isMoni
        {
            self.equip?.status = String(Int(iswitch.on ? 100 : 0))
          
            app.modelEquipArr.replaceObjectAtIndex((self.index?.row)!, withObject: self.equip!)
            self.delayBtn.hidden = false
            return
        }
        self.delayBtn.hidden = true
        if e.status != ""{
            iswitch.on  = Float(e.status)! > 50
            btn.selected = Float(e.status)! < 50
        }
      
      
   
    }
    
    @IBAction func valueChangeTap(sender: UISwitch) {
       
        print(sender.on)
       
        let commad = sender.on ? 100 : 0
        let address = self.equip?.equipID
        if isMoni
        {
            self.equip?.status = String(commad)
            app.modelEquipArr.replaceObjectAtIndex((self.index?.row)!, withObject: self.equip!)
            return
        }
        let dic = ["deviceAddress":address!,"command":commad]
        BaseHttpService.sendRequestAccess(commad_do, parameters: dic) { (back) -> () in
           
            self.btn.selected = !self.btn.selected
            print(back)
        }
    }
}
