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
           if   self.topViewController!.isKindOfClass(EZLivePlayViewController.classForCoder()){
            return true
        }
        return false
    }
  
}
