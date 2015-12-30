//
//  PhoneVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class PhoneVC: UIViewController {

    @IBOutlet var phoneText: UITextField!
    @IBOutlet var nextBtn: UIButton!
  
    var setUserType:SetUserType?{
        willSet{
        print("新值为:\(newValue)\n")
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configView();
        // Do any additional setup after loading the view.
    }
    
    func configView()
    {
        nextBtn.layer.cornerRadius=7.0
        nextBtn.layer.masksToBounds=true;
        nextBtn.setBackgroundImage(btnBgImage, forState: UIControlState.Normal)
     
       phoneText.background=textBgImage!
        self.navigationController!.navigationBar.titleTextAttributes=[NSFontAttributeName:UIFont.systemFontOfSize(19),NSForegroundColorAttributeName:UIColor.whiteColor()]
    
        switch setUserType!
        {
        case SetUserType.Modify : self.navigationItem.title = NSLocalizedString("修改密码", comment: "")
        case SetUserType.Reg :self.navigationItem.title = NSLocalizedString("注册账号", comment: "")
        case SetUserType.Reset :self.navigationItem.title = NSLocalizedString("重置密码", comment: "")
       
        }
       
      
        self.navigationController!.navigationBar.tintColor=UIColor.whiteColor()
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        
       
      
    
    }

    @IBAction func nextTap(sender: AnyObject) {
       //验证手机号格式
        let codevc:VCodeVC=VCodeVC()
        codevc.phoneNum=phoneText.text!.trimString()
        if !validateMobile(codevc.phoneNum!) {
            showMsg("手机号格式不对，请重新输入");
            return
        }
        //发送验证码并跳转界面
        let manager = AFHTTPRequestOperationManager()
        let url=BaseUrl+"send.action"
        let params = ["userPhone": codevc.phoneNum!]
        print(url)
        print(params)
             manager.GET(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                print("JSON: " + responseObject.description!)
                self.navigationController?.pushViewController(codevc, animated: true)
                },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                print("Error: " + error.localizedDescription)
        })
     }
}
