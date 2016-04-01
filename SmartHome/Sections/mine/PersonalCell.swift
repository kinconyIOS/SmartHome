//
//  PersonalCell.swift
//  SmartHome
//
//  Created by kincony on 16/3/28.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class PersonalCell: UITableViewCell {

    @IBOutlet var ShoppingCart: UIButton!
    
    @IBOutlet var Collection: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
