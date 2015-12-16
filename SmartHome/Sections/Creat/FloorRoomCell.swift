//
//  FloorRoomCell.swift
//  SmartHome
//
//  Created by kincony on 15/12/16.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class FloorRoomCell: UITableViewCell {

    @IBOutlet var roomLabel: UILabel!
    var editView: EditView?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let frame = CGRectMake(ScreenWidth, 0, self.frame.height / 4 * 3, self.frame.height)
        editView = EditView(frame: frame)
        self.contentView.addSubview(editView!)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPress:"))
        self.addGestureRecognizer(longPress)
        
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
            print("left")
            let nowCenter = roomLabel.center
            if nowCenter.x == ScreenWidth / 2 {
                UIView.animateWithDuration(0.3, animations: { [unowned self] () -> Void in
                    self.roomLabel.center = CGPointMake(ScreenWidth / 2 - self.editView!.frame.size.width, nowCenter.y)
                    self.editView!.center = CGPointMake(ScreenWidth - self.editView!.frame.size.width / 2, nowCenter.y)
                    })
            }
        case UISwipeGestureRecognizerDirection.Right:
            print("right")
            let nowCenter = roomLabel.center
            if nowCenter.x == ScreenWidth / 2 - self.editView!.frame.width {
                UIView.animateWithDuration(0.3, animations: { [unowned self] () -> Void in
                    self.roomLabel.center = CGPointMake(ScreenWidth / 2, nowCenter.y)
                    self.editView!.center = CGPointMake(ScreenWidth + self.editView!.frame.size.width / 2, nowCenter.y)
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
