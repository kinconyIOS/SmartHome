//
//  LoginVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet var phoneText: UITextField!
    @IBOutlet var passText: UITextField!

    @IBOutlet var bgImg: UIImageView!
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
        bgImg.image=loginBgImage!
        self.view.backgroundColor=UIColor.whiteColor()
        self.loginBtn.layer.cornerRadius=7.0
        self.loginBtn.layer.masksToBounds=true
        self.loginBtn.setBackgroundImage(btnBgImage, forState: UIControlState.Normal)
        self.loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.addTouchDownHideKey()
     
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
    @IBAction func loginTap(sender: AnyObject) {

        let homevc:HomeVC=HomeVC()
        homevc.tabBarItem.title=NSLocalizedString("首页", comment: "")
        homevc.tabBarItem.image=homeIcon
        homevc.tabBarItem.selectedImage=homeIconSelected
          let homeNav:UINavigationController = UINavigationController(rootViewController: homevc)
        
        let setModelVC:SetModelVC=SetModelVC()
        setModelVC.tabBarItem.title=NSLocalizedString("情景模式", comment: "")
        setModelVC.tabBarItem.image=modelIcon
        setModelVC.tabBarItem.selectedImage=modelIconSelected
          let setModelNav:UINavigationController = UINavigationController(rootViewController: setModelVC)
        
        let mallvc:MallVC=MallVC()
        mallvc.tabBarItem.title=NSLocalizedString("商城", comment: "")
        mallvc.tabBarItem.image=mallIcon
        mallvc.tabBarItem.selectedImage=mallIconSelected
          let mallNav:UINavigationController = UINavigationController(rootViewController:mallvc)
        
        let minevc:MineVC=MineVC()
        minevc.tabBarItem.title=NSLocalizedString("我的", comment: "")
        minevc.tabBarItem.image=mineIcon
        minevc.tabBarItem.selectedImage=mineIconSelected
        let mineNav:UINavigationController = UINavigationController(rootViewController: minevc)
        let tab=UITabBarController()
        tab.viewControllers=[homeNav,setModelNav,mallNav,mineNav];
        tab.tabBar.tintColor=mainColor
        let createHome = CreatHomeVC()
        let navigationC = UINavigationController(rootViewController: createHome)
        self.navigationController?.presentViewController(tab, animated: true, completion:nil)
    }
    @IBAction func onExit(sender: AnyObject) {
    }
   
    @IBAction func showUserList(sender: UIButton) {
    }
    @IBAction func showPassWord(sender: UIButton) {
        self.passText.secureTextEntry = !self.passText.secureTextEntry
    }
}
