//
//  Helper.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import Foundation
import UIKit
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
