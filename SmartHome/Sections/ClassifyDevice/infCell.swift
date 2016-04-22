//
//  infCell.swift
//  SmartHome
//
//  Created by Komlin on 16/4/18.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class infCell: UICollectionViewCell ,UIActionSheetDelegate  {

    
    var inf:Infrared?
    //var model:<type>?
    //---------------
    //声明一个闭包
    var myClosure:callbackfunc?
    //块
    typealias callbackfunc = (Int)->()
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
    func completeBlock(chName:callbackfunc)->Void{
        
    }
    //--------------------
    var longPressGR:UILongPressGestureRecognizer?
    @IBOutlet weak var but: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        but.addTarget(self,action:Selector("tapped:"),forControlEvents:.TouchUpInside)
     
        // Initialization code
    }
    func addLongPass()
    {
        longPressGR = UILongPressGestureRecognizer(target: self, action: Selector("longPress:"))
        
        longPressGR!.minimumPressDuration = 0.5;
        self.addGestureRecognizer(longPressGR!)
    }
    
    //func setModel--- change view
    func setinf(inf:Infrared){
        self.inf = inf
        self.but.setTitle(inf.name, forState: UIControlState.Normal)
        self.but.titleLabel?.font = UIFont.systemFontOfSize(13.0)
    }
    
    
    func tapped(button:UIButton){
        print("aacc")
    }
    //按钮长按事件
    func longPress(sender:UILongPressGestureRecognizer){
        self.removeGestureRecognizer(sender)
        print("bbcc")
        // NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timer:"), userInfo: nil, repeats: false)
        
        let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles:"删除", "修改")
        actionSheet?.showInView(self.superview!)
    }
    
    //长按事件
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex{
        case 0:
            //取消
            break
        case 1:
            print(self.tag)
            self.myClosure?(self.tag)
            //删除
            break
        case 2:
            //修改
            break
        default:
            break
        }
        self.addGestureRecognizer(longPressGR!)
    }

}
