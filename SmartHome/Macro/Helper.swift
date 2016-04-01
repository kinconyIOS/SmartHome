//
//  Helper.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
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
    var md5 : String{
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
        
        CC_MD5(str!, strLen, result);
        
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.destroy();
        
        return String(format: hash as String)
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
 
    //
       let url:String=String(UTF8String: "http://api.map.baidu.com/telematics/v3/weather")!
       // let manager = AFHTTPRequestOperationManager()
      let parameters=["location": str!,
                      "output": "json",
                      "ak":"o1NQuijYqFmtMqTQv4AK4XWv"]
    Alamofire.request(.GET, url, parameters: parameters).responseJSON { (response) -> Void in
        if(response.result.isSuccess){
        
            let responseObject = response.result.value
            
            let arr = responseObject!["results"]!![0]["weather_data"] as! NSArray
            
            print(arr)
            for index in 0..<3{
                
                let aDict = arr[index]  as! NSDictionary
                
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
                
                
                
                let weather=WeatherModel(address:str!,aMaxTemp: aMaxTemp!, aSmallTemp: aSmallTemp, aWeather: aWeather, aWind: aWind, dayPictureUrl: dayPictureUrl, nightPictureUrl: nightPictureUrl)
                complete(weather)
            }

        }else{
        
        
        
        }// if end
        
    }//net end
    
}//func end
func setDefault(phone:String,pwd:String){

    var userlist:[String:String]? = NSUserDefaults.standardUserDefaults().objectForKey("userList") as? [String:String]
    if userlist == nil {
         userlist = [:]
    }
     userlist![phone] = pwd
    NSUserDefaults.standardUserDefaults().setObject(userlist, forKey: "userList")
    print(userlist)
   
    
}

func getRemoveIndex<T: Equatable>(value: T, array: [T]) -> [Int]{
    var indexArray = [Int]()
    
    var correctArray = [Int]()
    
    //获取指定值在数组中的索引
    
    for (index,_) in array.enumerate() {
        
        if array[index] == value {
            
            indexArray.append(index)
            
        }
        
    }
    //计算正确的删除索引
    
    for (index, originIndex) in indexArray.enumerate(){
        
        //指定值索引减去索引数组的索引
        
        var correctIndex = originIndex - index
        
        
        
        //添加到正确的索引数组中
        
        correctArray.append(correctIndex)
        
    }
    
    return correctArray
    
}
func getIconByType(type:String)->String
{
    var icon :String = "未知"
    switch type{
    case "1":
        icon = "开关灯泡"
        break
    case "2":
        icon = "窗帘"
        break
    case "4":
        icon = "调光灯泡"
        break
    default:break
        
    }
    return icon


}

typealias CompleteUpdateRoomInfo = () -> ()
func updateRoomInfo(complete:CompleteUpdateRoomInfo){
    DataDeal.sharedDataDeal.clearAllTable()
    let parameters=["userCode":"U00318"];
    BaseHttpService .sendRequestAccess(getroom_do, parameters: parameters) { (anyObject) -> () in
        print(anyObject)
        let floorInfo = anyObject[0]["floorInfo"]
        for dic in (floorInfo as!NSArray)
        {
            let f = Floor(floorCode:dic["floorCode"] as! String)
            f.name = dic["floorName"] as! String
            f.saveFloor()
            
        }
        let roomInfo = anyObject[0]["roomInfo"]
        
        for dic in (roomInfo as!NSArray)
        {
            let r = Room(roomCode:dic["roomCode"] as! String)
            r.name = dic["roomName"] as! String
            r.floorCode =  dic["floorCode"] as! String
            r.saveRoom()
            
        }
        complete()
    }
    
}

typealias CompleteNOtoNet = () -> ()
func setNetRoomInfoVersionNumber(f:Float,andComplete complete:CompleteNOtoNet){
    
    let parameters=["userCode":"U00318","version": Float(floatLiteral: f+1)];
    //读取服务器版本号。
    BaseHttpService .sendRequestAccess(setversion_do, parameters: parameters) { (response) -> () in
        
        complete()
    }
    
    
}

