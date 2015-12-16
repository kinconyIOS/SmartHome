//
//  EditView.swift
//  SmartHome
//
//  Created by kincony on 15/12/15.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class EditView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let label = UILabel(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        label.text = "编辑"
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(15)
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
        self.backgroundColor = UIColor(RGB: 0xfda074, alpha: 1)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
