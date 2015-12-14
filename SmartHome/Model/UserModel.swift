//
//  UserModel.swift
//  SmartHome
//
//  Created by sunzl on 15/12/14.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import Foundation
class UserModel: NSObject {
    var userCode:String=""
    var userPhone:String=""
    
    convenience init(dict:[String : AnyObject]) {
        self.init()
        self.setValuesForKeysWithDictionary(dict)
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String){
        
    }
}