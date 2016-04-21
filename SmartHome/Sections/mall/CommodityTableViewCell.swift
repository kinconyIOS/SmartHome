//
//  CommodityTableViewCell.swift
//  SmartHome
//
//  Created by kincony on 16/3/31.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class CommodityTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var commodityImg: UIImageView!//商品展示图片
    @IBOutlet weak var commdityFollow: UIButton!//商品关注
    @IBOutlet weak var commdityName: UILabel!//商品名字
    @IBOutlet weak var commdityPrice: UILabel!//商品价格
    @IBOutlet weak var commdityIntroduce: UILabel!//商品介绍
    var commdityID:AnyObject!//商品id
    
    @IBOutlet weak var aaa: UIImageView!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
