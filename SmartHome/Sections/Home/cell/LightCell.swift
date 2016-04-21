//
//  LightCell.swift
//  SmartHome
//
//  Created by sunzl on 16/1/15.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class LightCell: UITableViewCell {
    @IBOutlet var btns: [UIButton]!


    @IBOutlet var nameLabel: UILabel!
    var equip:Equip?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    @IBAction func switchTapWith(sender: UIButton) {
        print(sender.selected)
        let commad = sender.selected ? 0 : 100
      
        let address = self.equip?.equipID
        let dic = ["deviceAddress":address!,"command":commad,"keyvalue":sender.tag - 100,"":""]
        BaseHttpService.sendRequestAccess(commad_do, parameters: dic) { (back) -> () in
            sender.selected = !sender.selected
            print(back)
        }
    }
  
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(e:Equip){
        self.equip = e
        self.nameLabel.text = e.name
        let num =  Int( (equip?.num)!)! + 100
       
        for btn in self.btns
        {
            if btn.tag <= num{
            btn.hidden = false
              btn.setImage(UIImage(named:e.icon), forState: UIControlState.Normal)
              btn.setImage(UIImage(named:e.icon), forState: UIControlState.Selected)
            }else
            {
             btn.hidden = true
            }
        }
      
   
    }
    
}
