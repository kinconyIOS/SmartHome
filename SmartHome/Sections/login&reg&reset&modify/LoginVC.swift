//
//  LoginVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController  {
    @IBOutlet var phoneText: UITextField!
    @IBOutlet var passText: UITextField!
    var time = 30
    var timer:NSTimer?
    @IBOutlet var phoneNumBg: UIImageView!

    @IBOutlet var bgImg: UIImageView!
    @IBOutlet var loginBtn: UIButton!
    
    @IBOutlet var vcodeBtn: UIButton!
   
    @IBOutlet var missCodeLabel: UILabel!
    
    var userlist:[String:String]?=["":""]
    var userNames:[String]?=[""]
    override func viewDidLoad() {

        super.viewDidLoad()
      
        self.configView()
       
      
    }
    
 
    @IBAction func sendVCodeTap(sender: UIButton) {
        
         let phone = self.phoneText.text?.trimString()
        if phone == ""{
            return
        }
        sender.userInteractionEnabled = false
        self.missCodeLabel.hidden = false
            self.vcodeBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.passText.becomeFirstResponder()

        BaseHttpService.sendRequest(sendCode_do, parameters: ["userPhone":phone!]) { (any:AnyObject) -> () in
        
            print(any)
        }
        //to do Btn 上跑一个定时器；
        doTimer()
        
    }
    
    func doTimer(){
        
        time = 90
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerFireMethod:", userInfo: nil, repeats:true);
        timer!.fire()
    }
    func timerFireMethod(timer: NSTimer) {
        if time == 0 {
            self.missCodeLabel.hidden = true
            self.vcodeBtn.userInteractionEnabled = true
             self.vcodeBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            timer.invalidate()
        return
        }
        self.missCodeLabel!.text = "\(time)秒之后点击获取验证码重新发送"
        time = time - 1
        
    }
 
    func configView()
    {
        self.missCodeLabel.hidden = true
        self.bgImg.image=loginBgImage!
        self.view.backgroundColor=UIColor.whiteColor()
        self.loginBtn.layer.cornerRadius=7.0
        self.loginBtn.layer.masksToBounds=true
        self.loginBtn.setBackgroundImage(btnBgImage, forState: UIControlState.Normal)
        self.loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.vcodeBtn.layer.cornerRadius=4.0
        self.vcodeBtn.layer.masksToBounds=true
        
               
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let image:UIImage = imageWithColor(UIColor.clearColor())
        self.navigationController!.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
        
        self.navigationController!.navigationBar.shadowImage=image
        
    }

    @IBAction func loginTap(sender: AnyObject) {
        
        BaseHttpService.clearToken()
        NSUserDefaults.standardUserDefaults().setObject("0", forKey: "password")
      let phone = self.phoneText.text?.trimString()
      let pwd = self.passText.text?.trimString()
        print("----a\(phone),\(pwd)")
        BaseHttpService.sendRequest(login_do, parameters: ["userPhone":phone!,"verifyCode":pwd!]) { [unowned self](any:AnyObject) -> () in
            if any["success"] as! Bool == true{
                 BaseHttpService.setAccessToken(any["data"]!!["accessToken"] as!String)
                 BaseHttpService.setRefreshAccessToken(any["data"]!!["refreshToken"] as!String)
                 BaseHttpService.setUserCode(any["data"]!!["userCode"] as!String)
                let ezToken = any["data"]!!["ez_token"] as!String
                let isFirst = any["data"]!!["isFirst"] as! Bool
                BaseHttpService.setUserCity(any["data"]!!["city"] as!String)
                GlobalKit.shareKit().accessToken = ezToken == "NO_BUNDING" ? nil : ezToken
            
                EZOpenSDK.setAccessToken(GlobalKit.shareKit().accessToken)
               
                
                
              self.loginSuccess(!isFirst)
                
            } else{
                showMsg(any["message"] as! String)
                
            }//失效

            print(any)
        }
        
        //保存到本地
        //  setDefault(phone!, pwd:pwd!)
        //登陆到服务器
        
    
        
        
    }
    func loginSuccess(isFisrt:Bool){
        //读取房间信息
      
        
            if
                isFisrt == true
            {
                
                NSUserDefaults.standardUserDefaults().setObject(true, forKey: "isSecondLogin")
                
                let creatHomeVC = CreatHomeViewController(nibName: "CreatHomeViewController", bundle: nil)
                let creatNavigationC = UINavigationController(rootViewController: creatHomeVC)
                app.window!.rootViewController = creatNavigationC
                
                
            }else{
                 app.window!.rootViewController = TabbarC()
            }
       
    
    
    }
    @IBAction func onExit(sender: AnyObject) {
        self.view.endEditing(true)
       // self.userNameTableView?.hidden = true
    }
       @IBAction func showUserList(sender: UIButton) {
        userlist = NSUserDefaults.standardUserDefaults().objectForKey("userList") as? [String:String]
        userNames?.removeAll()
        for key in (userlist?.keys)!{
           userNames?.append(key)
        }

    }
 
    
         // MARK: - Table view data source
    //返回节的个数
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        
//        return 1
//    }
//    //返回某个节中的行数
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return (self.userNames?.count)!
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell:userNameCell? = tableView.dequeueReusableCellWithIdentifier("userNameCell",forIndexPath: indexPath) as? userNameCell
//        
//        cell?.tag=indexPath.row
//        print(cell?.tag)
//        cell?.deleteSelf=deleteSelf
//        cell?.userName?.text = self.userNames?[indexPath.row]
//        return cell!
//    }
//    func deleteSelf(tag:Int){
//        print(tag)
//        self.userlist?.removeValueForKey((self.userNames?[tag])!)
//        self.userNames?.removeAtIndex(tag)
//        self.userNameTableView?.frame=CGRectMake(2, phoneNumBg.frame.height+phoneNumBg.frame.origin.y, phoneNumBg.frame.width-4, CGFloat(Float((self.userNames?.count)!*35)))
//        NSUserDefaults.standardUserDefaults().setObject(userlist, forKey: "userList")
//        self.userNameTableView?.reloadData()
//        
//    }    //点击事件
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        self.phoneText.text=self.userNames?[indexPath.row]
//        print(self.userlist!)
//        self.passText.text=self.userlist![(self.userNames?[indexPath.row])!]
//        self.userNameTableView?.hidden = true
//    }
//    //高度
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 35
//    }
    
}
