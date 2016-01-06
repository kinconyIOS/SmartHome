//
//  DataDeal.swift
//  SmartHome
//
//  Created by kincony on 16/1/5.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation

var dataDeal: DataDeal {
    return DataDeal.sharedDataDeal
}

class DataDeal {
    static let sharedDataDeal = DataDeal()
    
    var floors = [Floor]()
    var rooms = [Room]()
    
    func getRoomByEquip(equip: Equip) -> Room? {
        for temp in rooms {
            if temp.roomID == equip.inRoom {
                return temp
            }
        }
        return nil
    }
    
    func getFloorByRoom(room: Room) -> Floor? {
        for temp in floors {
            if temp.floorID == room.inFloor {
                return temp
            }
        }
        return nil
    }
    
}
