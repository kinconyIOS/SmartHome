//
//  RoomListItem.swift
//  SmartHome
//
//  Created by sunzl on 15/12/18.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class RoomListItem: NSObject {
    var isSubItem:Bool = false
    var isOpen:Bool = false
    var name:String = ""
    var items:[RoomListItem] = []
}
