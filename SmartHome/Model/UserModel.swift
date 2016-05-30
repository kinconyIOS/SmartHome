//
//  UserModel.swift
//  SmartHome
//
//  Created by sunzl on 15/12/14.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import Foundation



class UserModel: NSObject {
    var userName:String? = ""//姓名
    var userSex: String? = "" //男女
    var headPic:String? = ""//图片
    var signature:String? = ""//签名
    var city:String? = ""//城市
    
 
    convenience init(dict:[String : AnyObject]) {
        self.init()
        self.setValuesForKeysWithDictionary(dict)
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String){
        
    }
}