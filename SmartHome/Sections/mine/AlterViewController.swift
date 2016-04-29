//
//  AlterViewController.swift
//  SmartHome
//
//  Created by kincony on 16/3/30.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class AlterViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    var alteText:String!
    var textName:String?
    //声明一个闭包
    var myClosure:callbackfunc?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        let itm = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Plain, target: self, action: "selectRightAction:")
        self.navigationItem.rightBarButtonItem = itm
        self.navigationItem.title = alteText
        textField.clearButtonMode = UITextFieldViewMode.Always
        textField.text = textName;
        textField.delegate = self
        // Do any additional setup after loading the view.
    }
    //提交数据
    func selectRightAction(butt:UIButton)->Void{
       
        if self.alteText == "修改姓名"{
            let parameters=["userName":textField.text!]
            BaseHttpService.sendRequestAccess(GetUserName, parameters:parameters) { (response) -> () in
                print(response)
            }
        }else if self.alteText == "修改签名"{
            let parameters=["signature":textField.text!]
            BaseHttpService.sendRequestAccess(GetUserSignature, parameters:parameters) { (response) -> () in
                print(response)
            }
            
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        self.myClosure?(textField.text!)
    }
    //设置输入长度
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.characters.count > 10 {
         return false
        }
        
        return true
    }
    //键盘消失
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //块
    typealias callbackfunc = (String)->()
  
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针

    func completeBlock(chName:callbackfunc)->Void{
        
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
