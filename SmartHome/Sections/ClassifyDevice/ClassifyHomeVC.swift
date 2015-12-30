//
//  ClassifyHomeVC.swift
//  SmartHome
//
//  Created by kincony on 15/12/30.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class ClassifyHomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var deviceSegement: SHSegement! {
        didSet {
            deviceSegement.leftLabel.text = "未分类"
            deviceSegement.rightLabel.text = "已分类"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(ScreenWidth / 3 - 1, ScreenWidth / 3 - 1)
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.registerNib(UINib(nibName: "EquipCollectionCell", bundle: nil), forCellWithReuseIdentifier: "equipcollectioncell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionView data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("equipcollectioncell", forIndexPath: indexPath)
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let equipSetVC = EquipSetVC(nibName: "EquipSetVC", bundle: nil)
        self.navigationController?.pushViewController(equipSetVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
