//
//  SHAlertView.swift
//  SHAlertView
//
//  Created by kincony on 15/12/17.
//  Copyright © 2015年 Kincony. All rights reserved.
//

import UIKit




var l_ScreenWidth: CGFloat {
    return UIScreen.mainScreen().bounds.width
}
var l_ScreenHeight: CGFloat {
    return UIScreen.mainScreen().bounds.height
}

class SHAlertView: UIView {
    
    var themeClolor: UIColor = UIColor.grayColor()
    
    private var titleView: UIView?
    private var titleLabel: UILabel?
    private var detailLabel: UILabel?
    private var cancleBtn: UIButton?
    private var confirmBtn: UIButton?
    
    private var alertView: UIView = UIView()
    private var background: UIView = UIView(frame: CGRectMake(0, 0, l_ScreenWidth, l_ScreenHeight))
    
    private override init(frame: CGRect) {
         super.init(frame: frame)
    }
    
    convenience init(title: String?, message: String?, cancleButtonTitle: String?, confirmButtonTitle: String?) {
        self.init(frame: CGRectMake(0, 0, l_ScreenWidth, l_ScreenHeight))
        
        self.backgroundColor = UIColor.clearColor()
        
        background.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        background.addSubview(alertView)
        
        alertView.backgroundColor = UIColor.whiteColor()
        
        switch UIDevice.currentDevice().orientation {
        case .LandscapeLeft, .LandscapeRight:
            alertView.frame = CGRectMake(0, 0, l_ScreenHeight * 0.77, l_ScreenHeight * 0.77 * 0.64)
        default:
            alertView.frame = CGRectMake(0, 0, l_ScreenWidth * 0.77, l_ScreenWidth * 0.77 * 0.64)
        }
         
        alertView.center = CGPointMake(l_ScreenWidth / 2, l_ScreenHeight / 2)
        titleView = UIView(frame: CGRectMake(0, 0, alertView.frame.width, alertView.frame.height * 0.234))
        titleView!.tag = 477
        titleView!.backgroundColor = themeClolor
        titleLabel = UILabel(frame: CGRectMake(15, 2, titleView!.frame.width - 30, titleView!.frame.height - 4))
        titleLabel!.tag = 477
        titleLabel!.textAlignment = NSTextAlignment.Center
        titleLabel!.text = title
        titleLabel!.font = UIFont.systemFontOfSize(20)
        titleLabel!.textColor = UIColor.whiteColor()
        titleView!.addSubview(titleLabel!)
        alertView.addSubview(titleView!)
        
        detailLabel = UILabel(frame: CGRectMake(alertView.frame.width * 0.05, alertView.frame.height * 0.281, alertView.frame.width * 0.9, alertView.frame.height * 0.390))
        detailLabel!.tag = 478
        detailLabel!.textAlignment = NSTextAlignment.Center
        detailLabel!.text = message
        detailLabel!.font = UIFont.systemFontOfSize(17)
        detailLabel!.textColor = UIColor.lightGrayColor()
        alertView.addSubview(detailLabel!)
        
        cancleBtn = UIButton(type: UIButtonType.Custom)
        cancleBtn!.frame = CGRectMake(alertView.frame.width * 0.09, alertView.frame.height * 0.718, alertView.frame.width * 0.32, alertView.frame.height * 0.188)
        cancleBtn?.backgroundColor = themeClolor
        if cancleButtonTitle != nil {
            cancleBtn!.setTitle(cancleButtonTitle, forState: UIControlState.Normal)
        } else {
            cancleBtn!.setTitle("取消", forState: UIControlState.Normal)
        }
        
        cancleBtn!.layer.cornerRadius = 4
        cancleBtn!.layer.masksToBounds = true
        cancleBtn!.addTarget(self, action: Selector("touchButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        alertView.addSubview(cancleBtn!)
        
        confirmBtn = UIButton(type: UIButtonType.Custom)
        confirmBtn!.frame = CGRectMake(alertView.frame.width * 0.6, alertView.frame.height * 0.718, alertView.frame.width * 0.32, alertView.frame.height * 0.188)
        confirmBtn?.backgroundColor = themeClolor
        
        if confirmButtonTitle != nil {
            confirmBtn!.setTitle(confirmButtonTitle, forState: UIControlState.Normal)
        } else {
            confirmBtn!.setTitle("确定", forState: UIControlState.Normal)
        }
        confirmBtn!.layer.cornerRadius = 4
        confirmBtn!.layer.masksToBounds = true
        confirmBtn!.addTarget(self, action: Selector("touchButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        alertView.addSubview(confirmBtn!)
        
        
        self.addSubview(background)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func touchButton(sender: UIButton) {
        if sender == cancleBtn {
            dismiss()
            action?(alert: self, buttonIndex: 0)
        } else if sender == confirmBtn {
            action?(alert: self, buttonIndex: 1)
            dismiss()
        }
    }
    
    private var action: ((alert: SHAlertView, buttonIndex: Int) -> ())?
    
    func alertAction(action: ((alert: SHAlertView, buttonIndex: Int) -> ())) {
        self.action = action
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    func dismiss() {
        if self.superview != nil {
            self.removeFromSuperview()
        }
        
    }
    
    func show() {
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 2
        animation.toValue = 1
        animation.duration = 0.125
        background.layer.addAnimation(animation, forKey: "show")
        
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
        background.frame = CGRectMake(0, 0, l_ScreenWidth, l_ScreenHeight)
        switch UIDevice.currentDevice().orientation {
        case .LandscapeLeft, .LandscapeRight:
            alertView.frame = CGRectMake(0, 0, l_ScreenHeight * 0.77, l_ScreenHeight * 0.77 * 0.64)
        default:
            alertView.frame = CGRectMake(0, 0, l_ScreenWidth * 0.77, l_ScreenWidth * 0.77 * 0.64)
        }
        alertView.center = CGPointMake(l_ScreenWidth / 2, l_ScreenHeight / 2)
        titleView!.frame = CGRectMake(0, 0, alertView.frame.width, alertView.frame.height * 0.234)
        titleLabel!.frame = CGRectMake(15, 2, titleView!.frame.width - 30, titleView!.frame.height - 4)
        detailLabel!.frame = CGRectMake(alertView.frame.width * 0.05, alertView.frame.height * 0.281, alertView.frame.width * 0.9, alertView.frame.height * 0.390)
        cancleBtn!.frame = CGRectMake(alertView.frame.width * 0.09, alertView.frame.height * 0.718, alertView.frame.width * 0.32, alertView.frame.height * 0.188)
        confirmBtn!.frame = CGRectMake(alertView.frame.width * 0.6, alertView.frame.height * 0.718, alertView.frame.width * 0.32, alertView.frame.height * 0.188)
        
    }
    
}
