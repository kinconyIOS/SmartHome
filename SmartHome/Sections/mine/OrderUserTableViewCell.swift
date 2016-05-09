//
//  OrderUserTableViewCell.swift
//  SmartHome
//
//  Created by Komlin on 16/5/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class OrderUserTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var Phone: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
