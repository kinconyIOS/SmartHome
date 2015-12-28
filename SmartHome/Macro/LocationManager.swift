//
//  LocationManager.swift
//  SmartHome
//
//  Created by sunzl on 15/12/28.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import CoreLocation
class LocationManager: NSObject,CLLocationManagerDelegate{
  var currentlocation:CLLocationManager?
    
 
    class func sharedManager()->LocationManager{
        struct YRSingleton{
            static var sharedAccountManagerInstance:LocationManager? = nil;
            static var predicate:dispatch_once_t = 0
        }
       dispatch_once(&YRSingleton.predicate,{
        YRSingleton.sharedAccountManagerInstance = LocationManager()
        })
      
        return YRSingleton.sharedAccountManagerInstance!;
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
                print(".....")
                //开启定位
                currentlocation = CLLocationManager()//创建位置管理器
                currentlocation!.delegate=self
                currentlocation!.desiredAccuracy=kCLLocationAccuracyBest
                currentlocation!.distanceFilter=100.0
                
                if ( Float(UIDevice.currentDevice().systemVersion) >= 8.0)
                {
                   currentlocation!.requestWhenInUseAuthorization()
                   currentlocation!.requestAlwaysAuthorization()
                    
                }                //启动位置更新
               currentlocation?.startUpdatingLocation()
            }
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation=locations.last
        let geoCoder:CLGeocoder  = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(newLocation!) { (placemarks:[CLPlacemark]?,error:NSError?) -> Void in
            if (error != nil)
            {
                for placemark:CLPlacemark in placemarks!{
                    
                    let test:NSDictionary = placemark.addressDictionary!
                    print(test)
                    print(test["Country"])
                    print(test["State"])
                    print(test["City"])
                    print(test["SubLocality"])
                    print(test["Street"])
   
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
