//
//  Room.swift
//  SmartHome
//
//  Created by kincony on 16/1/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation
class Room {
    let roomCode: String
    var userCode: String = ""
    var floorCode: String = ""
    var name: String = ""
    init(roomCode: String) {
        self.roomCode = roomCode
    }
    
    func saveRoom() {
        if dataDeal.searchModel(.Room, byCode: self.roomCode) != nil {
            dataDeal.updateModel(.Room, model: self)
        } else {
            dataDeal.insertModel(.Room, model: self)
        }
    }
    func delete() {
        if dataDeal.searchModel(.Room, byCode: self.roomCode) != nil {
            dataDeal.deleteModel(.Room, model: self)
        } 
    }
}