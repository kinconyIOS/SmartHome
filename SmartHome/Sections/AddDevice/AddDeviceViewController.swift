//
//  AddDeviceViewController.swift
//  SmartHome
//
//  Created by kincony on 15/12/22.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class AddDeviceViewController: UIViewController {
    @IBOutlet var compeletBtn: UIButton! {
        didSet {
            compeletBtn.layer.cornerRadius = 5
            compeletBtn.layer.masksToBounds = true
        }
    }
    @IBOutlet var serialNumberTF: UITextField!

    @IBOutlet var nicknameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "导航栏L"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "矢量智能对象"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleBack:"))
    }
    func handleBack(barButton: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func handleScanning(sender: UITapGestureRecognizer) {
        let qrCodeScan = LQRcodeVC()
        qrCodeScan.setCompeletBlock { (resultString) -> () in
            print(resultString)
            qrCodeScan.stopScanning()
            let alertView = AddDeviceAlert(success: true)
            alertView.show()
        }
        self.presentViewController(qrCodeScan, animated: true, completion: nil)
    }
    @IBAction func handleCompelet(sender: UIButton) {
        let successAlert = AddDeviceAlert(success: true)
        successAlert.show()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    @IBAction func exitKeyboard(sender: UITextField) {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.serialNumberTF.resignFirstResponder()
        self.nicknameTF.resignFirstResponder()
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
