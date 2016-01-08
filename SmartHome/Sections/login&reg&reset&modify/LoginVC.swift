//
//  LoginVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class LoginVC: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    @IBOutlet var phoneText: UITextField!
    @IBOutlet var passText: UITextField!

    @IBOutlet var phoneNumBg: UIImageView!
   lazy var userNameTableView:UITableView?={
       print("创建table")
       let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.hidden=true
        tableView.delegate=self
        tableView.dataSource=self
       tableView.registerNib(UINib(nibName: "userNameCell", bundle: nil), forCellReuseIdentifier: "userNameCell")
        self.view.addSubview(tableView)
        return tableView
    }()
    @IBOutlet var bgImg: UIImageView!
    @IBOutlet var loginBtn: UIButton!
    
   
    var userlist:[String:String]?=["":""]
    var userNames:[String]?=[""]
    override func viewDidLoad() {

        super.viewDidLoad()
        self.configView()
       
      
    }
    
 
    func configView()
    {
        self.bgImg.image=loginBgImage!
        self.view.backgroundColor=UIColor.whiteColor()
        self.loginBtn.layer.cornerRadius=7.0
        self.loginBtn.layer.masksToBounds=true
        self.loginBtn.setBackgroundImage(btnBgImage, forState: UIControlState.Normal)
        self.loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        
               
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
      let phone = self.phoneText.text?.trimString()
        let pwd = self.passText.text?.trimString()
        setDefault(phone!, pwd:pwd!)
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
        //let navigationC = UINavigationController(rootViewController: createHome)

        app.window?.rootViewController=tab
        
     //   self.navigationController?.presentViewController(tab, animated: true, completion:nil)
    }
    @IBAction func onExit(sender: AnyObject) {
        self.view.endEditing(true)
        self.userNameTableView?.hidden = true
    }
   
    @IBAction func showUserList(sender: UIButton) {
         userlist = NSUserDefaults.standardUserDefaults().objectForKey("userList") as? [String:String]
        userNames?.removeAll()
        for key in (userlist?.keys)!{
           userNames?.append(key)
        }
        
         self.userNameTableView?.frame=CGRectMake(2, phoneNumBg.frame.height+phoneNumBg.frame.origin.y, phoneNumBg.frame.width-4, CGFloat(Float((self.userNames?.count)!*35)))
       self.userNameTableView!.hidden = !self.userNameTableView!.hidden
        self.userNameTableView?.reloadData()
    }
    @IBAction func showPassWord(sender: UIButton) {
        self.passText.secureTextEntry = !self.passText.secureTextEntry
    }
    // MARK: - Table view data source
    //返回节的个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      
        return 1
    }
    //返回某个节中的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return (self.userNames?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
           let cell:userNameCell? = tableView.dequeueReusableCellWithIdentifier("userNameCell",forIndexPath: indexPath) as? userNameCell

        cell?.tag=indexPath.row
        print(cell?.tag)
        cell?.deleteSelf=deleteSelf
        cell?.userName?.text = self.userNames?[indexPath.row]
        return cell!
    }
    func deleteSelf(tag:Int){
        print(tag)
        self.userlist?.removeValueForKey((self.userNames?[tag])!)
        self.userNames?.removeAtIndex(tag)
        self.userNameTableView?.frame=CGRectMake(2, phoneNumBg.frame.height+phoneNumBg.frame.origin.y, phoneNumBg.frame.width-4, CGFloat(Float((self.userNames?.count)!*35)))
         NSUserDefaults.standardUserDefaults().setObject(userlist, forKey: "userList")
        self.userNameTableView?.reloadData()
        
    }    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        self.phoneText.text=self.userNames?[indexPath.row]
        print(self.userlist!)
        self.passText.text=self.userlist![(self.userNames?[indexPath.row])!]
        self.userNameTableView?.hidden = true
    }
    //高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       return 35
    }
}
