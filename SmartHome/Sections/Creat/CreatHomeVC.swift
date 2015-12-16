//
//  CreatHomeVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class CreatHomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "创建"
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "导航栏L"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.translucent = false
        
        // Do any additional setup after loading the view.
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapCreatRoom(sender: UITapGestureRecognizer) {
        print("creat room")
        let creatRootVC = CreatRootVC(nibName: "CreatRootVC", bundle: nil)
        creatRootVC.creatType = CreatType.CreatTypeRoom
        navigationController?.pushViewController(creatRootVC, animated: true)
        print(creatRootVC.creatType)
        
    }

    @IBAction func tapCreatFloor(sender: UITapGestureRecognizer) {
        print("creat floor")
        let creatRootVC = CreatRootVC(nibName: "CreatRootVC", bundle: nil)
        creatRootVC.creatType = CreatType.CreatTypeFloor
        navigationController?.pushViewController(creatRootVC, animated: true)
        print(creatRootVC.creatType)
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
