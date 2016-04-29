//
//  LocationManager.swift
//  SmartHome
//
//  Created by sunzl on 15/12/28.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import CoreLocation
typealias CallbackCityName=(String!)->()
class MyLocationManager:NSObject,
CLLocationManagerDelegate{
   var currentlocation:CLLocationManager?
    var callback:CallbackCityName?
 
    class func sharedManager()->MyLocationManager{
        struct YRSingleton{
            static var sharedAccountManagerInstance:MyLocationManager? = nil;
            static var predicate:dispatch_once_t = 0
        }
       dispatch_once(&YRSingleton.predicate,{
        YRSingleton.sharedAccountManagerInstance = MyLocationManager()
        })
      
        return YRSingleton.sharedAccountManagerInstance!
    }
    func configLocation()
    {
       
        if (currentlocation == nil)
        {
            
            if (!CLLocationManager.locationServicesEnabled() || (CLLocationManager.authorizationStatus()==CLAuthorizationStatus.Denied))
            {
                showMsg("您关闭了的定位功能，将无法收到位置信息，建议您到系统设置打开定位功能!")
             
            }
            else
            {
                
                //开启定位
                currentlocation = CLLocationManager()//创建位置管理器
                currentlocation!.delegate=self
                currentlocation!.desiredAccuracy=kCLLocationAccuracyBest
                currentlocation!.distanceFilter=1000.0
                

                    if  currentlocation!.respondsToSelector("requestWhenInUseAuthorization") { print("--------6")
                  currentlocation!.requestWhenInUseAuthorization()
                    }
                   
                
                       //启动位置更新
               currentlocation?.startUpdatingLocation()
            }
          
        }
       
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation=locations.last
        let geoCoder:CLGeocoder  = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(newLocation!) { (placemarks:[CLPlacemark]?,error:NSError?) -> Void in
            if (error == nil)
            {
              
                for placemark:CLPlacemark in placemarks!{
                    
                    let test:NSDictionary = placemark.addressDictionary!
                    
             
                    self.callback!(test["City"] as! String)
   
                }
            }
            self.currentlocation!.stopUpdatingLocation()
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        manager.stopUpdatingLocation()
        switch(error.classForCoder) {
        case CLError.Denied:
             showMsg("您关闭了的定位功能，将无法收到位置信息，建议您到系统设置打开定位功能!")
            break;
        case CLError.LocationUnknown:
            
            break;
        default:
            break;
        }
    }
    
    
    
}
