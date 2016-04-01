//
//  MineVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit

class MineVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet var Name: UILabel!//用户姓名
    @IBOutlet var Sign: UILabel!//用户签名
    @IBOutlet var City: UILabel!//用户城市
    @IBOutlet var Sex: UILabel!//用户性别
    @IBOutlet var ImaName: UIButton!//用户头像
    @IBOutlet var tableView: UITableView!//
    var arr = ["一键报修","一键反馈","功能说明","关于我们","清除缓存","所有房间","所有设备"];
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航栏透明
        self.navigationController?.navigationBarHidden=true

        tableView.delegate = self;
        tableView.dataSource = self;
        //修改用户信息
        //ImaName.addTarget(self, action: Selector("Modify:"), forControlEvents: UIControlEvents.TouchUpInside)
        //拉出cell
        tableView.registerNib(UINib(nibName:"PersonalCell", bundle: nil), forCellReuseIdentifier:"Percell")
        //修改用户信息
        xiugai.addTarget(self, action: Selector("Modify:"), forControlEvents: UIControlEvents.TouchUpInside)
        //隐藏多余分割线
        self.tableView.tableFooterView = UIView()
       //self.navigationItem.title =  NSLocalizedString("我的", comment: "");
        // Do any additional setup after loading the view.
    }
    //修改个人信息跳转界面
    @IBOutlet var xiugai: UIButton!
    func Modify(but:UIButton){
       // let indvc:IndividuaViewController = IndividuaViewController();
        //从xib拉去
        let indvc:IndividuaViewController=IndividuaViewController(nibName: "IndividuaViewController", bundle: nil)
        indvc.hidesBottomBarWhenPushed=true
        self.navigationController!.pushViewController(indvc, animated:true)
    }
    override func viewWillAppear(animated: Bool) {
        //隐藏导航栏
        self.navigationController?.navigationBarHidden=true
    }
    //返回几个分区
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {
            return 1
        }
        else{
            return arr.count;
        }
        
    }
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section==0 && indexPath.row==0{
//          PersonalCell 自定cell
            let cell:PersonalCell? = tableView.dequeueReusableCellWithIdentifier("Percell") as? PersonalCell
           cell!.ShoppingCart.addTarget(self, action: Selector("Shopping:"), forControlEvents: UIControlEvents.TouchUpInside )
            cell!.Collection .addTarget(self, action: Selector("Colle:"), forControlEvents: UIControlEvents.TouchUpInside)
            return cell!
        }
        else{
             let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"cell");
            //cell 箭头
             cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.textLabel?.text = arr[indexPath.row];
            return cell;
        }

    }
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section==0 && indexPath.row==0{
            return 78;
        }
        else{
            return 40;
        }
        
    }
    //分区头
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section==1{
            return " ";
        }
        return nil;
    }
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            //从xib拉出来
            let indvc:RepairViewController=RepairViewController(nibName: "RepairViewController", bundle: nil)
            indvc.hidesBottomBarWhenPushed=true
            self.navigationController!.pushViewController(indvc, animated:true)
            //界面跳转 不通过导航栏
            //self.presentViewController(indvc, animated: true, completion: nil)
            break;
        case 1:
            //从xib拉出来
            let indvc:FeedbackViewController=FeedbackViewController(nibName: "FeedbackViewController", bundle: nil)
            indvc.hidesBottomBarWhenPushed=true
            self.navigationController!.pushViewController(indvc, animated:true)
            break;
        default :
            break
            
        }
        
    }
    //点击购物车
    func Shopping(but:UIButton){
        
    }
    //点击收藏
    func Colle(but:UIButton){
    
    }
}
