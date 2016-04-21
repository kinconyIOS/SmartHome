//
//  MallVC.swift
//  SmartHome
//
//  Created by kincony on 16/3/31.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class MallVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var cell:CommodityTableViewCell?
    var cell1:CoTableViewCell?
    
    var refresh:UIRefreshControl?
     @IBOutlet var tableView: UITableView!
    var shoppingList=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.title = "智能商场"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //拉出cell
        tableView.registerNib(UINib(nibName:"CommodityTableViewCell", bundle: nil), forCellReuseIdentifier:"Commod")
        tableView.registerNib(UINib(nibName:"CoTableViewCell", bundle: nil), forCellReuseIdentifier:"CoTab")
        BaseHttpService .sendRequestAccess(Commodity_display, parameters:["":""]) { (response) -> () in
            print(response)
            self.shoppingList=response as! NSArray
            self.tableView.reloadData()
        }
        
        tableView.dataSource=self
        tableView.delegate=self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        //上拉刷新
        tableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            BaseHttpService .sendRequestAccess(Commodity_display, parameters:["":""]) { (response) -> () in
                print(response)
                self.shoppingList=response as! NSArray
                self.tableView.reloadData()
                self.tableView.header.endRefreshing();
            }
            
        }
        //下拉加载
        tableView.addLegendFooterWithRefreshingBlock { () -> Void in
            BaseHttpService .sendRequestAccess(Commodity_display, parameters:["":""]) { [unowned self](response) -> () in
                print(response)
                self.shoppingList=response as! NSArray
                self.tableView.reloadData()
                self.tableView.footer.endRefreshing();
            }
            
        }
    
        // Do any additional setup after loading the view.
    }
 

    //分区
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //节
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

         return shoppingList.count+1
    }
    //cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            cell1 = tableView.dequeueReusableCellWithIdentifier("CoTab", forIndexPath: indexPath) as? CoTableViewCell
            cell1?.but1.setBackgroundImage(UIImage(imageLiteral: "ty1.png"), forState: UIControlState.Normal)
            cell1?.but2.setBackgroundImage(UIImage(imageLiteral: "ty2.png"), forState: UIControlState.Normal)
            cell1?.but3.setBackgroundImage(UIImage(imageLiteral: "ty3.png"), forState: UIControlState.Normal)
            cell1?.but4.setBackgroundImage(UIImage(imageLiteral: "ty4.png"), forState: UIControlState.Normal)
            return cell1!
            
        }
        cell = tableView.dequeueReusableCellWithIdentifier("Commod") as? CommodityTableViewCell
        cell!.commodityImg.image = UIImage(named: "窗帘")
        for index1 in shoppingList{
            let str = imgUrl+(index1["picturesShow"]as!String)
            print("\(str)")
            cell?.commodityImg.sd_setImageWithURL(NSURL(string: str))
            cell?.commodityImg?.contentMode = UIViewContentMode.ScaleToFill
            cell?.commdityID = index1["id"]
//            if ((index1["salesVolumeDegree"] as? Int) != 0)
//            {
//                cell?.aaa.hidden = true
//            }
            if (index1["salesVolumeDegree"] as? String) != "0"{
                cell?.aaa.hidden = true
            }
            cell?.commdityIntroduce.text = index1["goodsIntroduce"] as? String
            cell?.commdityName.text = index1["goodsTitle"] as? String
            cell?.commdityPrice.text = index1["goodsPrice"] as? String
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
        }
        return cell!
    }
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 200
        }
        return 90
    }
//    //分区头
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return " "
//    }
    //cell点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let view1:DetailsViewController=DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        view1.hidesBottomBarWhenPushed=true
        let Id1 = shoppingList[indexPath.row-1]
        view1.coID = Id1["id"] as? String
        self.navigationController?.pushViewController(view1, animated: true)
    }
   

}
