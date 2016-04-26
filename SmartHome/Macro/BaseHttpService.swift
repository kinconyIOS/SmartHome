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
                if (response.result.value!as![String:AnyObject]).keys.contains("statusCode"){
                    print("服务器返回异常数据")
                    return;
                }
               successBlock(response.result.value! )
             
            }
            
        })
        
    }
    static func saveImageAccess(data:NSData,success successBlock:RequestSuccessBlock){
        let app_secret = "12345"
        
        let token = accessToken()
        let stamp = timeStamp()
        let nonce = randomNumAndLetter()
        let code = userCode()
        let sign = "access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)".md5
        
        print("access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)")
        let head_dict:[String:String]? = ["access_token":token,"timestamp":stamp,"nonce":nonce,"sign":sign,"userCode":code]
        
        
        Alamofire.upload(.POST,GetUserFileupload, headers: head_dict, multipartFormData: { (multipartFormData) -> Void in
            multipartFormData.appendBodyPart(data: data, name: "fileupload", fileName:randomNumAndLetter(), mimeType: "image/jpeg")     }, encodingMemoryThreshold: 10 * 1024 * 1024) { (result) -> Void in
                 //successBlock(result)
        }
        
        
        
    }

    static func sendRequestAccess(url:String,parameters dic:NSDictionary,success successBlock:RequestSuccessBlock){
        MBProgressHUD.showHUDAddedTo(app.window, animated: true)
       
        
        let app_secret = "12345"
       
        let token = accessToken()
        let stamp = timeStamp()
        let nonce = randomNumAndLetter()
        let code = userCode()
        let sign = "access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)".md5
        
        print("access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)&userCode=\(code)\(app_secret)")
        let head_dict:[String:String]? = ["access_token":token,"timestamp":stamp,"nonce":nonce,"sign":sign,"userCode":code]
     
        
        
      
      
           Alamofire.request(.POST, url, parameters:dic as? [String : AnyObject], encoding:.URL , headers: head_dict).responseJSON(completionHandler: { (response) -> Void in
             MBProgressHUD.hideAllHUDsForView(app.window, animated: true)
           //  print(NSString(data:response.data!, encoding:NSUTF8StringEncoding))
            
            if response.result.isFailure {
                
                
                print("网路问题-error:\(response.result.error)")
                
            } else {
                 print("\(url)-\(response.result.value)")

            
                if (response.result.value!as![String:AnyObject]).keys.contains("statusCode"){
                     print("服务器返回异常数据")
                    return;
                }
                if response.result.value!["success"] as! Bool == true{
               
                 successBlock(response.result.value!["data"]!!)
               
                 } else{
                    print(response.result.value!["message"]as!String)
                   if response.result.value!["message"]as!String != "超时了" {
                    
                    if response.result.value!["message"]as!String == "没有找到该编号"
                        
                    {
                        print("重新登录吧!没有找到该编号")
                        
                        let nav:UINavigationController = UINavigationController(rootViewController: LoginVC(nibName: "LoginVC", bundle: nil))
                        app.window!.rootViewController=nav
                        
                    }
                //不是超时的其他问题
                    return
                
                   }
                    
                //失效
                 print("accessToken已经失效了重新获取!")
               sendRequest(refreshToken_do, parameters: ["refreshToken":refreshAccessToken(),"userCode":userCode()]) { (any:AnyObject) -> () in
               
                if any["success"]as! Bool == true
                {
                    //得到新的accessToken 和 refreshToken 保存
                    setAccessToken(any["data"]!!["accessToken"] as!String)
                    setRefreshAccessToken(any["data"]!!["refreshToken"] as!String)
                    
                    //重新发送之前的请求
                    let token = accessToken()
                    let stamp = timeStamp()
                    let nonce = randomNumAndLetter()
                    let sign = "access_token=\(token)&nonce=\(nonce)&timestamp=\(stamp)app_sercet".md5
                    print(dic.ping()+app_secret)
                    
                    let head_dict:[String:String]? = ["timestamp":stamp,"nonce":nonce,"sign":sign]
                    
                    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                    config.timeoutIntervalForRequest = 5.0    // 秒
                    
                    let manager = Alamofire.Manager(configuration: config)
                    manager.request(.POST, url, parameters:dic as? [String : AnyObject], encoding:.URL , headers: head_dict).responseJSON(completionHandler: { (response) -> Void in
                        
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
                    
                    let nav:UINavigationController = UINavigationController(rootViewController: LoginVC(nibName: "LoginVC", bundle: nil))
                    app.window!.rootViewController=nav
                 
                }
                    
                }
               
                }
               
                
            }
            
        })
        
    }
    
    static func accessToken()->String{
        let acc = NSUserDefaults.standardUserDefaults().objectForKey("AccessToken") as? String
        if acc == nil{
        return ""}
        return acc!
    }
    static func setAccessToken(accessToken:NSString){
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "AccessToken")
    }
    static func refreshAccessToken()->String{
        let acc = NSUserDefaults.standardUserDefaults().objectForKey("RefreshAccessToken") as? String
        if acc == nil{
            return ""
        }
        return acc!
      
    }
    static func setRefreshAccessToken(refreshAccessToken:NSString){
        NSUserDefaults.standardUserDefaults().setObject(refreshAccessToken, forKey: "RefreshAccessToken")
    }
    static func userCode()->String{
        let acc = NSUserDefaults.standardUserDefaults().objectForKey("userCode") as? String
        if acc == nil{
            return ""
        }
        return acc!
      
    }
    static func setUserCode(userCode:NSString){
        NSUserDefaults.standardUserDefaults().setObject(userCode, forKey: "userCode")
    }
    
    
    static func clearToken(){
        setRefreshAccessToken("")
        setAccessToken("")
        setUserCode("")
  
    }
  
    static func timeStamp()->String {
        
        let localDate = NSDate().timeIntervalSince1970  //获取当前时间
        let  recordTime = UInt64(localDate)  //时间戳,*1000为取到毫秒
        
        
        let timesTamp = String(format: "%lld", recordTime)
        print(recordTime)
        return timesTamp
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
