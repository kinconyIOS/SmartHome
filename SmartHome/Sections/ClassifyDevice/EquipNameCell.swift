//
//  EquipNameCell.swift
//  SmartHome
//
//  Created by kincony on 15/12/30.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class EquipNameCell: UITableViewCell {

    @IBOutlet var equipName: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func exitEndAction(sender: UITextField) {
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
