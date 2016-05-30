//
//  AppDelegate+Error.swift
//  SmartHome
//
//  Created by sunzl on 15/12/28.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

extension AppDelegate{
   
    func setUpErrorTest()
    {
        
        //错误处理
        
        let err:String? = NSUserDefaults.standardUserDefaults().objectForKey("error.log") as? String
            
        print(err)
        if (err != nil && err != "")
             {
                
                //1.管理器
                
               
                
                //   获得设备列表
                
                let dict = ["appName":"SmartHome","content":err!]
                
                
                let url1 = "http://120.27.137.65:80/smarthome.IMCPlatform/xingErrorr/report.action"
                print(url1)
              
                
                
                
        }
  
        NSSetUncaughtExceptionHandler { (exception:NSException) in
            //异常的堆栈信息
            let stackArray:NSArray = exception.callStackSymbols
            
            //出现异常的原因
            let reason:NSString=exception.reason!
            
            //异常名称
            let name:NSString=exception.name
            
            let exceptionInfo:NSString=NSString(format:"Exceptionreason：%@nExceptionname：%@nExceptionstack：%",name,reason,stackArray)
            print(exceptionInfo)
            NSUserDefaults.standardUserDefaults().setObject(exceptionInfo, forKey:"error.log")
        }
      
        
        
    }

}
