//
//  FeedbackViewController.swift
//  SmartHome
//
//  Created by kincony on 16/3/31.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    @IBOutlet var ContentText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.title = "一键报修"
        let itm = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Plain, target: self, action: "selectRightAction:")
        self.navigationItem.rightBarButtonItem = itm
        // Do any additional setup after loading the view.
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
