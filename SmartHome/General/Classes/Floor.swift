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
    var name: String?
    var rooms = [Room]()
    init(floorID: String) {
        self.floorID = floorID
    }
}