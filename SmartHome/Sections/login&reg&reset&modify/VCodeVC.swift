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
        
        self.navigationItem.title = NSLocalizedString("请输入验证码", comment: "")
        self.navigationController!.navigationBar.tintColor=UIColor.whiteColor()
        self.showLabel!.text=NSLocalizedString("请输入", comment: "")+self.phoneNum!+NSLocalizedString("收到的短信验证码", comment: "")
        let image:UIImage = imageWithColor(UIColor.blueColor())
        self.navigationController!.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage=image
  
    }

    @IBAction func nextTap(sender: AnyObject) {
        
        let passvc:PassWordVC = PassWordVC()
        //传递手机号与验证码
        passvc.phoneNum=phoneNum
        passvc.vcode=trimString(vcodeText!.text!)
        self.navigationController?.pushViewController(passvc, animated: true)
      
    }
    
}
