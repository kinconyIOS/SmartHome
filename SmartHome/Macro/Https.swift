//
//  Https.swift
//  SmartHome
//
//  Created by kincony on 16/1/13.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import Foundation


let baseUrl = "http://114.55.89.143:8080/smarthome.IMCPlatform/xingUser/"
//tupian
let imgUrl = "http:/114.55.89.143:8080/smarthome.IMCPlatform/"
////添加楼层
//let addFloor_do = "\(baseUrl)addfloor.action"
////添加房间
//let addRoom_do = "\(baseUrl)addroom.action"

//添加房间
let ezToken = "\(baseUrl)gainfluoriteaccesstoken.action"

let addEq_do = "\(baseUrl)setDeviceInfo.action"


let deviceStatus_do="\(baseUrl)queryroomdevicestate.action"
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
//----------
//添加购物车
let Add_Shopping="\(baseUrl)addshoppingcart.action"
//获取购物车商品
let Set_QueryShopping="\(baseUrl)queryshoppingcart.action"
//删除购物车商品
let Dele_shopoing = "\(baseUrl)delectshoppingcart.action"
//一键报修
let Add_Repair = "\(baseUrl)addRepair.action"
//解绑主机
let Dele_tallhost = "\(baseUrl)unbundlinghost.action"
//----
//支付回调接口
let Notifypay = "\(baseUrl)notifypay.action"
//已购接口
let Get_gainuserorder = "\(baseUrl)gainuserorder.action"
//物车里已购详情模块
let Get_gainuserorderInfo = "\(baseUrl)gainuserorderInfo.action"
//保存红外设备
let Set_setinfrareddeviceinfo = "\(baseUrl)setinfrareddeviceinfo.action"
//获取红外按钮
let Get_gaininfraredbuttonses = "\(baseUrl)gaininfraredbuttonses.action"
//----
//添加红外线
let Add_addinfraredbuttonses = "\(baseUrl)addinfraredbuttonses.action"
//删除红外线
let Dele_deleteinfraredbuttonses = "\(baseUrl)deleteinfraredbuttonses.action"
//学习控制
let studyandcommand = "\(baseUrl)studyandcommand.action"

//上传情景模式详情
let addmodelinfo = "\(baseUrl)addmodelinfo.action"
//情景模式----
//获取情景模式
let Get_gainmodel = "\(baseUrl)gainmodel.action"
//情景模式详情
let Get_gainmodelinfo = "\(baseUrl)gainmodelinfo.action"
//情景模式删除deletemodel.action
let Dele_deletemodel = "\(baseUrl)deletemodel.action"
//添加
let Add_addmodel = "\(baseUrl)addmodel.action"
//-----
//控制
let commandmodel = "\(baseUrl)commandmodel.action"
