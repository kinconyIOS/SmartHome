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
    @IBOutlet weak var imgUser: UIImageView!//用户头像
    @IBOutlet var tableView: UITableView!//
    var arr = ["一键报修","意见反馈","功能说明","关于我们","清除缓存","所有房间","所有设备"];
    let imgArr = [UIImage(imageLiteral: "Tools.png"),UIImage(imageLiteral: "Edit.png"),UIImage(imageLiteral: "List.png"),UIImage(imageLiteral: "User.png"),UIImage(imageLiteral: "Refresh.png"),UIImage(imageLiteral: "House.png"),UIImage(imageLiteral: "Power-Of.png"),]
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航栏透明
        self.navigationController?.navigationBarHidden=true

        self.imgUser.layer.cornerRadius=self.imgUser.frame.size.width*0.5; //设置为图片宽度的一半出来为圆形
        self.imgUser.layer.masksToBounds=true
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
    
    override func viewWillAppear(animated: Bool) {
        //隐藏导航栏
        self.navigationController?.navigationBarHidden=true
        //获取用户信息
        let parameters=["userCode":userCode]
        BaseHttpService .sendRequestAccess(GetUser, parameters:parameters) { (response) -> () in
            print("获取用户信息=\(response)")
            if (response["city"] as! String) == ""{
                self.City.text = " "
            }else{
                self.City.text = response["city"] as? String
            }
            if (response["signature"] as! String) == ""{
                self.Sign.text = "亲还没设置签名！"
            }else{
                self.Sign.text = response["signature"] as? String
            }
            if (response["userName"] as! String) == ""{
                self.Name.text = "亲还没设置名字！"
            }else{
                self.Name.text = response["userName"] as? String
            }
            if (response["userSex"] as! String) == ""{
                self.Sex.text = " "
            }else{
                if (response["userSex"] as? String) == "0"{
                    self.Sex.text = "男"
                }else if (response["userSex"] as? String) == "1"{
                    self.Sex.text = "女"
                }
                
            }
            //图片
            if (response["headPic"] as! String) == ""{
                
            }else{
                let str = imgUrl+(response["headPic"]as!String)
                self.imgUser?.sd_setImageWithURL(NSURL(string: str))
               // self.ImaName.setImage(self.imgView1?.image, forState: UIControlState.Normal)

                self.imgUser?.contentMode = UIViewContentMode.ScaleToFill
                //self.Sex.text = response["userSex"] as? String
            }
        }

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
            cell.textLabel?.text = arr[indexPath.row]
            cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            cell.imageView?.image = imgArr[indexPath.row]
            cell.textLabel?.textColor = UIColor.grayColor()
            
            return cell;
        }

    }
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section==0 && indexPath.row==0{
            return 62;
        }
        else{
            return 40;
        }
        
    }
 
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
        
        }else if indexPath.section == 1{
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
            case 4:
                //清除缓存
                let cachPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
                let num = FileManager().folderSizeAtPath(cachPath)
                
                let alert = UIAlertController(title: "提示", message: "缓存大小为\(String(format: "%.2f", num) )M确定要清理吗?", preferredStyle: UIAlertControllerStyle.Alert)
                
                let defaultAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default , handler: { (aa) -> Void in
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
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
                    })
                   
                })
                alert.addAction(defaultAction)
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: { (aaa) -> Void in
                    
                })
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
                break;
            default :
                break
                
            }

        }
        
    }
       //点击购物车
    func Shopping(but:UIButton){
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
