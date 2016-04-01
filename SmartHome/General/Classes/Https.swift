//
//  Https.swift
//  SmartHome
//
//  Created by kincony on 16/1/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation

let baseUrl = "http://192.168.1.178/smarthome.IMCPlatform/xingUser/"
//添加楼层
let addFloor_do = "\(baseUrl)addfloor.action"
//添加房间
let addRoom_do = "\(baseUrl)addroom.action"
//添加房间
let addEq_do = "\(baseUrl)setDeviceInfo.action"

//查询未分类设备
let unclassifyEquip_do = "\(baseUrl)unclassifyqueryequipment.action"
let classifyEquip_do = "\(baseUrl)classifyqueryequipment.action"
//发送验证码 
let sendCode_do = "\(baseUrl)send.action"
let refreshToken_do = "\(baseUrl)refreshToken.action"
//扫描设备
let shaom_do="\(baseUrl)shaom.action"

let getversion_do="\(baseUrl)getversion.action"

let setversion_do="\(baseUrl)setversion.action"

let getroom_do="\(baseUrl)getroom.action"

let updatinfo="\(baseUrl)updatinfo.action"