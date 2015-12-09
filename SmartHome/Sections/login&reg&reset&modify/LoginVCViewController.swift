//
//  LoginVCViewController.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class LoginVCViewController: UIViewController {

    @IBOutlet var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor=UIColor.whiteColor()
        self.loginBtn.backgroundColor=buttonColor1
        self.loginBtn.layer.cornerRadius=7.0
        self.loginBtn.layer.masksToBounds=true;
        
        
    }
}
