//
//  OneOfModel.swift
//  SmartHome
//
//  Created by sunzl on 16/5/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation

class OneOfModel: NSObject {
    let equipID: String //
    var ctrModelId:String = ""
    var userCode: String = ""
    var roomCode: String = ""
    var name: String = ""
    var type: String = ""//99
    var icon: String = ""
    var num:String = ""//
    var status:String = ""
    init(equipID: String) {
        self.equipID = equipID
    }
  

}
