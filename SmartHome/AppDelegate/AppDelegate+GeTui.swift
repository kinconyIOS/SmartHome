//
//  AppDelegate+GeTui.swift
//  SmartHome
//
//  Created by sunzl on 15/12/29.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
let kAppId = "egB7MW2o0L9It60nlxt098"

let kAppKey = "iIgM1MTmnY8F1YDF8f9x38"

let kAppSecret = "PNHABVGCRH8CGzGQ4kD9W8"
extension AppDelegate:GexinSdkDelegate{
    //个推
   enum SdkStatus:Int{
        case Stoped
        case Starting
        case Started
    }
 
    
  
    
    func startGeTuiSdk()
    {
        
        self.startSdkWith(kAppId, appKey:kAppKey, appSecret:kAppSecret)
        
    }
    //个推began
    func startSdkWith(appID:NSString, appKey:NSString, appSecret:NSString)
    {
        
       
        if (self.gexinPusher == nil) {
            self.sdkStatus = SdkStatus.Stoped
            self.clientId = ""
       
            do {
                try self.gexinPusher = GexinSdk.createSdkWithAppId(appID as String,   appKey:appKey as String,   appSecret:appSecret as String,   appVersion:"0.0.0",   delegate:self)
                 print("start sdk")
            } catch {
                // deal with error
            }
            
           
            if (self.gexinPusher != nil) {
             //   print(err!.localizedDescription)
            } else {
               self.sdkStatus = SdkStatus.Starting
            }
            
            
        }
    }
    
    func stopGeTuiSdk()
    {
        
        if ((self.gexinPusher) != nil) {
            self.gexinPusher!.destroy()
            
            self.gexinPusher = nil
            self.sdkStatus = SdkStatus.Stoped
            self.clientId = ""
            
        }
    }
    //appdeleagte
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let token =  deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString:"<>"))
        
        self.deviceToken = token.stringByReplacingOccurrencesOfString(" ", withString:"")
        
        
        print("deviceToken"+(self.deviceToken as String))
       
        
        
        // [3]:向个推服务器注册deviceToken
        if (self.gexinPusher != nil) {
            self.gexinPusher!.registerDeviceToken(self.deviceToken as String)
            
        }
    }
  
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        // [3-EXT]:如果APNS注册失败，通知个推服务器
        if ((self.gexinPusher) != nil) {
            self.gexinPusher!.registerDeviceToken("")
            
        }
        
        print("注册远程通知错误")
       

    }

    //ios程序如果不在启动界面，则调用下面的方法；
 
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        let MSG =  userInfo["aps"]!["alert"]
        
        print(MSG)
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    //ios程序如果在启动界面，则调用下面的方法；
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // [4-EXT]:处理APN
        if (UIApplication.sharedApplication()
            
            
            .applicationState == UIApplicationState.Active ) {
                
                print(userInfo)
                //NSString *msg =userInfo[@"aps"][@"alert"][@"body"]
                
        }
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
  
    
    
    
    
   // #pragma mark - GexinSdkDelegate
    
    // 个推走的是这个方法；
    func GexinSdkDidReceivePayload(payloadId:NSString, appId:NSString)
    {
        
        
        // [4]: 收到个推消息
        self.payloadId = payloadId
        
        let payload =  self.gexinPusher!.retrivePayloadById(self.payloadId as! String)
        
        
        var payloadMsg = ""
        if (payload != nil) {
            payloadMsg = NSString(bytes: payload.bytes, length: payload.length, encoding: NSUTF8StringEncoding) as! String
        }
        
    //    var record =  NSString(format:"%d, %@, %", ++self.lastPayloadIndex, NSDate.date), payloadMsg()
        
        if (UIApplication.sharedApplication()
            
            
            .applicationState == UIApplicationState.Active ) {
                //payloadMsg
                
        }
        
        
        
        print(payloadMsg)
        
    }
    //个推end
   
}
