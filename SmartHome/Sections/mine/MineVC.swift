//
//  MineVC.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit


class MineVC: UIViewController ,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate{

    @IBOutlet var tableView: UITableView!//
    var arr = ["我的购物","我的房间","我的设备","一键报修","意见反馈"];
    var arr1 = ["功能说明","关于我们","清除缓存","主机管理"]
    let imgArr = [UIImage(imageLiteral: "car.png"),UIImage(imageLiteral: "House.png"),UIImage(imageLiteral: "Power-Of.png"),UIImage(imageLiteral: "Tools.png"),UIImage(imageLiteral: "Edit.png")]
    
    let imgArr1 = [UIImage(imageLiteral: "List.png"),UIImage(imageLiteral: "User.png"),UIImage(imageLiteral: "Refresh.png"),UIImage(imageLiteral: "fj.png")]
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航栏透明
        self.navigationController?.navigationBarHidden=true
        tableView.tableFooterView = UIView()
     
        tableView.delegate = self;
        tableView.dataSource = self;
        
        //修改用户信息
        //ImaName.addTarget(self, action: Selector("Modify:"), forControlEvents: UIControlEvents.TouchUpInside)
        //拉出cell
        tableView.registerNib(UINib(nibName:"PersonalCell", bundle: nil), forCellReuseIdentifier:"Percell")
        tableView.registerNib(UINib(nibName:"MyHeadCell", bundle: nil), forCellReuseIdentifier:"MyHeadCell")
     
