//
//  RepairViewController.swift
//  SmartHome
//
//  Created by kincony on 16/3/31.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class RepairViewController: UIViewController {

    @IBOutlet var UserAddress: UITextField!
    @IBOutlet var UserContent: UITextView!
    @IBOutlet var UserIphooe: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //显示导航栏
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.title = "一键报修"
        // Do any additional setup after loading the view.
    }

    @IBAction func Submit(sender: AnyObject) {
        
        //返回
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
