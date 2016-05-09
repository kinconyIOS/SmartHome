//
//  MyHeadCell.swift
//  SmartHome
//
//  Created by Komlin on 16/4/22.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class MyHeadCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var headImg: UIImageView!

    @IBOutlet weak var qianm: UILabel!
    @IBOutlet weak var ctiy: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var name: UILabel!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
