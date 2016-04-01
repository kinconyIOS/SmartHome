//
//  CommentTableViewCell.swift
//  SmartHome
//
//  Created by kincony on 16/4/1.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet var headIMG: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        headIMG.layer.cornerRadius = headIMG.frame.size.height/2
        headIMG.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
