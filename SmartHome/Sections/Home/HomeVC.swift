//
//  HomeVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    let  hscroll:HScrollView?=HScrollView.init(frame: CGRectMake(0,20, ScreenWidth-60, 44));
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        // Do any additional setup after loading the view.
    }
    func configView(){
      self.navigationItem.titleView=hscroll;
     scrollAddBtn()
    }

}
func scrollAddBtn()
    {
        
        let array=["精选","电视剧","电影","综艺","娱乐","健康","科技","游戏","体育","搞笑"];
        for index in 1...array.count
        {
            let btn:UIButton=UIButton.init(frame: CGRectMake(0, 2, ScreenWidth/6, 30))
           
            //设置倒角
            btn.layer.cornerRadius=15;
            if index==1 {
                btn.backgroundColor=UIColor.whiteColor();
                btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            
            }
            btn .setTitle(array[index-1], forState: UIControlState.Normal)
            btn.tag=index
            
           // btn.titleLabel?.font=UIFont.fontWithSize(16.0)
          
         //  btn.addTarget(self, action: Selector("newTap"), forControlEvents: UIControlEvents.TouchUpInside)
          
            
          //  [hscroll addButton:btn with:45];
            
        }
}


