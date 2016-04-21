//
//  Https.swift
//  SmartHome
//
//  Created by kincony on 16/1/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation

let baseUrl = "http://lifusheng.wicp.net:21916/smarthome.IMCPlatform/xingUser/"
//tupian
let imgUrl = "http://lifusheng.wicp.net:21916/smarthome.IMCPlatform/"
////添加楼层
//let addFloor_do = "\(baseUrl)addfloor.action"
////添加房间
//let addRoom_do = "\(baseUrl)addroom.action"
//添加房间
let addEq_do = "\(baseUrl)setDeviceInfo.action"

//查询未分类设备
let unclassifyEquip_do = "\(baseUrl)unclassifyqueryequipment.action"
let classifyEquip_do = "\(baseUrl)classifyqueryequipment.action"
//发送验证码 
let sendCode_do = "\(baseUrl)send.action"
let refreshToken_do = "\(baseUrl)refresh_accessToken.action"
//扫描设备
let shaom_do="\(baseUrl)verify_with_sweep_host.action"

let getversion_do="\(baseUrl)getversion.action"

let setversion_do="\(baseUrl)setversion.action"

let getroom_do="\(baseUrl)getroom.action"

let deleteroom_do="\(baseUrl)deleteroom.action"
let deletefloor_do="\(baseUrl)deletefloor.action"

let updatinfo="\(baseUrl)updatinfo.action"

let commad_do="\(baseUrl)commad.action"

let getallhost_do = "\(baseUrl)getallhost.action"

let login_do = "\(baseUrl)login.action"
let deletedevice_do = "\(baseUrl)deletedevice.action"
//------------------------------------------
//商品
//商品展示
let Commodity_display="\(baseUrl)gaingoodslist.action"
//商品详情
let Commdity_di="\(baseUrl)gaingoodsdetailedInfo.action"
//意见反馈
let Yijian_do="\(baseUrl)feedback.action"

//获取用户信息
let GetUser="\(baseUrl)getuser.action"
//修改用户姓名
let GetUserName="\(baseUrl)setusername.action"
//修改性别
let GetUserSex="\(baseUrl)setusersex.action"
//修改签名
let GetUserSignature="\(baseUrl)setsignature.action"
//修改城市
let GetUserCity="\(baseUrl)setcity.action"
//上传图片
let GetUserFileupload="\(baseUrl)fileupload.action"