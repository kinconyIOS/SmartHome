//
//  CameraCell.swift
//  SmartHome
//
//  Created by sunzl on 16/4/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class CameraCell: UICollectionViewCell {
    @IBOutlet var offlineIcon: UIImageView!

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setCameraInfo(cameraInfo:EZCameraInfo)
    {
    
    
    if (cameraInfo.isOnline)
    {
     self.offlineIcon.hidden = true
    }
    else
    {
     self.offlineIcon.hidden = false
    }
    
        
        self.nameLabel.text = cameraInfo.cameraName
  
    self.icon.sd_setImageWithURL(NSURL(string: cameraInfo.picUrl))

    }

}
