//
//  PurchaseViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/5/3.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class PurchaseViewController: UIViewController,UIActionSheetDelegate {
    @IBOutlet weak var qund: UIButton!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var phone: UITextField!
    var coID = [String]()
    var mo:Float?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "购买信息"
        self.qund.addTarget(self, action: "purchase:", forControlEvents: UIControlEvents.TouchUpInside)
        // Do any additional setup after loading the view.
    }
    func purchase(but:UIButton){
        let actionSheet:UIActionSheet? = UIActionSheet(title:nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles:"支付宝", "微信")
        actionSheet?.showInView(self.view)
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex == 1{
            print(1)
            normalPayAction((self.mo!*100 as NSNumber).stringValue)
        }else if buttonIndex == 2{
            print(2)
        }else if buttonIndex == 0{
            print(0)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //键盘消失
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func normalPayAction(amount:String){
        //let str = (self.coID! as NSNumber).stringValue
        var str:String? = ""
        for var i = 0;i<self.coID.count;++i{
            str! += self.coID[i] + ","
        }
        print(str)
        let parametrs = ["channel":"alipay",
            "amount":amount,
            "description":Name.text! + "," + phone.text! + "," + address.text!,
            "goodsid":str!]
        print(parametrs)
        BaseHttpService .sendRequestAccess(Notifypay, parameters:parametrs) { (response) -> () in
            print(response)
            let obj = response["charge"]
            Pingpp.createPayment(obj as! NSObject, appURLScheme: "SmerHomer2016", withCompletion: { (error, PingppError) -> Void in
                if (error == nil) {
                    // print("errno is no")
                } else {
                    // print("PingppError: code=%lu msg=%@", error , error.getMsg);
                }
            })
        }
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
