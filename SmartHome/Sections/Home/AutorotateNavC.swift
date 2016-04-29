//
//  AutorotateNavC.swift
//  SmartHome
//
//  Created by sunzl on 16/1/14.
//  Copyright © 2016年 sunzl. All rights reserved.
//

//import Cocoa
import UIKit
class AutorotateNavC: UINavigationController {
    override func shouldAutorotate() -> Bool {
//      if   self.topViewController!.isKindOfClass(EZLivePlayViewController.classForCoder()){
//            return true
//        }
//      if   Wrapper().kindsOfHTPlayCamerViewController(self){
//             print("yes0")
//            return true
//       }
//          print("no0")
        return  (self.topViewController?.shouldAutorotate())!
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
         return (self.topViewController?.supportedInterfaceOrientations())!
//        if   Wrapper().kindsOfHTPlayCamerViewController(self){
//               print("yes0")
//            return UIInterfaceOrientationMask.LandscapeLeft
//        }
//        return UIInterfaceOrientationMask.Portrait
    }
  
}
