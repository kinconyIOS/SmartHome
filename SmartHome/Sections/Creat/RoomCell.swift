//
//  RoomCell.swift
//  SmartHome
//
//  Created by kincony on 15/12/25.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class RoomCell: UITableViewCell {

    var building: Building?
    var indexPath: NSIndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let frame = CGRectMake(ScreenWidth, 0, self.contentView.frame.size.height / 4 * 3, self.contentView.frame.size.height)
        editView = EditView(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleEdit:"))
        editView!.addGestureRecognizer(tap)
        self.addSubview(editView!)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.addGestureRecognizer(rightSwipe)
    }
    
    @IBOutlet var roomName: UITextField!
    var editView: EditView?
    
    func handleSwipe(swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case UISwipeGestureRecognizerDirection.Left:
            print("left")
            let nowCenter = roomName.center
            if nowCenter.x == ScreenWidth / 2 {
                UIView.animateWithDuration(0.3, animations: { [unowned self] () -> Void in
                    self.roomName.center = CGPointMake(ScreenWidth / 2 - self.editView!.frame.size.width, nowCenter.y)
                    self.editView!.center = CGPointMake(ScreenWidth - self.editView!.frame.size.width / 2, nowCenter.y)
                    })
            }
        case UISwipeGestureRecognizerDirection.Right:
            print("right")
            let nowCenter = roomName.center
            if nowCenter.x == ScreenWidth / 2 - self.editView!.frame.width {
                UIView.animateWithDuration(0.3, animations: { [unowned self] () -> Void in
                    self.roomName.center = CGPointMake(ScreenWidth / 2, nowCenter.y)
                    self.editView!.center = CGPointMake(ScreenWidth + self.editView!.frame.size.width / 2, nowCenter.y)
                    })
            }
        default:
            break
        }
        
    }
    private var keyboardAdapt: ((index: NSIndexPath) -> ())?
    func configKeyboardAdpt(block: (index: NSIndexPath) -> ()) {
        keyboardAdapt = block
    }
    
    @IBAction func endEditingAction(sender: UITextField) {
        building?.buildName = sender.text!
    }
    
    @IBAction func exitAction(sender: UITextField) {
    }
    @IBAction func beginEditingAction(sender: UITextField) {
        keyboardAdapt?(index: indexPath!)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
