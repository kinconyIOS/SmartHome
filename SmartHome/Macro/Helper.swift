//
//  Helper.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import Foundation
import UIKit
//根据颜色返回图片
func imageWithColor(color:UIColor)->UIImage
 {
    let rect:CGRect = CGRectMake(0.0, 0.0, 1.0, 1.0)
    UIGraphicsBeginImageContext(rect.size);
    let context:CGContextRef = UIGraphicsGetCurrentContext()!;
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    return image;

}
//试图控制器扩展点击收起键盘
extension UIViewController{
     func addTouchDownHideKey()
      {
        let tap:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: Selector("hideKey"))
          self.view.addGestureRecognizer(tap)
    
       }
    
     func hideKey(){
        self.view.endEditing(true)
      }


}
//颜色的便利构造器
extension UIColor {
    convenience init(RGB: Int, alpha: Float) {
        self.init(red: CGFloat((RGB & 0xFF0000) >> 16) / CGFloat(255), green: CGFloat((RGB & 0xFF00) >> 8) / CGFloat(255), blue: CGFloat(RGB & 0xFF) / CGFloat(255), alpha: CGFloat(alpha))
    }
    
}

func helper() {
    
}

