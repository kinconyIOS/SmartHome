//
//  Waiting.swift
//  SmartHome
//
//  Created by sunzl on 15/12/15.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import Foundation
import UIKit

class Waiting :UIView {
  
    let webView:UIWebView?=UIWebView(frame: CGRectMake(100,100,200,200))
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        let gifData:NSData = NSData.dataWithContentsOfMappedFile(NSBundle.mainBundle().pathForResource("wait", ofType: "gif")!) as! NSData;
        webView?.backgroundColor=UIColor.clearColor()
        
        webView!.userInteractionEnabled = false;//用户不可交互
        webView!.loadData(gifData, MIMEType: "image/gif", textEncodingName:String(), baseURL:NSURL())
        self.addSubview(webView!)
    }
     convenience init() {
        self.init(frame:CGRectMake(0,0,ScreenWidth,ScreenHeight))
     }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

    
  
}