//
//  OrderDetailsViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/5/4.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var orderImg:OrderImgTableViewCell?
    var orderUser:OrderUserTableViewCell?
    var commodity:CommodityTableViewCell!
    var orderNumber:OrderNumberTableViewCell?
    var orderId:Int?
    var orderDic:[String : NSObject]? = [String : NSObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "购买详情"
        //cell
        tableView.registerNib(UINib(nibName: "CommodityTableViewCell", bundle: nil), forCellReuseIdentifier: "Commod")
        tableView.registerNib(UINib(nibName: "OrderImgTableViewCell", bundle: nil), forCellReuseIdentifier: "img")
        tableView.registerNib(UINib(nibName: "OrderUserTableViewCell", bundle: nil), forCellReuseIdentifier: "user")
        tableView.registerNib(UINib(nibName: "OrderNumberTableViewCell", bundle: nil), forCellReuseIdentifier: "number")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        BaseHttpService .sendRequestAccess(Get_gainuserorderInfo, parameters:["orderId":orderId!]) { [unowned self](response) -> () in
            print(response)
            self.orderDic = response as? [String : NSObject]
            self.tableView.reloadData()
           
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            orderImg = tableView.dequeueReusableCellWithIdentifier("img") as? OrderImgTableViewCell
            orderImg?.img.contentMode = UIViewContentMode.ScaleAspectFill
            if orderDic!["orderState"] as? Int == 0{
                orderImg?.img.image = UIImage(imageLiteral: "wei.png")
            }else{
                orderImg?.img.image = UIImage(imageLiteral: "yi.png")
            }
            orderImg!.selectionStyle = UITableViewCellSelectionStyle.None
            return orderImg!
        case 1:
            orderNumber = tableView.dequeueReusableCellWithIdentifier("number") as? OrderNumberTableViewCell
            if orderDic!["tradeNo"] != nil{
                orderNumber?.number.text =  orderDic!["tradeNo"] as? String
            }
            
            orderNumber?.timer.text = orderDic!["paymentTime"] as? String
            orderNumber!.selectionStyle = UITableViewCellSelectionStyle.None
            return orderNumber!
        case 2:
            orderUser = tableView.dequeueReusableCellWithIdentifier("user") as? OrderUserTableViewCell
            orderUser?.name.text = orderDic!["recipentName"] as? String
            orderUser?.Phone.text = orderDic!["recipentPhone"] as? String
            if orderDic!["recipentAddress"] != nil{
            orderUser?.address.text = "收款地址：" + (orderDic!["recipentAddress"] as? String)!
            }
            orderUser!.selectionStyle = UITableViewCellSelectionStyle.None
            return orderUser!
        case 3:
            commodity = tableView.dequeueReusableCellWithIdentifier("Commod") as? CommodityTableViewCell
            var str = " "
            if orderDic!["picturesShow"] != nil{
                 str = imgUrl + (orderDic!["picturesShow"] as! String)
            }
            
            print("\(str)")
            commodity?.commodityImg.sd_setImageWithURL(NSURL(string: str))
            commodity?.commodityImg?.contentMode = UIViewContentMode.ScaleToFill
            commodity?.aaa.hidden = true
            commodity?.commdityIntroduce.text = orderDic!["goodsIntroduce"] as? String
            commodity?.commdityName.text = orderDic!["goodsTitle"] as? String
            commodity?.commdityPrice.text = orderDic!["tradeMoney"] as? String
            commodity!.selectionStyle = UITableViewCellSelectionStyle.None
            commodity!.commdityFollow.hidden = true
            return commodity
        default:
            return orderImg!
        }

    }
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 95
        }else if indexPath.row == 1{
            return 65
        }else if indexPath.row == 2{
            return 75
        }else if indexPath.row == 3{
            return 90
        }
        return 0
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
