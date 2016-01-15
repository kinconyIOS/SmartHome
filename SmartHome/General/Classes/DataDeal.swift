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
    
    enum TableType {
        case User, Floor, Room, Equip
    }
    
    static let sharedDataDeal = DataDeal()

    let db = try? Connection(NSHomeDirectory() + "/Documents" + "/db.sqlite")
    
    var floors = [Floor]()
    var rooms = [Room]()
    
    func creatUserTable() {
        
    }
    
    func creatFloorTable() {
        let id = Expression<Int64>("id")
        let floorCode = Expression<String>("code")
        let floorName = Expression<String>("name")
        let userCode = Expression<String>("userCode")
        let floor = Table("Floors")
        
        do {
            try db?.run(floor.create(ifNotExists: true) { (t) -> Void in
                t.column(id, primaryKey: .Autoincrement)
                t.column(floorCode, unique: true)
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
                t.column(roomCode, unique: true)
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
        let equipIcon = Expression<String>("icon")
        let roomCode = Expression<String>("roomCode")
        let userCode = Expression<String>("userCode")
        let equip = Table("Equips")
        do {
            try db?.run(equip.create(ifNotExists: true) { (t) -> Void in
                t.column(id, primaryKey: .Autoincrement)
                t.column(equipCode, unique: true)
                t.column(equipName)
                t.column(equipIcon)
                t.column(roomCode)
                t.column(userCode)
                })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    func searchModel(type: TableType, byCode code: String) ->AnyObject? {
        switch type {
        case .User:
            break
        case .Floor:
            let floor = Table("Floors")
            let floorCode = Expression<String>("code")
            let floorName = Expression<String>("name")
            let userCode = Expression<String>("userCode")
            for f in try! db!.prepare(floor.filter(floorCode == code)) {
                let newFloor = Floor(floorID: f[floorCode])
                newFloor.name = f[floorName]
                newFloor.userCode = f[userCode]
                return newFloor
            }

        case .Room:
            let roomCode = Expression<String>("code")
            let roomName = Expression<String>("name")
            let floorCode = Expression<String>("floorCode")
            let userCode = Expression<String>("userCode")
            let room = Table("Rooms")
            for r in try! db!.prepare(room.filter(roomCode == code)) {
                let newRoom = Room(roomID: r[roomCode])
                newRoom.name = r[roomName]
                newRoom.userCode = r[userCode]
                newRoom.floorCode = r[floorCode]
                return newRoom
            }
            
        case .Equip:
            let equipCode = Expression<String>("code")
            let equipName = Expression<String>("name")
            let equipIcon = Expression<String>("icon")
            let roomCode = Expression<String>("roomCode")
            let userCode = Expression<String>("userCode")
            let equip = Table("Equips")
            for e in try! db!.prepare(equip.filter(equipCode == code)) {
                let newEquip = Equip(equipID: e[equipCode])
                newEquip.name = e[equipName]
                newEquip.icon = e[equipIcon]
                newEquip.userCode = e[userCode]
                newEquip.roomCode = e[roomCode]
                return newEquip
            }
        }
        return nil
    }
    
    func getModels(type: TableType) -> (Array<AnyObject>) {
        var arr = [AnyObject]()
        switch type {
        case .User:
            break
        case .Floor:
            let floor = Table("Floors")
            let floorCode = Expression<String>("code")
            let floorName = Expression<String>("name")
            let userCode = Expression<String>("userCode")
            for f in try! db!.prepare(floor) {
                let newFloor = Floor(floorID: f[floorCode])
                newFloor.name = f[floorName]
                newFloor.userCode = f[userCode]
                arr.append(newFloor)
            }
            
        case .Room:
            let roomCode = Expression<String>("code")
            let roomName = Expression<String>("name")
            let floorCode = Expression<String>("floorCode")
            let userCode = Expression<String>("userCode")
            let room = Table("Rooms")
            for r in try! db!.prepare(room) {
                let newRoom = Room(roomID: r[roomCode])
                newRoom.name = r[roomName]
                newRoom.userCode = r[userCode]
                newRoom.floorCode = r[floorCode]
                arr.append(newRoom)
            }
            
        case .Equip:
            let equipCode = Expression<String>("code")
            let equipName = Expression<String>("name")
            let equipIcon = Expression<String>("icon")
            let roomCode = Expression<String>("roomCode")
            let userCode = Expression<String>("userCode")
            let equip = Table("Equips")
            for e in try! db!.prepare(equip) {
                let newEquip = Equip(equipID: e[equipCode])
                newEquip.name = e[equipName]
                newEquip.icon = e[equipIcon]
                newEquip.userCode = e[userCode]
                newEquip.roomCode = e[roomCode]
                arr.append(newEquip)
            }
        }
        return arr
        
    }
    
    func insertModel(type: TableType, model: AnyObject) {
        switch type {
        case .User:
            
            break
        case .Floor where model is Floor:
            let f = model as! Floor
            let floor = Table("Floors")
            let floorCode = Expression<String>("code")
            let floorName = Expression<String>("name")
            let userCode = Expression<String>("userCode")
            do {
                try db?.run(floor.insert(or: .Replace, floorCode <- f.floorID, floorName <- f.name, userCode <- f.userCode))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        case .Room where model is Room:
            let r = model as! Room
            let roomCode = Expression<String>("code")
            let roomName = Expression<String>("name")
            let floorCode = Expression<String>("floorCode")
            let userCode = Expression<String>("userCode")
            let room = Table("Rooms")
            do {
                try db?.run(room.insert(or: .Replace, roomCode <- r.roomID, roomName <- r.name, userCode <- r.userCode, floorCode <- r.floorCode))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        case .Equip where model is Equip:
            let e = model as! Equip
            let equipCode = Expression<String>("code")
            let equipName = Expression<String>("name")
            let equipIcon = Expression<String>("icon")
            let roomCode = Expression<String>("roomCode")
            let userCode = Expression<String>("userCode")
            let equip = Table("Equips")
            do {
                try db?.run(equip.insert(or: .Replace, equipCode <- e.equipID, equipName <- e.name, userCode <- e.userCode, roomCode <- e.roomCode, equipIcon <- e.icon))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        default:
            break
        }
    }
    
    func updateModel(type: TableType, model: AnyObject) {
        switch type {
        case .User:
            
            break
        case .Floor where model is Floor:
            let f = model as! Floor
            let floor = Table("Floors")
            let floorCode = Expression<String>("code")
            let floorName = Expression<String>("name")
            let userCode = Expression<String>("userCode")
            do {
                try db?.run(floor.filter(floorCode == f.floorID).update(floorName <- f.name,userCode <- f.userCode))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        case .Room where model is Room:
            let r = model as! Room
            let roomCode = Expression<String>("code")
            let roomName = Expression<String>("name")
            let floorCode = Expression<String>("floorCode")
            let userCode = Expression<String>("userCode")
            let room = Table("Rooms")
            do {
                try db?.run(room.filter(roomCode == r.roomID).update(roomName <- r.name, userCode <- r.userCode, floorCode <- r.floorCode))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        case .Equip where model is Equip:
            let e = model as! Equip
            let equipCode = Expression<String>("code")
            let equipName = Expression<String>("name")
            let equipIcon = Expression<String>("icon")
            let roomCode = Expression<String>("roomCode")
            let userCode = Expression<String>("userCode")
            let equip = Table("Equips")
            do {
                try db?.run(equip.filter(equipCode == e.equipID).update(equipName <- e.name, userCode <- e.userCode, roomCode <- e.roomCode, equipIcon <- e.icon))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        default:
            break
        }
    }
    
    func getClassifyAndUnClassifyEquips() -> ((Array<Equip>, Array<Equip>)) {
        let arr = getModels(.Equip) as! [Equip]
        var classifyArr = [Equip]()
        var unClassifyArr = [Equip]()
        for equip in arr {
            if (equip.roomCode != "") {
                classifyArr.append(equip)
            } else {
                unClassifyArr.append(equip)
            }
        }
        return (classifyArr, unClassifyArr)
    }
    
    
    func getRoomsByFloor(floor: Floor) -> [Room] {
        var arr = [Room]()
        let roomCode = Expression<String>("code")
        let roomName = Expression<String>("name")
        let floorCode = Expression<String>("floorCode")
        let userCode = Expression<String>("userCode")
        let room = Table("Rooms")
        for r in try! db!.prepare(room.filter(floorCode == floor.floorID)) {
            let newRoom = Room(roomID: r[roomCode])
            newRoom.name = r[roomName]
            newRoom.floorCode = r[floorCode]
            newRoom.userCode = r[userCode]
            arr.append(newRoom)
        }
        return arr
    }
    
    func getEquipsByRoom(room: Room) -> [Equip] {
        var arr = [Equip]()
        let equipCode = Expression<String>("code")
        let equipName = Expression<String>("name")
        let equipIcon = Expression<String>("icon")
        let roomCode = Expression<String>("roomCode")
        let userCode = Expression<String>("userCode")
        let equip = Table("Equips")
        for e in try! db!.prepare(equip.filter(roomCode == room.roomID)) {
            let newEquip = Equip(equipID: e[equipCode])
            newEquip.name = e[equipName]
            newEquip.icon = e[equipIcon]
            newEquip.roomCode = e[roomCode]
            newEquip.userCode = e[userCode]
            arr.append(newEquip)
        }
        return arr
    }
    
    func toJSONString(jsonSource: AnyObject) -> String {
        var data = NSData()
        do {
            try data = NSJSONSerialization.dataWithJSONObject(jsonSource, options: NSJSONWritingOptions.PrettyPrinted)
        } catch let error as NSError {
            print(error)
        }
        let strJson = String(data: data, encoding: NSUTF8StringEncoding)
        return strJson!
    }
}
