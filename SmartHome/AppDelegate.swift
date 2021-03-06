//
//  AppDelegate.swift
//  SmartHome
//
//  Created by sunzl on 15/12/9.
//  Copyright © 2015年 sunzl. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
@UIApplicationMain

  class AppDelegate: UIResponder, UIApplicationDelegate{
   
    var window: UIWindow? = UIWindow.init(frame: UIScreen.mainScreen().bounds)
    var user:UserModel?=UserModel()
    var weather:WeatherModel?
    //定时器
    var i=0
    //个推
    var  deviceToken:NSString = ""
    var  gexinPusher:GexinSdk?
    var  clientId:NSString? = ""
    var  sdkStatus:SdkStatus?
    var  lastPayloadIndex:Int = 0
    var  payloadId:NSString? = ""
    //pgyer url
    var updateUrl:NSString = ""
    let EzvizAppKey = "4bdf5701dfaa4e18bd2abe901274ae17"
   
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window!.makeKeyAndVisible();
        dataDeal.creatUserTable()
        dataDeal.creatFloorTable()
        dataDeal.creatRoomTable()
        dataDeal.creatEquipTable()
        print(NSHomeDirectory())
        
     
    
        //第一次安装会走引导页
        let isNotFirst = NSUserDefaults.standardUserDefaults().objectForKey("isNotFirstComming")?.boolValue
        if isNotFirst == nil || isNotFirst == false {
        let guidevc:GuideViewController = GuideViewController(coverImageNames: ["引导页.jpg","引导页.jpg","引导页.jpg"], backgroundImageNames: nil)
            guidevc.didSelectedEnter=didSelectedEnter
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isNotFirstComming")
            self.window!.rootViewController = guidevc
        }else{
            
            //非第一次登陆，直接进入登陆界面
            secondLogin()
        }
        self.setUpErrorTest()
        self.registerRemoteNotification()
        
    
        self.startGeTuiSdk()
        
        EZOpenSDK.initLibWithAppKey(EzvizAppKey)
        //注册摄像头的序列号和验证码 可以不用输入
        EZOpenSDK.setValidateCode("BJLKLK", forDeviceSerial: "567350669")
        
       
        MyLocationManager.sharedManager().callback={(str:String!)in
            //天气预报 闭包回调
            weatherWithProvince("北京市", localCity:str) { (weather:WeatherModel) -> () in
                self.weather=weather
            }
        
        }
        MyLocationManager.sharedManager().configLocation()
        return true
        
        
    }
   
    func secondLogin(){
   
        let homevc:HomeVC=HomeVC(nibName: "HomeVC", bundle: nil)
        homevc.tabBarItem.title=NSLocalizedString("首页", comment: "")
        homevc.tabBarItem.image=homeIcon
        homevc.tabBarItem.selectedImage=homeIconSelected
        let homeNav:AutorotateNavC = AutorotateNavC(rootViewController: homevc)
        
        let setModelVC:SetModelVC=SetModelVC(nibName: "SetModelVC", bundle: nil)
        setModelVC.tabBarItem.title=NSLocalizedString("情景模式", comment: "")
        setModelVC.tabBarItem.image=modelIcon
        setModelVC.tabBarItem.selectedImage=modelIconSelected
        let setModelNav:UINavigationController = UINavigationController(rootViewController: setModelVC)
        
        let mallvc:MallVC=MallVC(nibName: "MallVC", bundle: nil)
        mallvc.tabBarItem.title=NSLocalizedString("商城", comment: "")
        mallvc.tabBarItem.image=mallIcon
        mallvc.tabBarItem.selectedImage=mallIconSelected
        let mallNav:UINavigationController = UINavigationController(rootViewController:mallvc)
        
        let minevc:MineVC=MineVC(nibName: "MineVC", bundle: nil)
        minevc.tabBarItem.title=NSLocalizedString("我的", comment: "")
        minevc.tabBarItem.image=mineIcon
        minevc.tabBarItem.selectedImage=mineIconSelected
        let mineNav:UINavigationController = UINavigationController(rootViewController: minevc)
        let tab=AutoTabC()
        tab.viewControllers=[homeNav,setModelNav,mallNav,mineNav];
        tab.tabBar.tintColor=mainColor
        
        self.window!.rootViewController = tab
          //  数据更新
        readRoomInfo {
            
            let localnum =  NSUserDefaults.standardUserDefaults().floatForKey("RoomInfoVersionNumber")
            print("当前的楼层信息版本号为:\(localnum)")
        }
    }
    func didSelectedEnter(){
        
        let nav:UINavigationController = UINavigationController(rootViewController: LoginVC(nibName: "LoginVC", bundle: nil))
        self.window!.rootViewController=nav
     
        print("完毕")
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
 
    



  


    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.konlin.SmartHome" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SmartHome", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

