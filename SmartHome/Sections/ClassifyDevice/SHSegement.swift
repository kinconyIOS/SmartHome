//
//  SHSegement.swift
//  SmartHome
//
//  Created by kincony on 15/12/30.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class SHSegement: UIView {
    
    enum Click {
        case Left, Right
    }
    
    private let selectLayer = CALayer()
    private let separa = CALayer()
    
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    
    override func layoutSubviews() {
//        super.layoutSubviews()
        selectLayer.frame = CGRectMake(0, 0, self.bounds.width / 2 , self.bounds.height)
        selectLayer.backgroundColor = UIColor.whiteColor().CGColor
        self.layer.addSublayer(selectLayer)
        
        separa.frame = CGRectMake(self.bounds.width / 2, 0, 1, self.bounds.height)
        separa.backgroundColor = UIColor.grayColor().CGColor
        self.layer.addSublayer(separa)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        leftLabel.frame = CGRectMake(0, 0, self.bounds.width / 2, self.bounds.height)
        leftLabel.textAlignment = NSTextAlignment.Center
        leftLabel.textColor = UIColor.grayColor()
        self.addSubview(leftLabel)
        
        rightLabel.frame = CGRectMake(self.bounds.width / 2, 0, self.bounds.width / 2, self.bounds.height)
        rightLabel.textAlignment = NSTextAlignment.Center
        rightLabel.textColor = UIColor.grayColor()
        self.addSubview(rightLabel)
        
    }

    private var leftAction: (()->())?
    private var rightAction: (()->())?
    
    func selectAction(click: Click, action: ()->()) {
        switch click {
        case .Left:
            leftAction = action
        case .Right:
            rightAction = action
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        let touch = touches.first
        let point = touch?.locationInView(self)
        if point?.x < self.bounds.width / 2 {
            selectLayer.frame = CGRectMake(0, 0, frame.width / 2, frame.height)
            leftAction?()
        } else {
            selectLayer.frame = CGRectMake(frame.width / 2, 0, frame.width / 2, frame.height)
            rightAction?()
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
