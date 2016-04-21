//
//  Equip.swift
//  SmartHome
//
//  Created by kincony on 16/1/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation
func ==(lhs: Equip, rhs: Equip) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
class Equip : Hashable{
    let equipID: String
    var userCode: String = ""
    var roomCode: String = ""
    var name: String = ""
    var type: String = ""
    var icon: String = ""
    var num:String = ""
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
    func delete(){
        if dataDeal.searchModel(.Equip, byCode: self.equipID) != nil {
            dataDeal.deleteModel(.Equip, model: self)
        }
        
    }
    var hashValue: Int {
       
        return "\(equipID),\(userCode),\(roomCode),\(icon),\(type),\(num),\(name)".hashValue
    }
}