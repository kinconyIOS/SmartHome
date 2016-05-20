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
    var coID:Int?//商品ID
    var dic = Dictionary<String,AnyObject>()
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
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        print(coID)
        BaseHttpService .sendRequestAccess(Commdity_di, parameters:["id":coID!]) { (response) -> () in
            print("\(response)")
            self.dic = (response as! [String : AnyObject])
            self.tableView.reloadData()
        }
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
            cellImg!.configHeadView()
            cellImg!.myScorllView.web_images = [NSURL(string: "")!,NSURL(string: "")!]
            cellImg!.myScorllView.images = [UIImage(named: "lb1")!,UIImage(named: "lb2")!]
            cellImg!.myScorllView.setupPage() // cellImg!.selectionStyle = UITableViewCellSelectionStyle.None
            return cellImg!
            
        case 1:
            cellpara =
                tableView.dequeueReusableCellWithIdentifier("Parameter", forIndexPath: indexPath) as? ParameterTableViewCell
            cellpara?.goodColor.text = dic["goodsColor"] as? String//颜色
            cellpara?.goodSize.text = dic["goodsSize"] as? String//规格
            cellpara?.workingVoltage.text = dic["workingVoltage"] as? String//电压
            cellpara?.powerConsunmption.text = dic["powerConsumption"] as? String//功率
            cellpara?.materialGood.text = dic["materialGoods"] as? String//材质
            cellpara?.commUnicatuinMode.text = dic["communicatuinMode"] as? String//通讯方式
            cellpara?.workingTemperature.text = dic["workingTemperature"] as? String//温度
            cellpara?.workingHumidity.text = dic["workingHumidity"] as? String//湿度
            
            cellpara!.selectionStyle = UITableViewCellSelectionStyle.None
            return cellpara!
            
        case 2:
            cellPrice = tableView.dequeueReusableCellWithIdentifier("Price", forIndexPath: indexPath) as? PriceTableViewCell
            cellPrice!.selectionStyle = UITableViewCellSelectionStyle.None
            cellPrice?.goodTitle.text = dic["goodsTitle"] as? String//名字
            cellPrice?.goodPrice.text = dic["goodsPrice"] as? String//价格
            return cellPrice!
        case 3:
            cellComment = tableView.dequeueReusableCellWithIdentifier("Comment", forIndexPath: indexPath) as? CommentTableViewCell
            
            cellComment!.selectionStyle = UITableViewCellSelectionStyle.None
            return cellComment!
        case 4:
            cellpur = tableView.dequeueReusableCellWithIdentifier("Purchase", forIndexPath: indexPath) as? PurchaseTableViewCell
            cellpur!.selectionStyle = UITableViewCellSelectionStyle.None
            cellpur?.but.addTarget(self, action: "pusView:", forControlEvents: UIControlEvents.TouchUpInside)
            return cellpur!
        default :
            return cellpur!
            
        }
    }
    func pusView(but:UIButton){
        let view1 = PurchaseViewController(nibName:"PurchaseViewController",bundle: nil)
        view1.coID.append((self.coID! as NSNumber).stringValue)
        if cellPrice?.goodPrice.text == nil{
            return
        }
        view1.mo = Float(cellPrice!.goodPrice.text!)
        self.navigationController?.pushViewController(view1, animated: true)
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
            return 240
        case 1:
            return 305
        case 2:
            return 90
        case 3:
            return 100
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
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.section )
        if indexPath.section == 3{
            let view:EvaluateViewController=EvaluateViewController(nibName: "EvaluateViewController", bundle: nil)
            view.hidesBottomBarWhenPushed=true
           // self.navigationController?.pushViewController(view, animated: true)
        }else if indexPath.section == 4{
            let view1 = PurchaseViewController(nibName:"PurchaseViewController",bundle: nil)
            view1.coID[0] = (self.coID! as NSNumber).stringValue
            view1.mo = Float(cellPrice!.goodPrice.text!)
            self.navigationController?.pushViewController(view1, animated: true)
            
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
