//
//  HeadCell.swift
//  SmartHome
//
//  Created by sunzl on 16/4/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class HeadCell: UITableViewCell {
   
   var myScorllView: MyScorllView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
        //设置轮播图
               
    }
    func configHeadView(){
        if myScorllView == nil{
            myScorllView = MyScorllView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
            self.addSubview(myScorllView)
        }
    }
//
//            headView = NSBundle.mainBundle().loadNibNamed("HomeTopView", owner:self, options: nil)[0] as? HomeTopView
//            headView!.frame = CGRectMake(0, 0, self.frame.width,self.frame.height)
//      
//            //设置轮播图
//            headView?.images = [UIImage(named: "lb1")!,UIImage(named: "lb2")!]
//            headView?.setupPage()
//            //设置轮播图和摄像头
//            
//            //设置天气
//            if (app.weather == nil) {
//                weatherWithProvince("北京市", localCity:"北京市") { (weather:WeatherModel) -> () in
//                    app.weather = weather
//                    self.headView?.setWeatherModel(weather)
//                }
//            }else{
//                self.headView?.setWeatherModel(app.weather!)
//            }
//            self.addSubview(headView!)
//        
//        
//    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
