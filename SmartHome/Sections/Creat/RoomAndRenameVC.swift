//
//  RoomAndRenameVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/15.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

enum RoomOrRenameType {
    case RoomType
    case RenameType
}

class RoomAndRenameVC: UIViewController {
    
    var viewType: RoomOrRenameType = .RoomType {
        willSet {
            switch newValue {
            case .RoomType:
                navigationItem.title = "创建房间"
            case .RenameType:
                navigationItem.title = "重命名"
            
            }
        }
    }
    
    @IBOutlet var roomTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "矢量智能对象"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleBack:"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleRightItem:"))
    }

    func handleBack(barButton: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func handleRightItem(barButton: UIBarButtonItem) {
        
    }
    @IBAction func exitAction(sender: UITextField) {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
