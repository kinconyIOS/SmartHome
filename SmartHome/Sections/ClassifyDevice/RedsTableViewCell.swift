//
//  RedsTableViewCell.swift
//  SmartHome
//
//  Created by Komlin on 16/5/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class RedsTableViewCell: UITableViewCell {

    @IBOutlet weak var sao: UIButton!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var identification: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
