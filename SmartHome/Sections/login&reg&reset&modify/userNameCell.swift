//
//  userNameCell.swift
//  SmartHome
//
//  Created by sunzl on 15/12/31.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
typealias DeleteSelf=(Int)->()
class userNameCell: UITableViewCell {
 
    @IBOutlet var userName: UILabel!
    var deleteSelf:DeleteSelf?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteTap(sender: AnyObject) {
        deleteSelf!(self.tag)
    }
    
}
