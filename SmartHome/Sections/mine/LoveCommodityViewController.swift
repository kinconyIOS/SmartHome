//
//  LoveCommodityViewController.swift
//  SmartHome
//
//  Created by Komlin on 16/4/6.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class LoveCommodityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var cell:CommodityTableViewCell?
    var strName:String!
    var commodity:CommodityTableViewCell!
    //收藏 数据源
    var love = []
    
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
            }
        
        self.tableView.reloadData()
    }
        self.navigationItem.titleView = segmented
        
        // Do any additional setup after loading the view.
    }
    //选择购物车 已购
    func Selectbutton(but:UISegmentedControl){
        if but.selectedSegmentIndex == 0{
            self.love=[]
            self.tableView.reloadData()
        print(0)
        }else {
        print(1)
            //----获取数据
            BaseHttpService .sendRequestAccess(Set_QueryShopping, parameters:["":""]) { (response) -> () in
                print(response)
                if response.count != 0{
                    self.love=(response as? NSArray)!
                }
                self.tableView.reloadData()
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
        return cell!

    }
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let view1:DetailsViewController=DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        view1.hidesBottomBarWhenPushed=true
        view1.coID = love[indexPath.row]["ids"]as!Int
        self.navigationController?.pushViewController(view1, animated: true)
        
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
                }
                else{
                    self.love = []
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
