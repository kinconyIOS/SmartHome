//
//  DetailsViewController.swift
//  SmartHome
//
//  Created by kincony on 16/3/31.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //商品图片cell
    var cellImg:CommodityImgTableViewCell?//商品图片
    var cellpara:ParameterTableViewCell?//商品参数
    var cellPrice:PriceTableViewCell?//商品价格
    var cellComment:CommentTableViewCell?//商品评级
    var cellpur:PurchaseTableViewCell?//购买
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //cell 初始化
        self.navigationItem.title = "商品详情"
        tableView.registerNib(UINib(nibName: "CommodityImgTableViewCell", bundle: nil), forCellReuseIdentifier: "CommodityImg")
        tableView.registerNib(UINib(nibName: "ParameterTableViewCell", bundle: nil), forCellReuseIdentifier: "Parameter")
        tableView.registerNib(UINib(nibName: "PriceTableViewCell", bundle: nil), forCellReuseIdentifier: "Price")
        tableView.registerNib(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "Comment")
        tableView.registerNib(UINib(nibName: "PurchaseTableViewCell", bundle: nil), forCellReuseIdentifier: "Purchase")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    //分区
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    //行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section{
            
        case 0:
            cellImg = tableView.dequeueReusableCellWithIdentifier("CommodityImg", forIndexPath: indexPath) as? CommodityImgTableViewCell
            return cellImg!
            
        case 1:
            cellpara =
                tableView.dequeueReusableCellWithIdentifier("Parameter", forIndexPath: indexPath) as? ParameterTableViewCell
            return cellpara!
            
        case 2:
            cellPrice = tableView.dequeueReusableCellWithIdentifier("Price", forIndexPath: indexPath) as? PriceTableViewCell
            return cellPrice!
        case 3:
            cellComment = tableView.dequeueReusableCellWithIdentifier("Comment", forIndexPath: indexPath) as? CommentTableViewCell
            return cellComment!
        case 4:
            cellpur = tableView.dequeueReusableCellWithIdentifier("Purchase", forIndexPath: indexPath) as? PurchaseTableViewCell
            return cellpur!
        default :
            return cellpara!
            
        }
    }
    //分区头
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section != 0 && section != 4{
            return nil
        }
        return nil
    }
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        switch indexPath.section{
            
        case 0:
            return 270
        case 1:
            return 305
        case 2:
            return 100
        case 3:
            return 120
        case 4:
            return 58
        default :
            return 0

            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
