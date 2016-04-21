//
//  CommodityImgTableViewCell.swift
//  SmartHome
//
//  Created by kincony on 16/4/1.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class CommodityImgTableViewCell: UITableViewCell {
var myScorllView: MyScorllView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configHeadView(){
        if myScorllView == nil{
            myScorllView = MyScorllView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.size.height-55))
            self.addSubview(myScorllView)
        }
    }
  
    @IBOutlet weak var butt: UIButton!
    @IBOutlet weak var leb: UILabel!
   

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
