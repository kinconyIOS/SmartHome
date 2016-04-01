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
    var lastText:String?
    var indexPath: NSIndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    private var unfoldBlock: ((isUnfold: Bool) -> ())?
    private var keyboardAdapt: ((index: NSIndexPath) -> ())?
    private var endEditing: ((String) -> ())?
    
    func configUnfoldBlock(block: (Bool) -> ()) {
        unfoldBlock = block
    }
    func configKeyboardAdpt(block: (index: NSIndexPath) -> ()) {
        keyboardAdapt = block
    }
    func configEndEditing(block: (text: String) -> ()) {
        endEditing = block
    }
    
    @IBAction func exitAction(sender: AnyObject) {
        
    }
    @IBAction func editingBeginAction(sender: UITextField) {
        self.lastText = sender.text
        keyboardAdapt?(index: indexPath!)
    }
    @IBAction func editingEnd(sender: UITextField) {
        if sender.text?.trimString() == ""
        {
            sender.text = self.lastText
        }
        endEditing?(sender.text!)
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
