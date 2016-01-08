//
//  VCodeVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class VCodeVC: UIViewController {

    @IBOutlet var vcodeText: UITextField!
    @IBOutlet var showLabel: UILabel!
    @IBOutlet var nextBtn: UIButton!
    var setUserType:SetUserType?
    var phoneNum:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        
    }
    //配置界面
    func configView()
    {
        
        self.navigationController!.navigationBar.titleTextAttributes=[NSFontAttributeName:UIFont.systemFontOfSize(19),NSForegroundColorAttributeName:UIColor.whiteColor()]
         nextBtn.setBackgroundImage(btnBgImage, forState: UIControlState.Normal)
        self.navigationItem.title = NSLocalizedString("请输入验证码", comment: "")
        vcodeText.background=textBgImage!
        self.navigationController!.navigationBar.tintColor=UIColor.whiteColor()
        self.showLabel!.text=NSLocalizedString("请输入", comment: "")+self.phoneNum!+NSLocalizedString("收到的短信验证码", comment: "")
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)

  
    }

    @IBAction func nextTap(sender: AnyObject) {
        
        let passvc:PassWordVC = PassWordVC()
        //传递手机号与验证码
        passvc.phoneNum=phoneNum
        passvc.vcode=vcodeText!.text!.trimString()
        passvc.setUserType=setUserType
        self.navigationController?.pushViewController(passvc, animated: true)
      
    }
    
}
