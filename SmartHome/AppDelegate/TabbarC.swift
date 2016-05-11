//
//  TabbarC.swift
//  SmartHome
//
//  Created by sunzl on 16/5/10.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class TabbarC: UITabBarController {
    lazy var btn:UIButton = {
       let _btn = UIButton(frame: CGRectMake(ScreenWidth/2-19,-10,38,38))
       _btn.setImage(voiceIconSelected, forState: UIControlState.Normal)
       _btn.backgroundColor = UIColor.whiteColor()
        _btn.layer.cornerRadius = 19
        _btn.layer.masksToBounds = true
        _btn.layer.borderWidth = 1.0
       _btn.layer.borderColor = mainColor.CGColor
    
      return _btn;
    
    }()
    lazy var yytool = YYTool.share()
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.tabBar.opaque = true;
        self.configBtn()
        self.tabBar.backgroundImage = imageWithColor(UIColor.clearColor())
        self.tabBar.shadowImage = imageWithColor(UIColor.clearColor())

        self.tabBar.backgroundImage = imageWithColor(UIColor.whiteColor())
       
       
        
        
        //
        let homevc:HomeVC=HomeVC(nibName: "HomeVC", bundle: nil)
        homevc.tabBarItem.title=NSLocalizedString("首页", comment: "")
        homevc.tabBarItem.image=homeIcon
        homevc.tabBarItem.selectedImage=homeIconSelected
        let homeNav:AutorotateNavC = AutorotateNavC(rootViewController: homevc)
        
        let setModelVC:SetModelVC=SetModelVC(nibName: "SetModelVC", bundle: nil)
        setModelVC.tabBarItem.title=NSLocalizedString("发现", comment: "")
        setModelVC.tabBarItem.image=modelIcon
        setModelVC.tabBarItem.selectedImage=modelIconSelected
        let setModelNav:UINavigationController = UINavigationController(rootViewController: setModelVC)
        
       
        
        let mallvc:MallVC=MallVC(nibName: "MallVC", bundle: nil)
        mallvc.tabBarItem.title=NSLocalizedString("商城", comment: "")
        mallvc.tabBarItem.image=mallIcon
        mallvc.tabBarItem.selectedImage=mallIconSelected
        let mallNav:UINavigationController = UINavigationController(rootViewController:mallvc)
        
        let minevc:MineVC=MineVC(nibName: "MineVC", bundle: nil)
        minevc.tabBarItem.title=NSLocalizedString("我的", comment: "")
        minevc.tabBarItem.image=mineIcon
        minevc.tabBarItem.selectedImage=mineIconSelected
        let mineNav:UINavigationController = UINavigationController(rootViewController: minevc)
      
        self.viewControllers=[homeNav,setModelNav,mallNav,mineNav];
        
         self.tabBar.bringSubviewToFront(self.btn)
         self.tabBar.tintColor=mainColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func configBtn()
    {
    
     self.tabBar.addSubview(self.btn)
    
     self.btn.addTarget(self, action: Selector("tap"), forControlEvents:UIControlEvents.TouchUpInside)
    
    }
    func tap()
    {
      yytool.parentView = UIWindow.visibleViewController().view
        yytool.yyfuwu()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
