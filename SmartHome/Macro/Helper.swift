//
//  Helper.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import Foundation
import UIKit
//根据颜色返回图片
func imageWithColor(color:UIColor)->UIImage
 {
    let rect:CGRect = CGRectMake(0.0, 0.0, 1.0, 1.0)
    UIGraphicsBeginImageContext(rect.size);
    let context:CGContextRef = UIGraphicsGetCurrentContext()!;
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    return image;

}
//试图控制器扩展点击收起键盘
extension UIViewController{
     func addTouchDownHideKey()
      {
        let tap:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: Selector("hideKey"))
          self.view.addGestureRecognizer(tap)
    
       }
    
     func hideKey(){
        self.view.endEditing(true)
      }


}
//颜色的便利构造器
extension UIColor {
    convenience init(RGB: Int, alpha: Float) {
        self.init(red: CGFloat((RGB & 0xFF0000) >> 16) / CGFloat(255), green: CGFloat((RGB & 0xFF00) >> 8) / CGFloat(255), blue: CGFloat(RGB & 0xFF) / CGFloat(255), alpha: CGFloat(alpha))
    }
}
extension String{

    func trimString()->String!
    {
        let str:String!=self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        return str;
    }

}

    /**
    *  根据位置的具体参数获取天气情况
    *
    *  @param province NSString 省份
    *  @param city     NSString 城市
    *  @param area     NSString 区域
    */
typealias Complete = (WeatherModel) -> ()
func weatherWithProvince( administrativeArea:String,localCity:String,complete:Complete){
        var str:String?=localCity
        if str!.characters.count==0 || !str!.containsString("市")
        {
        str=administrativeArea
            if str!.characters.count==0 || !str!.containsString("市")
            {
                str="北京"
                
            }

        }

    //[weaView initAddressName:aStr];
        let url:String=String(UTF8String: "http://api.map.baidu.com/telematics/v3/weather")!
        let manager = AFHTTPRequestOperationManager()
      let parameters=["location": str!,
                      "output": "json",
                      "ak":"o1NQuijYqFmtMqTQv4AK4XWv"]
        print(url)
     
        manager.GET(url,
            parameters:parameters,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                print("JSON: " + responseObject.description!)
              
                let arr = responseObject["results"]!![0]["weather_data"]
                
                for index in 0..<3{
                    let aDict:NSDictionary = arr!![index]!as!NSDictionary
            
                    let dayPictureUrl:String = aDict["dayPictureUrl"]! as! String
                    
                    let nightPictureUrl:String = aDict["nightPictureUrl"]! as! String
                    //
                    let  arrayTemp:Array=aDict["temperature"]!.componentsSeparatedByString("~")
                    let aMaxTemp = arrayTemp.first?.trimString()
                    //
                    let range:Range = (arrayTemp.last?.rangeOfString("℃"))!
                    let aSmallTemp = (arrayTemp.last?.substringToIndex(range.startIndex))!.trimString()
                    let aWeather:String = aDict["weather"] as! String
                    let aWind:String = aDict["wind"] as! String
                    
               
                
                    let weather=WeatherModel(aMaxTemp: aMaxTemp!, aSmallTemp: aSmallTemp, aWeather: aWeather, aWind: aWind, dayPictureUrl: dayPictureUrl, nightPictureUrl: nightPictureUrl)
                    complete(weather)
               

                }
               
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                print("Error: " + error.localizedDescription)
        })

    /*
       
        */
   
    //        WeatherObject *aWeObj = [[WeatherObject alloc] initSmallTemp:aSmallTemp maxTemp:aMaxTemp weather:aWeather windSpeed:aWind name:aName imageName:aImageName andId:i + 1];
    //        WeatherObject *aWeObj = [[WeatherObject alloc] initSmallTemp:aSmallTemp maxTemp:aMaxTemp weather:aWeather windSpeed:aWind name:[self weekDayWithIndex:i] imageName:aImageName andId:i + 1];
    //        if (i == 0) {
    //            w1 = aWeObj;
    //        }
    //        else if (i == 1) {
    //            w2 = aWeObj;
    //        }
    //        else {
    //            w3 = aWeObj;
    //        }
    //        if (![S_WeatherSqlite updateWeatherObject:aWeObj]) {
    //            NSLog(@"跟新失败");
    //        }
    //    }
    //    [weaView initInfo:[[NSDictionary alloc] initWithObjectsAndKeys:w1,@"1",w2,@"2",w3,@"3", nil]];
}
    

    