        //隐藏多余分割线
        self.tableView.tableFooterView = UIView()
       //self.navigationItem.title =  NSLocalizedString("我的", comment: "");
        // Do any additional setup after loading the view.
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2{
            return " "
        }
        return nil
    }
    
    override func viewWillAppear(animated: Bool) {
        //隐藏导航栏
        self.navigationController?.navigationBarHidden=true
        //获取用户信息
        let parameters=["userCode":userCode]
        BaseHttpService .sendRequestAccess(GetUser, parameters:parameters) { (response) -> () in
            print("获取用户信息=\(response)")
            app.user = UserModel(dict: response as! [String:AnyObject])
            print(app.user?.userName)
            self.tableView.reloadData()
        }

    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tview = UIView()
        tview.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return tview
    }

    //返回几个分区
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3;
    }
    //分区头的高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2{
            return 10
        }
        return 0
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0  {
            return 1
        }
        else if section == 1{
            return arr.count
        }
        else{
            return arr1.count
        }
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
          if indexPath.section==0 && indexPath.row==0{
            
            let cell:MyHeadCell? = tableView.dequeueReusableCellWithIdentifier("MyHeadCell") as? MyHeadCell
            cell!.headImg.layer.cornerRadius=cell!.headImg.frame.size.width*0.5; //设置为图片宽度的一半出来为圆形
            cell!.headImg.layer.masksToBounds=true;
            if app.user?.userName != ""{
                cell?.name.text = app.user?.userName
            }
            if app.user?.userSex != ""{
                cell?.sex.text = app.user?.userSex
            }
            if app.user?.signature != ""{
              cell?.qianm.text = app.user?.signature
            }
            if app.user?.city != ""{
                cell?.ctiy.text = app.user?.city
            }
            
           
           
           
                let str = imgUrl+(app.user?.headPic)!
                cell!.headImg.sd_setImageWithURL(NSURL(string: str), placeholderImage: UIImage(imageLiteral: "我的头像") )
           
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!

        }else  if indexPath.section==1 {
//          PersonalCell 自定cell
//            let cell:PersonalCell? = tableView.dequeueReusableCellWithIdentifier("Percell") as? PersonalCell
//           cell!.ShoppingCart.addTarget(self, action: Selector("Shopping:"), forControlEvents: UIControlEvents.TouchUpInside )
//            cell!.Collection .addTarget(self, action: Selector("Colle:"), forControlEvents: UIControlEvents.TouchUpInside)
//             cell!.selectionStyle = UITableViewCellSelectionStyle.None
//            return cell!
            let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"cell");
            //cell 箭头
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.textLabel?.text = arr[indexPath.row]
            cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            cell.imageView?.image = imgArr[indexPath.row]
            cell.textLabel?.textColor = UIColor.grayColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(13.0)
            return cell;
        }
        else{
             let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"cell");
            //cell 箭头
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.textLabel?.text = arr1[indexPath.row]
            cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            cell.imageView?.image = imgArr1[indexPath.row]
            cell.textLabel?.textColor = UIColor.grayColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(13.0)
            return cell;
        }

    }
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section==0
        {
        return 133
        }
        if indexPath.section==1 && indexPath.row==0{
//            return 62;
            return 40;
        }
        else{
            return 40;
        }
        
    }
 
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
            let indvc:IndividuaViewController=IndividuaViewController(nibName: "IndividuaViewController", bundle: nil)
            indvc.hidesBottomBarWhenPushed=true
            self.navigationController!.pushViewController(indvc, animated:true)
        }else if indexPath.section == 2{
            switch indexPath.row{
            case 0:

                break;
            case 1:
                break;
            case 2:
                //清除缓存
                //清除缓存
                let cachPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
                let num = FileManager().folderSizeAtPath(cachPath)
                
                let alert = UIAlertView(title: "提示", message: "缓存大小为\(String(format: "%.2f", num) )M确定要清理吗?", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消")
                alert.tag = 1
                alert.show()
//                UIAlertController(title: "提示", message: "缓存大小为\(String(format: "%.2f", num) )M确定要清理吗?", preferredStyle: UIAlertControllerStyle.Alert)
//                
//                let defaultAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default , handler: { (aa) -> Void in
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
//                        let cachPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
//                        
//                        let files = NSFileManager.defaultManager().subpathsAtPath(cachPath )
//                        for p in files!{
//                            
//                            let path = (cachPath as NSString).stringByAppendingPathComponent(p)
//                            if NSFileManager.defaultManager().fileExistsAtPath(path){
//                                do{
//                                    try NSFileManager.defaultManager().removeItemAtPath(path)
//                                }catch let error as NSError {
//                                    print(error.localizedDescription)
//                                }
//                                
//                            }
//                            
//                        }
//                    })
//                    
//                })
//                alert.addAction(defaultAction)
//                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: { (aaa) -> Void in
//                    
//                })
//                alert.addAction(cancelAction)
//                self.presentViewController(alert, animated: true, completion: nil)
                break;
                //解绑主机
            case 3:
                let indvc = DeviceManagerVC()
                indvc.hidesBottomBarWhenPushed=true
                self.navigationController!.pushViewController(indvc, animated:true)
                break
            default :
                break
            }

        }else if indexPath.section == 1{
        
            switch indexPath.row{
            
            case 0:
                self.Shopping()
                break
            case 1:
                let creatHomeVC = CreatHomeViewController(nibName: "CreatHomeViewController", bundle: nil)
                creatHomeVC.isSimple = true
                creatHomeVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(creatHomeVC, animated: true)
                break
            case 2:
                let classifyVC = ClassifyHomeVC(nibName: "ClassifyHomeVC", bundle: nil)
                self.navigationController?.pushViewController(classifyVC, animated: true)
                break
            case 4:
                //从xib拉出来
                let indvc:FeedbackViewController=FeedbackViewController(nibName: "FeedbackViewController", bundle: nil)
                indvc.hidesBottomBarWhenPushed=true
                self.navigationController!.pushViewController(indvc, animated:true)
                
                break
            case 3:
                //从xib拉出来
                let indvc:RepairViewController=RepairViewController(nibName: "RepairViewController", bundle: nil)
                indvc.hidesBottomBarWhenPushed=true
                self.navigationController!.pushViewController(indvc, animated:true)
                //界面跳转 不通过导航栏
                //self.presentViewController(indvc, animated: true, completion: nil)
                break
            default :
                break
            }
        }
        
    }
    //清除缓存
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 1{
            if buttonIndex == 0{
                let cachPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
                let files = NSFileManager.defaultManager().subpathsAtPath(cachPath )
                for p in files!{
                    
                    let path = (cachPath as NSString).stringByAppendingPathComponent(p)
                    if NSFileManager.defaultManager().fileExistsAtPath(path){
                        do{
                            try NSFileManager.defaultManager().removeItemAtPath(path)
                        }catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }


    }
       //点击购物车
    func Shopping(){
        print("购物车")
        let Lview:LoveCommodityViewController = LoveCommodityViewController(nibName:"LoveCommodityViewController",bundle: nil)
        Lview.hidesBottomBarWhenPushed=true
        Lview.strName="购物车"
        self.navigationController!.pushViewController(Lview, animated: true)
    }
    //点击收藏
    func Colle(but:UIButton){
        print("收藏")
        let Lview:LoveCommodityViewController = LoveCommodityViewController(nibName:"LoveCommodityViewController",bundle: nil)
        Lview.hidesBottomBarWhenPushed=true
        Lview.strName="收藏"
        self.navigationController!.pushViewController(Lview, animated: true)
    }
}
