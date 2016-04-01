//
//  IndividuaViewController.swift
//  SmartHome
//
//  Created by kincony on 16/3/29.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit

class IndividuaViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var tabArr = ["头像","名称","签名","修改性别"];
    var usreArr = ["haha","签名","男"]
    var cellArr = [OtherTableViewCell]()//存放cell
    var cellI:Int = 0
    @IBOutlet var walk: UIButton!
    @IBOutlet var tableView: UITableView!
    var cellImg:HeadImgTableViewCell?
    var cell:OtherTableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 6.0
        tableView.layer.masksToBounds = true
        tableView.dataSource = self;
        tableView.delegate = self;
        //显示导航栏
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.title = "个人信息"
        //拉出cell
        tableView.registerNib(UINib(nibName:"HeadImgTableViewCell", bundle: nil), forCellReuseIdentifier:"Head")
        tableView.registerNib(UINib(nibName:"OtherTableViewCell", bundle: nil), forCellReuseIdentifier:"Other")
        //退出事件
        walk.addTarget(self, action: Selector("tui:"), forControlEvents: UIControlEvents.TouchUpInside)
        // Do any additional setup after loading the view.
    }
    //退出登录
    func tui(but:UIButton){
        didSelectedEnter()
    }
    func didSelectedEnter(){
        
        let nav:UINavigationController = UINavigationController(rootViewController: LoginVC(nibName: "LoginVC", bundle: nil))
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.window!.rootViewController=nav
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //分区
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //节
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabArr.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section==0 && indexPath.row==0{
            //          PersonalCell 自定cell
             cellImg = tableView.dequeueReusableCellWithIdentifier("Head") as? HeadImgTableViewCell
            //cell 箭头
            cellImg!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cellImg?.HeadImg.image = UIImage(named: "我的头像")
            cellImg!.leab!.text = tabArr[indexPath.row]
            return cellImg!
        }
        else{
             cell = tableView.dequeueReusableCellWithIdentifier("Other") as? OtherTableViewCell
            //cell 箭头
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.information.text = usreArr[indexPath.row-1]
            cell!.leab!.text = tabArr[indexPath.row]
            cellArr.append(cell!)
            return cell!
        }

    }
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 60
    }
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles:"从相册选择", "拍照")
            actionSheet!.tag = 310;
            actionSheet?.showInView(self.tableView)
            break
        case 1:
            //从xib拉去
            let indvc:AlterViewController=AlterViewController(nibName: "AlterViewController", bundle: nil)
            indvc.alteText = "修改姓名";
            print(usreArr[indexPath.row-1])
            indvc.textName = usreArr[indexPath.row-1]
            cellI = 0
            //将当前someFunctionThatTakesAClosure函数指针传到第二个界面，第二个界面的闭包拿到该函数指针后会进行回调该函数
            indvc.myClosure = somsomeFunctionThatTakesAClosure
            self.navigationController!.pushViewController(indvc, animated:true)
            break
        case 2:
            //从xib拉去
            let indvc:AlterViewController=AlterViewController(nibName: "AlterViewController", bundle: nil)
            indvc.alteText = "修改签名";
            cellI = 1
            indvc.textName = usreArr[indexPath.row-1]
            //将当前someFunctionThatTakesAClosure函数指针传到第二个界面，第二个界面的闭包拿到该函数指针后会进行回调该函数
            indvc.myClosure = somsomeFunctionThatTakesAClosure
            self.navigationController!.pushViewController(indvc, animated:true)
            break
        case 3:
            let actionSheet:UIActionSheet? = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles:"男", "女")
            actionSheet!.tag = 320;
            actionSheet?.showInView(self.tableView)
            break
        default:
            break
        }
        
    }
    //闭包函数
    func somsomeFunctionThatTakesAClosure(string:String) -> Void{
        print(string)
        cellArr[cellI].leab?.text = string
    }
    //选择照片男女
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if actionSheet.tag == 310{
            if buttonIndex==1{
               self.LoaclPhoto()
            }else if buttonIndex==2{
               self.takePhoto()
            }
        }else if actionSheet.tag == 320{
            if buttonIndex==0{
                cell!.information.text = "男"
            }else if buttonIndex==1{
                cell!.information.text = "女"
            }
        }
    }

    //打开相机
    func takePhoto(a:Void){
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let picker: UIImagePickerController?=UIImagePickerController()
            picker!.delegate = self
            //设置拍照后的图片可被编辑
            picker?.allowsEditing = true
            picker?.sourceType = sourceType
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else{
            print("模拟机无法打开")
        }
    }
    //相册
    func LoaclPhoto(){
        let picker:UIImagePickerController?=UIImagePickerController()
        picker?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker?.delegate = self
        //设置选择后的图片可被编辑
        picker?.allowsEditing = true
        self.presentViewController(picker!, animated: true, completion: nil)
    }
    //获取图片
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        cellImg!.HeadImg.image = image;
        //dismissViewControllerAnimated:YES completion:nil
        self.dismissViewControllerAnimated(true, completion: nil)
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
