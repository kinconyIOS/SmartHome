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

    @IBOutlet weak var nr: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.title = "一键报修"
        let itm = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Plain, target: self, action: "selectRightAction:")
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = itm
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //提交数据
    func selectRightAction(butt:UIButton)->Void{
        let parameters=["contents":ContentText.text]
        BaseHttpService .sendRequestAccess(Yijian_do, parameters:parameters) { (response) -> () in
            print(response)
            
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    //键盘消失
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
