//
//  EquipTableEquipCell.swift
//  SmartHome
//
//  Created by kincony on 16/1/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class EquipTableEquipCell: UITableViewCell {

    
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    var editView: EditView?
        
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let frame = CGRectMake(ScreenWidth, 0, self.contentView.frame.size.height / 4 * 3, self.contentView.frame.size.height)
//        editView = EditView(frame: frame)
//        let tap = UITapGestureRecognizer(target: self, action: Selector("handleEdit:"))
//        editView!.addGestureRecognizer(tap)
//        self.addSubview(editView!)
//        
//        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
//        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
//        self.addGestureRecognizer(leftSwipe)
//        
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
//        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
//        self.addGestureRecognizer(rightSwipe)
    }
    
    func handleEdit(tap: UITapGestureRecognizer) {
        
    }
    
    func handleSwipe(swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case UISwipeGestureRecognizerDirection.Left:
            print("left")
            let nowCenter = self.contentView.center
            if nowCenter.x == self.bounds.width / 2 {
                UIView.animateWithDuration(0.3, animations: { [unowned self] () -> Void in
                    self.contentView.center = CGPointMake(self.bounds.width / 2 - self.editView!.frame.size.width, nowCenter.y)
                    self.editView!.center = CGPointMake(ScreenWidth - self.editView!.frame.size.width / 2, nowCenter.y)
                    })
            }
        case UISwipeGestureRecognizerDirection.Right:
            print("right")
            let nowCenter = self.contentView.center
            if nowCenter.x == self.bounds.width / 2 - self.editView!.frame.size.width {
                UIView.animateWithDuration(0.3, animations: { [unowned self] () -> Void in
                    self.contentView.center = CGPointMake(self.bounds.width / 2, nowCenter.y)
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
