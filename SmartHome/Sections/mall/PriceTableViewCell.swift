//
//  PriceTableViewCell.swift
//  SmartHome
//
//  Created by kincony on 16/4/1.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell {

    @IBOutlet weak var goodTitle: UILabel!
    @IBOutlet weak var goodPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
