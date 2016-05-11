//
//  EquipNameCell.swift
//  SmartHome
//
//  Created by kincony on 15/12/30.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
typealias completeEquipName = (String?) -> ()
class EquipNameCell: UITableViewCell {

     var complete:completeEquipName?
    @IBOutlet var equipName: UITextField!
    @IBOutlet weak var leab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func exitEndAction(sender: UITextField) {
        if sender.text == nil  { sender.text = "" }
        self.complete!(sender.text)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
