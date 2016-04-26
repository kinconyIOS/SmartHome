//
//  HeadCell.swift
//  SmartHome
//
//  Created by sunzl on 16/4/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class HeadCell: UITableViewCell {
   
   var myScorllView: MySxtScorllView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
        //设置轮播图
               
    }
    func configHeadView(){
        if myScorllView == nil{
            myScorllView = MySxtScorllView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
            self.addSubview(myScorllView)
        }else{
            
        }
    }
    func setWeatherModel(model:WeatherModel){
       // self.currentAddressLabel.text="当前位置:"+(model.address)
        //self.weatherName.text=(model.aWeather)
       // self.wind.text=(model.aWind)
     
        //self.minTemp.text="最低"+(model.aSmallTemp)+"°C"
       
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
