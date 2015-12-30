//
//  AppDelegate+Reach.swift
//  SmartHome
//
//  Created by sunzl on 15/12/29.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
let AFAppDotNetAPIBaseURLString:String = "https://www.baidu.com/"
typealias NoReach = ()->()
extension AppDelegate{
    func setUpReach(noreach:NoReach)
    {
        let sessionManager =  AFHTTPSessionManager(baseURL:NSURL(string: AFAppDotNetAPIBaseURLString))
        
            sessionManager.securityPolicy = AFSecurityPolicy(pinningMode:AFSSLPinningMode.None)
            
        sessionManager.reachabilityManager.setReachabilityStatusChangeBlock { (status:AFNetworkReachabilityStatus ) -> Void in
            switch (status) {
            case AFNetworkReachabilityStatus.ReachableViaWWAN:                    print("---AFNetworkReachabilityStatusReachableViaWWAN--");                   break
            case AFNetworkReachabilityStatus.ReachableViaWiFi:                    print("---AFNetworkReachabilityStatusReachableViaWiFi--");                    break
            case AFNetworkReachabilityStatus.NotReachable:                    noreach()
                break
            default:
                break
            }

        }
        
        
    }
}
