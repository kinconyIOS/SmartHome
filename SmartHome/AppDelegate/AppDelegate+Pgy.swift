//
//  AppDelegate+Pgy.swift
//  SmartHome
//
//  Created by sunzl on 15/12/29.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
let PGY_APPKEY = "9a7415919d10979a44c655d3410f313a"

extension AppDelegate:UIAlertViewDelegate{
  
    func setUpPgy()
    {
       
        PgyUpdateManager.sharedPgyManager().startManagerWithAppId(PGY_APPKEY)
       
        PgyUpdateManager.sharedPgyManager().checkUpdateWithDelegete(self, selector: Selector("updateMethod:"))
            
        
    }
    /**
     *  检查更新回调
     *
     *  @param response 检查更新的返回结果
     */
    func updateMethod(response:NSDictionary)
    {
        
        if ((response["downloadURL"]) != nil) {
            self.updateUrl=response["downloadURL"] as! String
            //  NSString *message = response[@"releaseNote"]
         
            let alertView =  UIAlertView(title:NSLocalizedString("友情提示",comment:""), message:NSLocalizedString("发现新版本",comment:""), delegate:self, cancelButtonTitle:NSLocalizedString("取消",comment:""), otherButtonTitles:NSLocalizedString("现在安装",comment:""))
            
            
            alertView.show()
        }
        
       
      
    }
    func alertView(alertView:UIAlertView, buttonIndex:Int)
    {
        
        switch (buttonIndex) {
            
        case 1:
            UIApplication.sharedApplication().openURL(NSURL(string:self.updateUrl as String)!)
            //    调用checkUpdateWithDelegete后可用此方法来更新本地的版本号，如果有更新的话，在调用了此方法后再次调用将不提示更新信息。
            PgyUpdateManager.sharedPgyManager().updateLocalBuildNumber()
            break
        default:
            break
        }
        
    }
}
