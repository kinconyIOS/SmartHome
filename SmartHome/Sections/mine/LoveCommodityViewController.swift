//
//  LoveCommodityViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/4/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class LoveCommodityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var JSView: UIView!
    @IBAction func jie(sender: AnyObject) {
        let view1 = PurchaseViewController(nibName:"PurchaseViewController",bundle: nil)
        // view1.coID[0] = (self.coID! as NSNumber).stringValue
        for var i = 0;i < self.love.count;++i{
            let mon=(self.love[i]["ids"] as? Int)
            view1.coID.append((mon! as NSNumber).stringValue)
        }
        view1.mo = Float(mone)
        self.navigationController?.pushViewController(view1, animated: true)
    }
    @IBOutlet weak var tableView: UITableView!
    var cell:CommodityTableViewCell?
    var strName:String!
    var commodity:CommodityTableViewCell!
    //收藏 数据源
    var love = []
    //显示钱数
    @IBOutlet weak var money: UILabel!
    var mone = 0.00
    @IBAction func jiesuan(sender: AnyObject) {
        
    }
    //判断点击已购 购物车
    var bool:Int = 1
    //结算按钮
    @IBOutlet weak var but: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
       // self.navigationItem.title = strName
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //cell
        tableView.registerNib(UINib(nibName: "CommodityTableViewCell", bundle: nil), forCellReuseIdentifier: "Commod")
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //添加segmented control
        let segmented = UISegmentedControl(frame:CGRectMake(80.0, 8.0, 200.0, 30.0))
        segmented.insertSegmentWithTitle("已购", atIndex: 0, animated: true)
        segmented.insertSegmentWithTitle("购物车", atIndex: 1, animated: true)
        segmented.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        segmented.selectedSegmentIndex = 1
       // segmented.momentary = false
        segmented.multipleTouchEnabled = false
        segmented.addTarget(self, action: Selector("Selectbutton:"), forControlEvents:UIControlEvents.ValueChanged)
        
        //----获取数据
        BaseHttpService .sendRequestAccess(Set_QueryShopping, parameters:["":""]) { (response) -> () in
        print(response)
            if response.count != 0{
                self.love=(response as? NSArray)!
                self.but.setTitle("结算(\(self.love.count))", forState: UIControlState.Normal)
                
                for var i = 0;i < self.love.count;++i{
                    let mon=(self.love[i]["goodsPrice"] as? NSString)?.doubleValue
                    self.mone = mon! + self.mone
                    self.money.text=String(format: "%.2f", self.mone)
                }
            }
        
        self.tableView.reloadData()
    }
        self.navigationItem.titleView = segmented
        
        // Do any additional setup after loading the view.
    }
    //选择购物车 已购
    func Selectbutton(but:UISegmentedControl){
        if but.selectedSegmentIndex == 0{
            
            self.bool = 0
            self.JSView.hidden = true
            BaseHttpService .sendRequestAccess(Get_gainuserorder, parameters:["":""]) { (response) -> () in
                print(response)
                if response.count != 0{
                    self.love=(response as? NSArray)!
                    self.tableView.reloadData()
                }else{
                    self.love = []
                    self.tableView.reloadData()
                }
            }
        print(0)
        }else {
        print(1)
            //----获取数据
            self.bool = 1
            self.JSView.hidden = false
            BaseHttpService .sendRequestAccess(Set_QueryShopping, parameters:["":""]) { (response) -> () in
                print(response)
                if response.count != 0{
                    self.love=(response as? NSArray)!
                    self.but.setTitle("结算(\(self.love.count))", forState: UIControlState.Normal)
                    var mone = 0.00
                    for var i = 0;i < self.love.count;++i{
                        let mon=(self.love[i]["goodsPrice"] as? NSString)?.doubleValue
                        mone = mon! + mone
                        self.money.text=String(format: "%.1f", mone)
                    }
                    self.tableView.reloadData()
                }else{
                    self.love = []
                    self.tableView.reloadData()
                }
              
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.love.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCellWithIdentifier("Commod") as? CommodityTableViewCell
        if self.bool == 1{
            let str = imgUrl+(love[indexPath.row]["picturesShow"]as!String)
            print("\(str)")
            cell?.commodityImg.sd_setImageWithURL(NSURL(string: str))
            cell?.commodityImg?.contentMode = UIViewContentMode.ScaleToFill
            cell!.commdityID = love[indexPath.row]["id"] as!Int
            //            if ((index1["salesVolumeDegree"] as? Int) != 0)
            //            {
            //                cell?.aaa.hidden = true
            //            }
            if (love[indexPath.row]["salesVolumeDegree"] as? String) != "0"{
                cell?.aaa.hidden = true
            }
            cell?.commdityIntroduce.text = love[indexPath.row]["goodsIntroduce"] as? String
            cell?.commdityName.text = love[indexPath.row]["goodsTitle"] as? String
            cell?.commdityPrice.text = love[indexPath.row]["goodsPrice"] as? String
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell!.commdityFollow.hidden = true
            //cell?.myClosure = somsomeFunctionThatTakesAClosure
        }else{
            let str = imgUrl+(love[indexPath.row]["picturesShow"]as!String)
            print("\(str)")
            cell?.commodityImg.sd_setImageWithURL(NSURL(string: str))
            cell?.commodityImg?.contentMode = UIViewContentMode.ScaleToFill
            cell!.commdityID = love[indexPath.row]["orderId"] as!Int
            //            if ((index1["salesVolumeDegree"] as? Int) != 0)
            //            {
            //                cell?.aaa.hidden = true
            //            }
            cell?.aaa.hidden = true
            cell?.commdityIntroduce.text = love[indexPath.row]["goodsIntroduce"] as? String
            cell?.commdityName.text = love[indexPath.row]["goodsTitle"] as? String
            cell?.commdityPrice.text = love[indexPath.row]["tradeMoney"] as? String
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell!.commdityFollow.hidden = true
        }


        return cell!

    }
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if bool == 1{
            let view1:DetailsViewController=DetailsViewController(nibName: "DetailsViewController", bundle: nil)
            view1.hidesBottomBarWhenPushed=true
            view1.coID = love[indexPath.row]["ids"]as?Int
            self.navigationController?.pushViewController(view1, animated: true)
        }else{
            let view1 = OrderDetailsViewController(nibName:"OrderDetailsViewController",bundle: nil)
            view1.orderId = love[indexPath.row]["orderId"]as?Int
             self.navigationController?.pushViewController(view1, animated: true)
        }

        
        }
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 90
    }
    //删除
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        print(indexPath.row)
        let parameters = ["id":love[indexPath.row]["id"]as!Int]
        //删除数据
        BaseHttpService .sendRequestAccess(Dele_shopoing, parameters:parameters) {
            (response) -> () in
            print(response)
            //----获取数据
            BaseHttpService .sendRequestAccess(Set_QueryShopping, parameters:["":""]) { (response) -> () in
                print(response)
                if response.count != 0{
                    self.love=(response as? NSArray)!
                    self.but.setTitle("结算(\(self.love.count))", forState: UIControlState.Normal)
                    self.mone = 0.00
                    for var i = 0;i < self.love.count;++i{
                        let mon=(self.love[i]["goodsPrice"] as? NSString)?.doubleValue
                        self.mone = mon! + self.mone
                        self.money.text=String(format: "%.2f", self.mone)
                    }
                }
                else{
                    self.love = []
                    self.but.setTitle("结算(\(self.love.count))", forState: UIControlState.Normal)
                    self.money.text = "0.0"
                }
                self.tableView.reloadData()
            }
        }
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
