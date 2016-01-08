//
//  DataDeal.swift
//  SmartHome
//
//  Created by kincony on 16/1/5.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation
import SQLite

var dataDeal: DataDeal {
    return DataDeal.sharedDataDeal
}

class DataDeal {
    static let sharedDataDeal = DataDeal()

    let db = try? Connection(NSHomeDirectory() + "/Documents" + "/db.sqlite")
    
    
    var floors = [Floor]()
    var rooms = [Room]()
    
    func creatFloorTable() {
        let id = Expression<Int64>("id")
        let floorCode = Expression<String>("code")
        let floorName = Expression<String>("name")
        let userCode = Expression<String>("userCode")
        let floor = Table("Floors")
        
        do {
            try db?.run(floor.create(ifNotExists: true) { (t) -> Void in
                t.column(id, primaryKey: .Autoincrement)
                t.column(floorCode)
                t.column(floorName)
                t.column(userCode)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    func creatRoomTable() {
        let id = Expression<Int64>("id")
        let roomCode = Expression<String>("code")
        let roomName = Expression<String>("name")
        let floorCode = Expression<String>("floorCode")
        let userCode = Expression<String>("userCode")
        let room = Table("Rooms")
        
        do {
            try db?.run(room.create(ifNotExists: true) { (t) -> Void in
                t.column(id, primaryKey: .Autoincrement)
                t.column(roomCode)
                t.column(roomName)
                t.column(floorCode)
                t.column(userCode)
                })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func creatEquipTable() {
        let id = Expression<Int64>("id")
        let equipCode = Expression<String>("code")
        let equipName = Expression<String>("name")
        let roomCode = Expression<String>("roomCode")
        let userCode = Expression<String>("userCode")
        let equip = Table("Equips")
        do {
            try db?.run(equip.create(ifNotExists: true) { (t) -> Void in
                t.column(id, primaryKey: .Autoincrement)
                t.column(equipCode)
                t.column(equipName)
                t.column(roomCode)
                t.column(userCode)
                })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
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
