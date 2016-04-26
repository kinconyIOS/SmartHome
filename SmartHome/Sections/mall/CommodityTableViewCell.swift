//
//  CommodityTableViewCell.swift
//  SmartHome
//
//  Created by kincony on 16/3/31.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class CommodityTableViewCell: UITableViewCell {
    //声明一个闭包
    var myClosure:callbackfunc?
    //块
    typealias callbackfunc = (Int)->()
    
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
    func completeBlock(chName:callbackfunc)->Void{
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var commodityImg: UIImageView!//商品展示图片
    @IBOutlet weak var commdityFollow: UIButton!//商品关注
    @IBOutlet weak var commdityName: UILabel!//商品名字
    @IBOutlet weak var commdityPrice: UILabel!//商品价格
    @IBOutlet weak var commdityIntroduce: UILabel!//商品介绍
    var commdityID:Int!//商品id
    
    @IBOutlet weak var aaa: UIImageView!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.commdityFollow.addTarget(self, action: Selector("addshou:"), forControlEvents: UIControlEvents.TouchDown)
        // Configure the view for the selected state
    }
    
    //点击收藏
    func addshou(but:UIButton){
        self.myClosure!(commdityID)
    }
    
}
