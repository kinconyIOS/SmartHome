//
//  ModelCell.swift
//  SmartHome
//
//  Created by sunzl on 16/2/25.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class ModelCell: UICollectionViewCell,UIActionSheetDelegate {
    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    //model ID
    var modelID:String?
    //model
    var model = ChainModel()
    //手势长按
    lazy var longPressGR:UILongPressGestureRecognizer = {
         var long:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("longPress:"))
        return long
    }()
    func addLongPass()
    {
        
        longPressGR.minimumPressDuration = 0.5;
        self.addGestureRecognizer(longPressGR)
    }
    func removeLongPass()
    {
        self.removeGestureRecognizer(longPressGR)
    }
    func parentController()->UIViewController?
    {
        for (var next = self.superview; (next != nil); next = next!.superview) {
            let nextr = next?.nextResponder()
            if nextr!.isKindOfClass(HomeVC.classForCoder()){
                return (nextr as! UIViewController)
            }
            
        }
        return nil
    }
    //按钮长按事件
    func longPress(sender:UILongPressGestureRecognizer){
        self.removeGestureRecognizer(sender)
        print(self.tag)
        let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles:"编辑", "删除")
        actionSheet?.showInView(self.superview!)
    }
    
    //长按事件
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex{
        case 0:
            //取消
            break
        case 1:
            print("编辑1")
            let chainView = ChainEquipAddVC()
            chainView.hidesBottomBarWhenPushed=true
            chainView.model = self.model
           // chainView.model?.modelId = self.modelID!
            self.parentController()?.navigationController?.pushViewController(chainView, animated: true)
            print("编辑2")
            break
        case 2:
            print("删除")
            //删除 在查找 [unowned self]
            BaseHttpService .sendRequestAccess(Dele_deletemodel, parameters:["modelId":self.modelID!]) {[unowned self] (response) -> () in
                print(response)
                self.delegate?.DeleRefresh(self.modelID!)
            }
            break
        default:
            break
        }
        self.addGestureRecognizer(longPressGR)
    }
    //代理
    weak var delegate:DeleModels?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

protocol DeleModels:NSObjectProtocol{
    func DeleRefresh(modeleId:String)
}
