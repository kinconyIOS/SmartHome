//
//  Floor.swift
//  SmartHome
//
//  Created by kincony on 16/1/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation
class Floor {
    let floorID: String
    var userCode: String = ""
    var name: String = ""
    init(floorID: String) {
        self.floorID = floorID
    }
    
    func saveFloor() {
        if dataDeal.searchModel(.Floor, byCode: self.floorID) != nil {
            dataDeal.updateModel(.Floor, model: self)
        } else {
            dataDeal.insertModel(.Floor, model: self)
        }
    }
    
    
    
}