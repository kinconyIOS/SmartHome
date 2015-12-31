//
//  SHChooseAlertView.swift
//  SmartHome
//
//  Created by kincony on 15/12/31.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class SHChooseAlertView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    var themeClolor = UIColor.grayColor()
    var dataSource = [String]()
    
    private var titleView: UIView?
    private var titleLabel: UILabel?
    private var cancleBtn: UIButton?
    private var confirmBtn: UIButton?
    private var alertView: UIView = UIView()
    private var background: UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
    private let pickerView = UIPickerView()
    
    var selectItem: String?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String?, dataSource: [String], cancleButtonTitle: String?, confirmButtonTitle: String?) {
        self.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        
        self.dataSource = dataSource
        self.selectItem = dataSource.first
        
        
        self.backgroundColor = UIColor.clearColor()
        background.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        background.addSubview(alertView)
        alertView.backgroundColor = UIColor.whiteColor()
        switch UIDevice.currentDevice().orientation {
        case .LandscapeLeft, .LandscapeRight:
            alertView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.height * 0.77, UIScreen.mainScreen().bounds.height * 0.77 * 0.64)
        default:
            alertView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width * 0.77, UIScreen.mainScreen().bounds.width * 0.77 * 0.64)
        }
        alertView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
        
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

        cancleBtn = UIButton(type: UIButtonType.Custom)
        cancleBtn!.frame = CGRectMake(0, 0, alertView.frame.width * 0.24, alertView.frame.height * 0.215)
        cancleBtn?.backgroundColor = themeClolor
        if cancleButtonTitle != nil {
            cancleBtn!.setTitle(cancleButtonTitle, forState: UIControlState.Normal)
        } else {
            cancleBtn!.setTitle("取消", forState: UIControlState.Normal)
        }
        
        cancleBtn!.layer.cornerRadius = 4
        cancleBtn!.layer.masksToBounds = true
        cancleBtn!.titleLabel?.font = UIFont.systemFontOfSize(15)
        cancleBtn!.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        cancleBtn!.addTarget(self, action: Selector("touchButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        alertView.addSubview(cancleBtn!)
        
        confirmBtn = UIButton(type: UIButtonType.Custom)
        confirmBtn!.frame = CGRectMake(alertView.frame.width * 0.76, 0, alertView.frame.width * 0.24, alertView.frame.height * 0.215)
        confirmBtn?.backgroundColor = themeClolor
        
        if confirmButtonTitle != nil {
            confirmBtn!.setTitle(confirmButtonTitle, forState: UIControlState.Normal)
        } else {
            confirmBtn!.setTitle("确定", forState: UIControlState.Normal)
        }
        confirmBtn!.layer.cornerRadius = 4
        confirmBtn!.layer.masksToBounds = true
        confirmBtn!.titleLabel?.font = UIFont.systemFontOfSize(15)
        confirmBtn!.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        confirmBtn!.addTarget(self, action: Selector("touchButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        alertView.addSubview(confirmBtn!)
        
        pickerView.frame = CGRectMake(0, alertView.frame.height * 0.215, alertView.frame.width, alertView.frame.height * 0.785)
        pickerView.delegate = self
        pickerView.dataSource = self
        alertView.addSubview(pickerView)
        
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
    
    private var action: ((alert: SHChooseAlertView, buttonIndex: Int) -> ())?
    
    func alertAction(action: ((alert: SHChooseAlertView, buttonIndex: Int) -> ())) {
        self.action = action
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectItem = dataSource[row]
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    func show() {
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 2
        animation.toValue = 1
        animation.duration = 0.125
        self.layer.addAnimation(animation, forKey: "show")
        
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        background.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        switch UIDevice.currentDevice().orientation {
        case .LandscapeLeft, .LandscapeRight:
            alertView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.height * 0.77, UIScreen.mainScreen().bounds.height * 0.77 * 0.64)
        default:
            alertView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width * 0.77, UIScreen.mainScreen().bounds.width * 0.77 * 0.64)
        }
        alertView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
        
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
