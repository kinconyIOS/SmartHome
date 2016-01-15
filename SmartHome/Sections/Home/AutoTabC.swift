//
//  AutoTabC.swift
//  SmartHome
//
//  Created by sunzl on 16/1/14.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class AutoTabC: UITabBarController {
    override func shouldAutorotate() -> Bool {
        print("yes0")
        return (self.selectedViewController?.shouldAutorotate())!
    }
}
