//
//  WeatherModel.swift
//  SmartHome
//
//  Created by sunzl on 15/12/24.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class WeatherModel: NSObject {
    var aMaxTemp:String=""
    var aSmallTemp:String=""
    var aWeather:String=""
    var aWind:String=""
    var dayPictureUrl:String=""
    var nightPictureUrl:String=""
    init(aMaxTemp:String,aSmallTemp:String,aWeather:String,aWind:String,dayPictureUrl:String,nightPictureUrl:String) {
        self.aMaxTemp=aMaxTemp
        self.aSmallTemp=aSmallTemp
        self.aWeather=aWeather
        self.aWind=aWind
        self.dayPictureUrl=dayPictureUrl
        self.nightPictureUrl=nightPictureUrl
    }
}
