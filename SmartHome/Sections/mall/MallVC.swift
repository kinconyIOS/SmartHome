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
    var shoppingList=NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
       
        //self.navigationController?.navigationBar.backgroundColor =  UIColor(patternImage: navBgImage!)
        self.navigationItem.title = "智能商场"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //拉出cell
        tableView.registerNib(UINib(nibName:"CommodityTableViewCell", bundle: nil), forCellReuseIdentifier:"Commod")
        tableView.registerNib(UINib(nibName:"CoTableViewCell", bundle: nil), forCellReuseIdentifier:"CoTab")
        BaseHttpService .sendRequestAccess(Commodity_display, parameters:["":""]) { (response) -> () in
            print(response)
             self.shoppingList=NSMutableArray(array: (response as! NSArray))
            self.tableView.reloadData()
        }
        
        tableView.dataSource=self
        tableView.delegate=self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        //上拉刷新
        tableView.addLegendHeaderWithRefreshingBlock { () -> Void in

            BaseHttpService .sendRequestAccess(Commodity_display, parameters:["":""]) { [unowned self](response) -> () in
                print(response)
                  self.shoppingList=NSMutableArray(array: (response as! NSArray))
                self.tableView.reloadData()
               // self.tableView.header.endRefreshing();
            }
            self.tableView.header.endRefreshing();
        }
        //下拉加载
        tableView.addLegendFooterWithRefreshingBlock { () -> Void in
            BaseHttpService .sendRequestAccess(Commodity_display, parameters:["":""]) { [unowned self](response) -> () in
                print(response)
                self.shoppingList=NSMutableArray(array: (response as! NSArray))
                print(self.shoppingList)
                self.tableView.reloadData()
                //self.tableView.footer.endRefreshing();
            }
            self.tableView.footer.endRefreshing();
            
        }

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden  = false
        //        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
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
       // let model:Model=shoppingList[indexPath.row-1];
        //cell.setModel(model)
            cell = tableView.dequeueReusableCellWithIdentifier("Commod") as? CommodityTableViewCell
            let str = imgUrl+(shoppingList[indexPath.row-1]["picturesShow"]as!String)
            print("\(str)")
            cell?.commodityImg.sd_setImageWithURL(NSURL(string: str))
            cell?.commodityImg?.contentMode = UIViewContentMode.ScaleToFill
            cell!.commdityID = shoppingList[indexPath.row-1]["id"] as!Int
//            if ((index1["salesVolumeDegree"] as? Int) != 0)
//            {
//                cell?.aaa.hidden = true
//            }
            if (shoppingList[indexPath.row-1]["salesVolumeDegree"] as? String) != "0"{
                cell?.aaa.hidden = true
            }
            cell?.commdityIntroduce.text = shoppingList[indexPath.row-1]["goodsIntroduce"] as? String
         cell?.commdityName.text = shoppingList[indexPath.row-1]["goodsTitle"] as? String
            cell?.commdityPrice.text = shoppingList[indexPath.row-1]["goodsPrice"] as? String
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.myClosure = somsomeFunctionThatTakesAClosure
        return cell!
    }
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 200
        }
        return 90
    }
    //收藏
    //闭包函数
    func somsomeFunctionThatTakesAClosure(string:Int) -> Void{
        print(string)
        let parameters=["id":string]
        BaseHttpService .sendRequestAccess(Add_Shopping, parameters:parameters) { (response) -> () in
            print(response)
        }
    }
        //分区头
//        func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//            return " "
//        }
//    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return indexPath.row > 0;
//    }
//
//    //cell点击事件
//    //单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
//    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
//       
//        return UITableViewCellEditingStyle(rawValue:UITableViewCellEditingStyle.Delete.rawValue)!
//    }
//    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
//        let fromRow = sourceIndexPath.row;
//        //    获取移动某处的位置
//        let toRow = destinationIndexPath.row;
//        //    从数组中读取需要移动行的数据
//        let object = shoppingList[fromRow-1];
//        //    在数组中移动需要移动的行的数据
//        shoppingList.removeObjectAtIndex(fromRow-1)
//        shoppingList.insertObject(object, atIndex: toRow-1)
//        //    把需要移动的单元格数据在数组中，移动到想要移动的数据前面
//        self.tableView .reloadData()
//      
//    }
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Delete
//        {
//            let fromRow = indexPath.row;
//           
//            //    在数组中移动需要移动的行的数据
//            shoppingList.removeObjectAtIndex(fromRow-1)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
//            self.tableView .reloadData()
//        }
//    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
  //     tableView.setEditing(true, animated: true)
  
        if indexPath.row != 0{
            let view1:DetailsViewController=DetailsViewController(nibName: "DetailsViewController", bundle: nil)
            view1.hidesBottomBarWhenPushed=true
            let Id1 = shoppingList[indexPath.row-1]
            view1.coID = Id1["id"] as? Int
            self.navigationController?.pushViewController(view1, animated: true)
        }
    }
}
