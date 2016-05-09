//
//  LightCell.swift
//  SmartHome
//
//  Created by sunzl on 16/1/15.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class LightCell: UITableViewCell {
    @IBOutlet var btn: UIButton!

    @IBOutlet var iswitch: UISwitch!

    @IBOutlet var nameLabel: UILabel!
    var equip:Equip?
    override func awakeFromNib() {
        super.awakeFromNib()
        btn.setImage(UIImage(imageLiteral: "普通灯泡"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named:"dark"), forState: UIControlState.Selected)
        // Initialization code
    }

   
  
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(e:Equip){
        
        self.equip = e
        self.nameLabel.text = e.name
        //let num =  Int( (equip?.num)!)! + 100
        if e.status != ""{
            iswitch.on  = Float(e.status)! > 50
            btn.selected = Float(e.status)! < 50
        }
      
      
   
    }
    
    @IBAction func valueChangeTap(sender: UISwitch) {
        print(sender.on)
        let commad = sender.on ? 100 : 0
        let address = self.equip?.equipID
        let dic = ["deviceAddress":address!,"command":commad]
        BaseHttpService.sendRequestAccess(commad_do, parameters: dic) { (back) -> () in
           
            self.btn.selected = !self.btn.selected
            print(back)
        }
    }
}
