//
//  HeadCell.swift
//  SmartHome
//
//  Created by sunzl on 16/4/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class HeadCell: UITableViewCell {
   
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var bgImg: UIImageView!
    @IBOutlet var iconImg: UIImageView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
   var myScorllView: MySxtScorllView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let   senddate = NSDate()
        
        let dateformatter = NSDateFormatter()
        
        dateformatter.dateFormat = "YYYY/MM/dd"
        
        let   locationString = dateformatter.stringFromDate(senddate)
        
        
        
        dataLabel.text = locationString
        //设置轮播图
               
    }
    func configHeadView(){
        if myScorllView == nil{
        
            myScorllView = MySxtScorllView(frame: CGRectMake(0,0,ScreenWidth,139 * ScreenHeight/568))
            
            self.addSubview(myScorllView)
        }
    }
    func removeHeadView(){
        if myScorllView != nil{
            myScorllView.doBack()
            myScorllView.removeFromSuperview()
            myScorllView = nil
          
        }
    
    }
    
    func setWeatherModel(model:WeatherModel){
        print("天气预报")
     
       
        addressLabel.text = model.address
       
        tempLabel.text = model.aSmallTemp+" ~ "+model.aMaxTemp+"°C"
       
        weatherLabel.text = model.aWeather
        
        let str = model.aWeather as NSString
        switch (str.substringFromIndex(str.length-1))
        {
        case "雨":
            bgImg.image = UIImage(named: "img_rainy")
            iconImg.image = UIImage(named: "icon_rainy")
            break
        case "晴":
            bgImg.image = UIImage(named: "img_fine")
            iconImg.image = UIImage(named: "icon_fine")
            break
        default:
            bgImg.image = UIImage(named: "img_cloudy")
            iconImg.image = UIImage(named: "icon_cloudy")
            break
          
            
        
        }
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
