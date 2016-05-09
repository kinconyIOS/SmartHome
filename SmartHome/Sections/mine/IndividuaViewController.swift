//
//  IndividuaViewController.swift
//  SmartHome
//
//  Created by kincony on 16/3/29.
//  Copyright © 2016年 sunzl. All rights reserved.
//

import UIKit
import Alamofire
class IndividuaViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var tabArr = ["头像","名称","签名","修改性别","选择城市"];
    var usreArr = [" "," "," "," "]
    var sunData:SunDataPicker? = SunDataPicker.init(frame: CGRectMake(0, 100,ScreenWidth-20 , (ScreenWidth-20)*3/3))
    var cellArr = [OtherTableViewCell]()//存放cell
    var cellI:Int = 0
    var curentImage:UIImage?//图片
    var city:String?//城市
    var sex:String?//男女
    var areas:NSDictionary?
    @IBOutlet var walk: UIButton!
    @IBOutlet var tableView: UITableView!
//    var cellImg:HeadImgTableViewCell?
//    var cell:OtherTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 6.0
        tableView.layer.masksToBounds = true
        tableView.dataSource = self;
        tableView.delegate = self;
        //选择学校界面初始化
        sunData?.title.text = "选择城市"
        //显示导航栏
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.title = "个人信息"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        // self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        
        //拉出cell
        tableView.registerNib(UINib(nibName:"HeadImgTableViewCell", bundle: nil), forCellReuseIdentifier:"Head")
        tableView.registerNib(UINib(nibName:"OtherTableViewCell", bundle: nil), forCellReuseIdentifier:"Other")
        //退出事件
        walk.addTarget(self, action: Selector("tui:"), forControlEvents: UIControlEvents.TouchUpInside)
        // Do any additional setup after loading the view.
        
        
    }
    //拖拽手势取消
    
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
         let  cellImg = tableView.dequeueReusableCellWithIdentifier("Head") as? HeadImgTableViewCell
            //cell 箭头
            cellImg!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cellImg?.HeadImg.image = UIImage(named: "我的头像")
            cellImg!.HeadImg.contentMode = UIViewContentMode.ScaleToFill
            cellImg!.leab!.text = tabArr[indexPath.row]
            if self.curentImage != nil{
                //选择图片
            cellImg?.HeadImg.image = self.curentImage
            }else if app.user?.headPic != ""{
                if app.user?.headPic != nil{
                    let str = imgUrl+(app.user?.headPic)!
                    cellImg!.HeadImg.sd_setImageWithURL(NSURL(string: str))
                }
            
            }

            return cellImg!
        }
        else{
           
         let cell = tableView.dequeueReusableCellWithIdentifier("Other") as? OtherTableViewCell
            //cell 箭头
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//            cell!.information.text = usreArr[indexPath.row-1]
//            cell!.leab!.text = tabArr[indexPath.row]
           
            switch(indexPath.row){
            
            case 1:
                cell!.information.text = app.user?.userName
                if app.user?.userName != nil{
                    self.usreArr[0] = (app.user?.userName)!
                }
                cell?.leab.text = tabArr[indexPath.row]
                break
            case 2:
                cell!.information.text = app.user?.signature
                cell?.leab.text = tabArr[indexPath.row]
                if app.user?.userName != nil{
                    self.usreArr[1] = (app.user?.signature)!
                }
                break
            case 3:
                if self.sex != nil
                {
                    cell!.information.text = self.sex
                    cell?.leab.text = tabArr[indexPath.row]
                }else
                {
                     cell!.information.text = app.user?.userSex
                     cell?.leab.text = tabArr[indexPath.row]
                }
//                cell!.information.text = app.user?.userSex
//                cell?.leab.text = tabArr[indexPath.row]
                break
            case 4:
                if self.city != nil
                {
                    cell!.information.text = self.city
                    cell?.leab.text = tabArr[indexPath.row]
                }
                else
                {
                    cell!.information.text = app.user?.city
                    cell?.leab.text = tabArr[indexPath.row]
                }
               
                break
                //case sign
            default :
                break
            }
            cellArr.append(cell!)
            return cell!
        }
        
    }
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.row == 0   {return 96}
        return 48
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
            //[actionSheet showInView:[UIApplication sharedApplication].keyWindow]
            actionSheet?.showInView(self.view)
           // actionSheet?.showInView(self.tableView)
            break
        case 4:
            let path = NSBundle.mainBundle().pathForResource("mJson", ofType: "json")
            var jsonstr:String?
            do {
                jsonstr = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            } catch let error as NSError{
                print(error.localizedDescription)
            }
            let jsondata = jsonstr?.dataUsingEncoding(NSUTF8StringEncoding)
            do {
                self.areas = try NSJSONSerialization.JSONObjectWithData(jsondata! , options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            } catch let error as NSError{
                print(error.localizedDescription)
            }
            self.sunData?.setNumberOfComponents(3, SET: self.areas, addTarget:self.navigationController!.view , complete: { (one, two, three) -> Void in
                let a = "\(one),\(two),\(three)"
                print(a)
                print("\(two)")
                print("\(1)")
                let parameters=["city":a]
                BaseHttpService.sendRequestAccess(GetUserCity, parameters:parameters) { (response) -> () in
                    print(response)
                    //self.usreArr[3] = "\(two)-\(three)"
                   
                    self.city = "\(two)-\(three)"
                    self.tableView.reloadData()
                }
            })
            break
        default:
            break
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        //获取用户信息
        let parameters=["userCode":userCode]
        self.navigationController?.navigationBarHidden=false
        BaseHttpService .sendRequestAccess(GetUser, parameters:parameters) { (response) -> () in
            print("获取用户信息=\(response)")
            app.user = UserModel(dict: response as! [String:AnyObject])
            print(app.user?.userName)
             self.tableView.reloadData()

        }

       
    }
    //闭包函数
    func somsomeFunctionThatTakesAClosure(string:String) -> Void{
        print(string)
        cellArr[cellI].information?.text = string
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
                cellArr[2].information.text = "男"
                let parameters=["userSex":"男"]
                BaseHttpService.sendRequestAccess(GetUserSex, parameters:parameters) { (response) -> () in
                    print(response)
                    self.sex = "男"
                    self.tableView.reloadData()
                }
                
            }else if buttonIndex==1{
                cellArr[2].information.text = "女"
                let parameters=["userSex":"女"]
                BaseHttpService.sendRequestAccess(GetUserSex, parameters:parameters) { (response) -> () in
                    print(response)
                    self.sex = "女"
                    self.tableView.reloadData()
                }
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
        self.curentImage = image;
 
        self.tableView.reloadData()
        saveImage(image, imageName: "1236")
        //dismissViewControllerAnimated:YES completion:nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func saveImage(currentImage:UIImage,imageName:NSString){
        let imageData:NSData = UIImageJPEGRepresentation(currentImage, 0.5)!
  
        BaseHttpService.saveImageAccess(imageData) { (back) -> () in
            
        }
        
        //开始上传操作
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
