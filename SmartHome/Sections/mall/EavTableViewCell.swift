//
//  EavTableViewCell.swift
//  SmartHome
//
//  Created by Komlin on 16/4/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class EavTableViewCell: UITableViewCell {

    @IBOutlet weak var timers: UILabel!
    @IBOutlet weak var ealvate: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
