//
//  ModulateCell.swift
//  SmartHome
//
//  Created by sunzl on 16/4/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class ModulateCell: UITableViewCell {

    @IBOutlet var iconImg: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var slider: UISlider!
    var equip:Equip?
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
        print(sender.value)
        let commad = Int(sender.value * 100)
        print(commad)
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
        if e.status != ""{
        self.slider.value = Float(e.status)! * 0.01
        }
    }

    
}
