//
//  PhoneVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class PhoneVC: UIViewController {

    @IBOutlet var nextBtn: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configView();
        // Do any additional setup after loading the view.
    }
    func configView()
    {
        nextBtn.layer.cornerRadius=7.0
        nextBtn.layer.masksToBounds=true;
        
        self.navigationController!.navigationBar.titleTextAttributes=[NSFontAttributeName:UIFont.systemFontOfSize(19),NSForegroundColorAttributeName:UIColor.whiteColor()]
        if #available(iOS 9.0, *) {
            self.navigationItem.title = NSLocalizedString("输入手机号", comment: "");
        } else {
            // Fallback on earlier versions
        }
        self.navigationController!.navigationBar.tintColor=UIColor.whiteColor()
        let image:UIImage = imageWithColor(UIColor.blueColor())
        self.navigationController!.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
        
        self.navigationController!.navigationBar.shadowImage=image
      
    
    }

  
}
