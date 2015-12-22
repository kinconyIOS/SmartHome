//
//  SHAlertView.swift
//  SHAlertView
//
//  Created by kincony on 15/12/17.
//  Copyright © 2015年 Kincony. All rights reserved.
//

import UIKit


let globalColor = UIColor.greenColor()

let l_ScreenWidth = UIScreen.mainScreen().bounds.size.width
let l_ScreenHeight = UIScreen.mainScreen().bounds.size.height

class SHAlertView: UIView {
    private var titleView: UIView?
    private var titleLabel: UILabel?
    private var detailLabel: UILabel?
    private var cancleBtn: UIButton?
    private var confirmBtn: UIButton?
    
    private var alertView: UIView = UIView(frame: CGRectMake(0, 0, l_ScreenWidth * 0.77, l_ScreenWidth * 0.77 * 0.64))
    private var background: UIView = UIView(frame: CGRectMake(0, 0, l_ScreenWidth, l_ScreenHeight))
    
    
    convenience init(title: String?, message: String?, cancleButtonTitle: String?, confirmButtonTitle: String?) {
        self.init(frame: CGRectMake(0, 0, l_ScreenWidth, l_ScreenHeight))
        
        self.backgroundColor = UIColor.clearColor()
        
        background.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        background.addSubview(alertView)
        
        alertView.backgroundColor = UIColor.whiteColor()
        alertView.center = CGPointMake(l_ScreenWidth / 2, l_ScreenHeight / 2)
        titleView = UIView(frame: CGRectMake(0, 0, alertView.frame.width, alertView.frame.height * 0.234))
        titleView!.tag = 477
        titleView!.backgroundColor = globalColor
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
        cancleBtn?.backgroundColor = globalColor
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
        confirmBtn?.backgroundColor = globalColor
        
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
    
    
    func touchButton(sender: UIButton) {
        if sender == cancleBtn {
            dismiss()
            action?(alert: self, buttonIndex: 0)
        } else if sender == confirmBtn {
            action?(alert: self, buttonIndex: 1)
        }
    }
    
    private var action: ((alert: SHAlertView, buttonIndex: Int) -> ())?
    
    func alertAction(action: ((alert: SHAlertView, buttonIndex: Int) -> ())) {
        self.action = action
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    func show() {
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = [1.5, 1.5, 2]
        animation.toValue = [1, 1, 1]
        animation.duration = 0.125
        background.layer.addAnimation(animation, forKey: "show")
        
    }
    
    
}
