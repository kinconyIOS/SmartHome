//
//  Tools.swift
//  SmartHome
//
//  Created by sunzl on 15/12/10.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import Foundation
import UIKit

func showMsg(msg:String){
 UIAlertView(title: msg, message: nil, delegate: nil, cancelButtonTitle: "我知道了").show()

}

func validateMobile(mobile:String)->Bool
{
    let regex:NSRegularExpression!
   
    do{ // - 1、创建规则
        //手机号以1开头，十个 \d 数字字符
        let pattern:String = "^((13[0-9])|(15[0-9])|(18[0-9]))\\d{8}$"
        // - 2、创建正则表达式对象
        regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
         let matches = regex.matchesInString(mobile, options:NSMatchingOptions(rawValue: 0), range: NSMakeRange(0,mobile.characters.count))
          return matches.count > 0
    }
    catch {
        print(error)
    }
  
    return false
}

//手机号码验证

//{
//   
//        * = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
//}