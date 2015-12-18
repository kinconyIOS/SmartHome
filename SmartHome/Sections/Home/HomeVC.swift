//
//  HomeVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    let array=["精选","电视剧","电影","综艺","娱乐","健康","科技","游戏","体育","搞笑"];
    let  hscroll:HScrollView?=HScrollView.init()
    var sideView:SZLSideView?
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
          self.view.addSubview(Waiting())
        // Do any additional setup after loading the view.
    }
    override  func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //侧滑
      
        if sideView==nil{
          sideView = NSBundle.mainBundle().loadNibNamed("SZLSideView", owner: self, options: nil)[0] as? SZLSideView
          sideView!.frame=CGRectMake(ScreenWidth, 0, sideView!.frame.size.width,ScreenHeight);
    
            self.tabBarController!.view.addSubview(sideView!)
           
        }
        
    }
    func configView(){
           self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        hscroll!.frame=CGRectMake(0,20, ScreenWidth-60, 64);
    
        self.navigationItem.titleView=hscroll;
        scrollAddBtn()
    }
    func scrollAddBtn()
    {
        for index in 1...array.count
        {
            let btn:UIButton=UIButton.init(frame: CGRectMake(0, 2, ScreenWidth/6, 30))
            //设置倒角
            btn.layer.cornerRadius=15;
            btn.setTitleColor(UIColor.blackColor(),forState:UIControlState.Normal);
            btn.backgroundColor=UIColor.clearColor()
            if index==1 {
                btn.backgroundColor=UIColor.whiteColor();
                btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            }
            btn.setTitle(array[index-1], forState: UIControlState.Normal)
            btn.tag=index
            
            btn.titleLabel?.font=UIFont.systemFontOfSize(15)
            btn.addTarget(self,action: Selector("newTap:"), forControlEvents: UIControlEvents.TouchUpInside)
            hscroll?.addButton(btn, with: 45)
        }
    }
    func newTap(btn:UIButton)
    {
        hscroll?.clearColor();
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.backgroundColor=UIColor.whiteColor();
        // selectMenuId=(int)btn.tag-1;
    }
  
    @IBAction func closeSideViewGesture(sender: AnyObject) {
        sideView?.closeTap()
    }
   
    @IBAction func openSideViewGesture(sender: AnyObject) {
        sideView?.openTap()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        sideView?.closeTap()
    }
}


