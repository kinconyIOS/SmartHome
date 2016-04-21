//
//  ParameterTableViewCell.swift
//  SmartHome
//
//  Created by kincony on 16/4/1.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class ParameterTableViewCell: UITableViewCell {

    @IBOutlet weak var goodColor: UILabel!
    @IBOutlet weak var goodSize: UILabel!
    @IBOutlet weak var workingVoltage: UILabel!
    @IBOutlet weak var materialGood: UILabel!
    @IBOutlet weak var commUnicatuinMode: UILabel!
    @IBOutlet weak var workingTemperature: UILabel!
    @IBOutlet weak var workingHumidity: UILabel!
    @IBOutlet weak var powerConsunmption: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
