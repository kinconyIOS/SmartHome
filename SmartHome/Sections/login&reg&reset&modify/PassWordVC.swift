//
//  PassWordVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class PassWordVC: UIViewController {
    @IBOutlet var firstPassText: UITextField!
    
    @IBOutlet var lastPassText: UITextField!
    
    @IBOutlet var doBtn: UIButton!
    var setUserType:SetUserType?
    var vcode:String?=""
    var phoneNum:String?=""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        
    }
    
    func configView()
    {
        
        //保证图片拉伸不变形
        firstPassText.background=textBgImage!
        lastPassText.background=textBgImage!
        doBtn.setBackgroundImage(btnBgImage, forState: UIControlState.Normal)
        self.navigationController!.navigationBar.titleTextAttributes=[NSFontAttributeName:UIFont.systemFontOfSize(19),NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.navigationItem.title = NSLocalizedString("完成注册", comment: "")
        self.navigationController!.navigationBar.tintColor=UIColor.whiteColor()
   
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        
        
    }
    
    @IBAction func nextTap(sender: AnyObject) {
        let fpass = firstPassText.text?.trimString()
        let lpass = lastPassText.text?.trimString()
        if fpass == "" || lpass == "" {
        showMsg("密码不能为空")
            return
        }
        if fpass != lpass{
        showMsg("两次密码不一致")
            return
        }
     
        
        
        
        let manager = AFHTTPRequestOperationManager()
        var url_action:String?
        var params:NSDictionary?
        switch setUserType!//修改密码不需要vcode
        {
        case SetUserType.Modify :
            params = ["userPhone": self.phoneNum!,"userPwd":lpass!]
        case SetUserType.Reg :
            url_action=reg
            params = ["userPhone": self.phoneNum!,
                "verifyCode":self.vcode!,"userPwd":lpass!]
        case SetUserType.Reset :
            url_action=reset
            params = ["userPhone": self.phoneNum!,
                "verifyCode":self.vcode!,"userPwd":lpass!]
            
        }
        let url=BaseUrl+url_action!
        print(url)
        print(params)
        manager.GET(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                print("JSON: " + responseObject.description!)
                if responseObject != nil && responseObject!["success"]!!.boolValue == true
                {
                    let successvc:SuccessVC? = SuccessVC()
                    successvc!.setUserType=self.setUserType
                    
                    self.navigationController?.pushViewController(successvc!, animated: true)
                }else  if(responseObject == nil){
                     showMsg(responseObject!["message"]! as! String)
                }else{
                    showMsg("操作失败,请重新尝试")
                    
                }

               
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                print("Error: " + error.localizedDescription)
        })
        
    }
    
}
