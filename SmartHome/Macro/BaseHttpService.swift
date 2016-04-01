//
//  BaseHttpService.swift
//  SmartHome
//
//  Created by sunzl on 16/3/28.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit
import Alamofire
class BaseHttpService: NSObject {
    typealias RequestSuccessBlock = (AnyObject) -> ()
    
    static func sendRequest(url:String,parameters dic:NSDictionary,success successBlock:RequestSuccessBlock){
        let app_secret = "12345"
        let sign = (dic.ping()+app_secret).md5
        print(dic.ping()+app_secret)
       
        let head_dict:[String:String]? = ["timestamp":timeStamp(),"nonce":randomNumAndLetter(),"sign":sign]
        Alamofire.request(.POST, url, parameters:dic as? [String : AnyObject], encoding:.URL , headers: head_dict).responseJSON(completionHandler: { (response) -> Void in
            
            if response.result.isFailure {
                
                print("网路问题-error:\(response.result.error)")
                
            } else {
              
               successBlock(response.result.value! )
             
            }
            
        })
        
    }
    static func sendRequestAccess(url:String,parameters dic:NSDictionary,success successBlock:RequestSuccessBlock){
        MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
       
        
        let app_secret = "12345"
       
        let token = accessToken()
        let stamp = timeStamp()
        let nonce = randomNumAndLetter()
        let sign = "access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)app_sercet".md5
        
        
        let head_dict:[String:String]? = ["timestamp":stamp,"nonce":nonce,"sign":sign]
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
             config.timeoutIntervalForRequest = 3    // 秒
          // 秒
        
           //self.alamofireManager = Manager(configuration: config)
        Alamofire.request(.POST, url, parameters:dic as? [String : AnyObject], encoding:.URL , headers: head_dict).responseJSON(completionHandler: { (response) -> Void in
             MBProgressHUD.hideAllHUDsForView(UIApplication.sharedApplication().keyWindow, animated: true)
           //  print(NSString(data:response.data!, encoding:NSUTF8StringEncoding))
            
            if response.result.isFailure {
                
                
                print("网路问题-error:\(response.result.error)")
                
            } else {
              if response.result.value!["success"] as! Bool == true{
               
                 successBlock(response.result.value!["data"]!!)
                
                 } else{//失效
                 print("重新获取!accessToken已经失效了")
               sendRequest(refreshToken_do, parameters: ["refreshToken":refreshAccessToken()!]) { (any:AnyObject) -> () in
                if any[""]as! Bool != true
                {
                  //得到新的accessToken 和 refreshToken 保存
                    //重新发送之前的请求
                    let token = accessToken()
                    let stamp = timeStamp()
                    let nonce = randomNumAndLetter()
                    let sign = "access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)app_sercet".md5
                    print(dic.ping()+app_secret)
                    
                    let head_dict:[String:String]? = ["timestamp":stamp,"nonce":nonce,"sign":sign]
                    Alamofire.request(.POST, url, parameters:dic as? [String : AnyObject], encoding:.URL , headers: head_dict).responseJSON(completionHandler: { (response) -> Void in
                        
                        if response.result.isFailure {
                            print("网路问题-error:\(response.result.error)")
                            
                        } else {
                            if response.result.value!["success"] as! Bool == true{
                                successBlock(response.result.value!["data"]!! )
                                
                            } else{
                                print("系统错误!刚刷新回来的token就已经失效了")
                            }

                            
                        }})
                
                }else
                {//彻底失效
                  print("重新登录吧!refreshToken已经失效了")
                }
                    
                }
               
                }
               
                
            }
            
        })
        
    }
    
    static func accessToken()->String?{
        return NSUserDefaults.standardUserDefaults().objectForKey("AccessToken") as? String
    }
    static func setAccessToken(accessToken:NSString){
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "AccessToken")
    }
    static func refreshAccessToken()->String?{
        return NSUserDefaults.standardUserDefaults().objectForKey("RefreshAccessToken") as? String
    }
    static func setRefreshAccessToken(refreshAccessToken:NSString){
        NSUserDefaults.standardUserDefaults().setObject(refreshAccessToken, forKey: "RefreshAccessToken")
    }
    
    
    static func clearToken(){
        setRefreshAccessToken("")
        setAccessToken("")
        
    }
    ////
    static func timeStamp()->String {
        
        let localDate = NSDate().timeIntervalSince1970  //获取当前时间
        let  recordTime = localDate*1000  //时间戳,*1000为取到毫秒
        let timesTamp = String(format: "%llu", recordTime)
        return timesTamp;
    }
    static func randomNumAndLetter()->String
    {
        let kNumber = 16;
        let sourceStr:NSString="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        var resultStr = ""
        srand(UInt32(time(nil)))
        
        for   _ in  0..<kNumber
        {
            let index = Int(rand())%sourceStr.length;
            let oneStr = sourceStr.substringWithRange(NSMakeRange(index, 1))
            resultStr += oneStr
        }
        return resultStr
    }
    
    
    
}
