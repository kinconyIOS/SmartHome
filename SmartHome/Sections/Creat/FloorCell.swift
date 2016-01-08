//
//  FloorCell.swift
//  SmartHome
//
//  Created by kincony on 15/12/25.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class FloorCell: UITableViewCell {

    @IBOutlet var floorName: UITextField!
    @IBOutlet var unfoldBtn: UIButton!
    var building: Building?
    var indexPath: NSIndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    private var unfoldBlock: ((isUnfold: Bool) -> ())?
    private var keyboardAdapt: ((index: NSIndexPath) -> ())?
    
    func configUnfoldBlock(block: (Bool) -> ()) {
        unfoldBlock = block
    }
    func configKeyboardAdpt(block: (index: NSIndexPath) -> ()) {
        keyboardAdapt = block
    }
    
    @IBAction func exitAction(sender: AnyObject) {
        
    }
    @IBAction func editingBeginAction(sender: UITextField) {
        keyboardAdapt?(index: indexPath!)
    }
    @IBAction func editingEnd(sender: UITextField) {
        building?.buildName = sender.text!
    }

    @IBAction func handleUnfold(sender: UIButton) {
        sender.selected = !sender.selected
        unfoldBlock?(isUnfold: sender.selected)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}