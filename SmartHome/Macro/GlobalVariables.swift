//
//  GlobalVariables.swift
//  SmartHome
//
//  Created by kincony on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import Foundation
import UIKit
//常用

var ScreenWidth: CGFloat {
    return UIScreen.mainScreen().bounds.width
}
var ScreenHeight: CGFloat {
    return UIScreen.mainScreen().bounds.height
}

let themeColors = UIColor(RGB: 0x2fceaa, alpha: 1)

let app = (UIApplication.sharedApplication().delegate) as! AppDelegate
let mainColor=UIColor(RGB: 0x2fceaa,alpha: 1)
//图片
//输入框背景
let textImage:UIImage? = UIImage(named: "输入框背景.png")
//保证图片拉伸不变形
let textBgImage:UIImage?=textImage!.stretchableImageWithLeftCapWidth((Int)(textImage!.size.width/2), topCapHeight:(Int)(textImage!.size.height/2))
//导航栏背景
let navBgImage:UIImage? = UIImage(named: "导航栏L")
//登陆界面背景
let loginBgImage:UIImage? = UIImage(named: "背景.png")
//登陆注册等按钮背景
let btnBgImage:UIImage? = UIImage(named: "登陆.png")
 //首页
let homeIcon:UIImage? = UIImage(named: "首页未按.png")
let homeIconSelected:UIImage? = UIImage(named: "首页.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//情景模式
let modelIcon:UIImage? = UIImage(named: "情景模式未按.png")
let modelIconSelected:UIImage? = UIImage(named: "情景模式.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//语音
let voiceIcon:UIImage? = UIImage(named: "语音未按.png")
let voiceIconSelected:UIImage? = UIImage(named: "语音.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//商城
let mallIcon:UIImage? = UIImage(named: "购物未按.png")
let mallIconSelected:UIImage? = UIImage(named: "购物.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//我的
let mineIcon:UIImage? = UIImage(named: "我的未按.png")
let mineIconSelected:UIImage? = UIImage(named: "我的.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

public enum SetUserType:Int{
    case Reg
    case Reset
    case Modify
}
//网络请求
let BaseUrl:String = "http://192.168.1.178:8080/smarthome.IMCPlatform/xingUser/"
let reg:String="registers.action"
let send:String="send.action"
let reset:String="forgotpwd.action"
let modifypwd:String="modifypwd.action"
let getroom:String="getroom.action"