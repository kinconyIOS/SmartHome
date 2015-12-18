//
//  FloorCell.swift
//  SmartHome
//
//  Created by sunzl on 15/12/18.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    var editView: EditView?
    @IBOutlet var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
        let frame = CGRectMake(ScreenWidth, 0, self.frame.height / 4 * 3, self.frame.height)
        editView = EditView(frame: frame)
        self.contentView.addSubview(editView!)
        
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.addGestureRecognizer(rightSwipe)
        
    }
    
    var longPressAction: (() -> ())?
    
    func handleLongPress(longPress: UILongPressGestureRecognizer) {
        print("long")
        longPressAction?()
    }
    
    func handleSwipe(swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case UISwipeGestureRecognizerDirection.Left:
           
            let nowCenter = self.bgView.center
             print(nowCenter.x)
            if nowCenter.x == self.frame.size.width/2{
                UIView.animateWithDuration(0.3, animations: { [unowned self] () -> Void in
                    self.bgView.center = CGPointMake(self.frame.size.width/2 - self.editView!.frame.size.width, nowCenter.y)
                    self.editView!.center = CGPointMake(self.frame.size.width - self.editView!.frame.size.width / 2, nowCenter.y)
                    })
            }
        case UISwipeGestureRecognizerDirection.Right:
           
           let nowCenter = self.bgView.center
            print(nowCenter.x)
            if nowCenter.x == self.frame.size.width / 2 - self.editView!.frame.width {
                UIView.animateWithDuration(0.3, animations: { [unowned self] () -> Void in
                    self.bgView.center = CGPointMake(self.frame.size.width / 2, nowCenter.y)
                    self.editView!.center = CGPointMake(self.frame.size.width + self.editView!.frame.size.width / 2, nowCenter.y)
                    })
            }
        default:
            break
        }
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
