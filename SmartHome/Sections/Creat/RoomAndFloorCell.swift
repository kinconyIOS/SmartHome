//
//  RoomAndFloorCell.swift
//  SmartHome
//
//  Created by kincony on 15/12/10.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class RoomAndFloorCell: UITableViewCell {
    
    var creatType: CreatType? {
        didSet {
            if creatType == CreatType.CreatTypeRoom {
                let frame = CGRectMake(ScreenWidth, whiteView.frame.origin.y, whiteView.frame.size.height / 4 * 3, whiteView.frame.size.height)
                editView = EditView(frame: frame)
                let tap = UITapGestureRecognizer(target: self, action: Selector("handleEdit:"))
                editView?.addGestureRecognizer(tap)
                self.addSubview(editView!)
                
                let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
                leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
                self.addGestureRecognizer(leftSwipe)
                
                let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
                rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
                self.addGestureRecognizer(rightSwipe)
                
                accessoryImage.hidden = true
            } else {
                accessoryImage.hidden = false
            }

        }
    }
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var whiteView: UIView!
    @IBOutlet var accessoryImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let longPress = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPress:"))
        self.addGestureRecognizer(longPress)
        
    }
    
    var editView: EditView?
    
    var longPressAction: (() -> ())?
    
    func handleLongPress(longPress: UILongPressGestureRecognizer) {
        print("long")
        longPressAction?()
    }

    func handleSwipe(swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case UISwipeGestureRecognizerDirection.Left:
            print("left")
            let nowCenter = whiteView.center
            if nowCenter.x == ScreenWidth / 2 {
                UIView.animateWithDuration(0.3, animations: { [unowned self] () -> Void in
                    self.whiteView.center = CGPointMake(ScreenWidth / 2 - self.editView!.frame.size.width, nowCenter.y)
                    self.editView!.center = CGPointMake(ScreenWidth - self.editView!.frame.size.width / 2, nowCenter.y)
                    })
            }
        case UISwipeGestureRecognizerDirection.Right:
            print("right")
            let nowCenter = whiteView.center
            if nowCenter.x == ScreenWidth / 2 - self.editView!.frame.width {
                UIView.animateWithDuration(0.3, animations: { [unowned self] () -> Void in
                    self.whiteView.center = CGPointMake(ScreenWidth / 2, nowCenter.y)
                    self.editView!.center = CGPointMake(ScreenWidth + self.editView!.frame.size.width / 2, nowCenter.y)
                    })
            }
        default:
            break
        }
        
    }
    
    var handleEditAction: (() -> ())?
    
    func handleEdit(tap: UITapGestureRecognizer) {
        handleEditAction?()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
