//
//  CameraCell.swift
//  SmartHome
//
//  Created by sunzl on 16/4/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class CameraCell: UICollectionViewCell ,UIAlertViewDelegate{
    @IBOutlet var offlineIcon: UIImageView!
    var equip:Equip?
    var passWord:UITextField?
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setCameraInfo(cameraInfo:EZCameraInfo)
    {
    
    
    if (cameraInfo.isOnline)
    {
     self.offlineIcon.hidden = true
    }
    else
    {
     self.offlineIcon.hidden = false
    }
    
        
        self.nameLabel.text = cameraInfo.cameraName
  
    self.icon.sd_setImageWithURL(NSURL(string: cameraInfo.picUrl))

    }
    func setModel(e:Equip){
    self.equip = e
    }

   
    @IBAction func tap(sender: AnyObject) {
        let alert  = UIAlertView(title: "请输入密码", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定","")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
    
 
    passWord = alert.textFieldAtIndex(0)
    passWord?.keyboardType = UIKeyboardType.NumbersAndPunctuation
    alert.show()
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
       if passWord?.text!.trimString() == ""
       {
        showMsg("密码")
        return
        }
        if buttonIndex == 1{
            let dic:NSDictionary = ["roomCode":self.equip!.roomCode,
                "deviceAddress":self.equip!.equipID,
                "nickName":self.equip!.name,
                "ico":"list_camera",
                "validationCode":passWord!.text!,
                "deviceType":"101",
                "deviceCode":"commonsxt"]
            BaseHttpService.sendRequestAccess(addEq_do, parameters:dic) { (response) -> () in
                print("获取用户信息=\(response)")
                self.equip!.hostDeviceCode = "commonsxt";
                self.equip!.num = self.passWord!.text!;
                self.equip!.saveEquip()
                EZOpenSDK.setValidateCode(self.equip!.num, forDeviceSerial: self.equip?.equipID)
                showMsg("添加成功")
            }
        }

    }
    

}
