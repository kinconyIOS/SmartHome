//
//  Room.swift
//  SmartHome
//
//  Created by kincony on 16/1/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation
class Room {
    let roomID: String
    var userCode: String = ""
    var floorCode: String = ""
    var name: String = ""
    init(roomID: String) {
        self.roomID = roomID
    }
    
    func saveRoom() {
        if dataDeal.searchModel(.Room, byCode: self.roomID) != nil {
            dataDeal.updateModel(.Room, model: self)
        } else {
            dataDeal.insertModel(.Room, model: self)
        }
    }
}