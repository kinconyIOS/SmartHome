//
//  LoginVCViewController.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet var loginBtn: UIButton!
    var i:Int?
    deinit{
        
    }
    override func viewDidLoad() {

        super.viewDidLoad()
        self.configView()
        i=0
       // NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("greetings"), userInfo: nil, repeats: true)
     
    }
//   func greetings(){
//       print(i!++);
//    }
    func configView()
    {
        self.view.backgroundColor=UIColor.whiteColor()
        self.loginBtn.backgroundColor=buttonColor1
        self.loginBtn.layer.cornerRadius=7.0
        self.loginBtn.layer.masksToBounds=true
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let image:UIImage = imageWithColor(UIColor.clearColor())
        self.navigationController!.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
        
        self.navigationController!.navigationBar.shadowImage=image
        
    }
    @IBAction func forgetPassTap(sender: AnyObject) {
        let phonevc:PhoneVC = PhoneVC()
        phonevc.setUserType=SetUserType.Reset;
        self.navigationController?.pushViewController(phonevc, animated: true)
    }
    @IBAction func registerNewUserTap(sender: AnyObject) {
        let phonevc:PhoneVC = PhoneVC()
        phonevc.setUserType=SetUserType.Reg;
        self.navigationController?.pushViewController(phonevc, animated: true)
    }
}
