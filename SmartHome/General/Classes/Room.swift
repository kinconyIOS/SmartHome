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
    var inFloor: String?
    var name: String?
    var equips: [Equip] = []
    init(roomID: String) {
        self.roomID = roomID
    }
}