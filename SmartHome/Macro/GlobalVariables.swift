//
//  GlobalVariables.swift
//  SmartHome
//
//  Created by kincony on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import Foundation
import UIKit
let buttonColor1:UIColor=UIColor.init(red: 65/255.0, green: 255/255.0, blue: 179/255.0, alpha: 1.0)
  let app = (UIApplication.sharedApplication().delegate) as! AppDelegate
public enum SetUserType:Int{
    case Reg
    case Reset
    case Modify
}
let ScreenWidth = UIScreen.mainScreen().bounds.size.width;
let ScreenHeight = UIScreen.mainScreen().bounds.size.height;
let BaseUrl:String = "http://192.168.1.120:8080/smarthome.IMCPlatform/public5001/"
let reg:String="registers.action"
let send:String="send.action"
let reset:String="forgotpwd.action"
let modifypwd:String="modifypwd.action"