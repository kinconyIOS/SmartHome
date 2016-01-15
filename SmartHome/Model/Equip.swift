//
//  Equip.swift
//  SmartHome
//
//  Created by kincony on 16/1/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation

class Equip {
    let equipID: String
    var userCode: String = ""
    var roomCode: String = ""
    var name: String = ""
    var icon: String = ""
    init(equipID: String) {
        self.equipID = equipID
    }
    func saveEquip() {
        if dataDeal.searchModel(.Equip, byCode: self.equipID) != nil {
            dataDeal.updateModel(.Equip, model: self)
        } else {
            dataDeal.insertModel(.Equip, model: self)
        }
        
    }
}