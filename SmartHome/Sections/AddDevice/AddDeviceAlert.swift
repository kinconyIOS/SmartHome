//
//  AddDeviceAlert.swift
//  SmartHome
//
//  Created by kincony on 15/12/23.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class AddDeviceAlert: UIView {

    var alertImage: UIImageView = UIImageView() {
        didSet {
            switch UIDevice.currentDevice().orientation {
            case .LandscapeLeft, .LandscapeRight:
                alertImage.frame = CGRectMake(ScreenWidth / 10 * 3, ScreenHeight * 0.3, ScreenWidth / 10 * 4, ScreenWidth / 10 * 4 * 0.65)
            default:
                alertImage.frame = CGRectMake(ScreenWidth / 7, ScreenHeight * 0.352, ScreenWidth / 7 * 5, ScreenWidth / 7 * 5 * 0.65)
            }
        }
    }
    
    var exitBtn: UIButton = UIButton(type: UIButtonType.Custom)
    
    convenience init(success: Bool) {
        self.init(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
        self.backgroundColor = UIColor(RGB: 0xb1b1b1, alpha: 0.4)
        switch UIDevice.currentDevice().orientation {
        case .LandscapeLeft, .LandscapeRight:
            alertImage.frame = CGRectMake(ScreenWidth / 10 * 3, ScreenHeight * 0.3, ScreenWidth / 10 * 4, ScreenWidth / 10 * 4 * 0.65)
        default:
            alertImage.frame = CGRectMake(ScreenWidth / 7, ScreenHeight * 0.352, ScreenWidth / 7 * 5, ScreenWidth / 7 * 5 * 0.65)
        }
        if success {
            alertImage.image = UIImage(named: "添加设备成功")
        } else {
            alertImage.image = UIImage(named: "添加设备失败")
        }
        alertImage.userInteractionEnabled = true
        exitBtn.frame = CGRectMake(alertImage.frame.size.width - 43, 2, 40, 40)
        exitBtn.setImage(UIImage(named: "添加设备提示X号普通"), forState: UIControlState.Normal)
        exitBtn.setImage(UIImage(named: "添加设备提示X号按下"), forState: UIControlState.Highlighted)
        exitBtn.addTarget(self, action: Selector("handleExit:"), forControlEvents: UIControlEvents.TouchUpInside)
        alertImage.addSubview(exitBtn)
        self.addSubview(alertImage)
    }
    
    func handleExit(sender: UIButton) {
        self.removeFromSuperview()
    }
    
    func show() {
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 2
        animation.toValue = 1
        animation.duration = 0.125
        animation.removedOnCompletion = true
        self.layer.addAnimation(animation, forKey: "show")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
         
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
        switch UIDevice.currentDevice().orientation {
        case .Portrait, .PortraitUpsideDown:
            alertImage.frame = CGRectMake(ScreenWidth / 7, ScreenHeight * 0.352, ScreenWidth / 7 * 5, ScreenWidth / 7 * 5 * 0.65)
            exitBtn.frame = CGRectMake(alertImage.frame.size.width - 43, 2, 40, 40)
        case .LandscapeLeft, .LandscapeRight:
            alertImage.frame = CGRectMake(ScreenWidth / 10 * 3, ScreenHeight * 0.3, ScreenWidth / 10 * 4, ScreenWidth / 10 * 4 * 0.65)
            exitBtn.frame = CGRectMake(alertImage.frame.size.width - 43, 2, 40, 40)
        default:
            break
        }
        
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
