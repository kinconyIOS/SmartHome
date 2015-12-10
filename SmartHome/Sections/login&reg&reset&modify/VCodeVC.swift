//
//  VCodeVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class VCodeVC: UIViewController {

    @IBOutlet var showLabel: UILabel!
    @IBOutlet var nextBtn: UIButton!
    var phoneNum:String?{
        willSet{
            print("号码为"+newValue!);
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        
    }
    
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
        
    }
    
}
