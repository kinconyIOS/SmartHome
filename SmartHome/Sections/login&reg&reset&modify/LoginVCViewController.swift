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

       self.configView()
        
        
    }
    func configView()
    {
        self.view.backgroundColor=UIColor.whiteColor()
        self.loginBtn.backgroundColor=buttonColor1
        self.loginBtn.layer.cornerRadius=7.0
        self.loginBtn.layer.masksToBounds=true
    
       
        let image:UIImage = imageWithColor(UIColor.clearColor())
        self.navigationController!.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
        
        self.navigationController!.navigationBar.shadowImage=image
        
    
    }
    @IBAction func forgetPassTap(sender: AnyObject) {
        self.navigationController?.pushViewController(PhoneVC(), animated: true)
    }
}
