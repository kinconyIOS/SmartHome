//
//  AddDeviceViewController.swift
//  SmartHome
//
//  Created by kincony on 15/12/22.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import Alamofire

class AddDeviceViewController: UIViewController ,QRCodeReaderDelegate{
    static let myreader=QRCodeReaderViewController(cancelButtonTitle:"取消识别")

    var onceToken:dispatch_once_t = 0
    @IBOutlet var compeletBtn: UIButton! {
        didSet {
            compeletBtn.layer.cornerRadius = 5
            compeletBtn.layer.masksToBounds = true
        }
    }
    @IBOutlet var serialNumberTF: UITextField!
    var deviceCode = ""
    @IBOutlet var nicknameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "导航栏L"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.title = "添加的主机"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleRightItem:"))
        
    }
    
    func handleRightItem(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(false, completion: nil)
        compeletBlock?()
    }
    
    @IBAction func handleScanning(sender: UITapGestureRecognizer) {
      
        
            if (QRCodeReader.supportsMetadataObjectTypes([AVMetadataObjectTypeQRCode])) {
                
              AddDeviceViewController.myreader.modalPresentationStyle = UIModalPresentationStyle.FormSheet
                AddDeviceViewController.myreader.delegate = self
                AddDeviceViewController.myreader.setCompletionWithBlock({ (resultAsString) -> Void in
                     print(resultAsString)
                })   


                self.presentViewController(AddDeviceViewController.myreader, animated: true, completion: nil)
               
              
            
                
               
            }
            else {
                print("设备不支持照相功能")
            }
        }
        
//- #pragma mark - QRCodeReader Delegate Methods
    func reader(reader: QRCodeReaderViewController!, didScanResult result: String!) {
        self.deviceCode = result
        self.serialNumberTF.text = result
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func readerDidCancel(reader: QRCodeReaderViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
            
    
    
    func setCompeletBlock(block: () -> ()) {
        self.compeletBlock = block
    }
    
    private var compeletBlock: (() -> ())?
    
    @IBAction func handleCompelet(sender: UIButton) {
        if self.deviceCode == ""
        {
        return
        }
        let parameters = ["deviceCode":self.deviceCode,"userCode":"U00318"]
       BaseHttpService.sendRequestAccess(shaom_do, parameters: parameters) { (anyObject) -> () in
        print(anyObject)
        }
     
        
        
    }
    
  
    @IBAction func exitKeyboard(sender: UITextField) {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.serialNumberTF.resignFirstResponder()
        self.nicknameTF.resignFirstResponder()
    }

 

}
