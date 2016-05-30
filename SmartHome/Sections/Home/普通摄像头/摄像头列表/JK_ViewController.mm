//
//  JK_ViewController.m
//  ZNJD2
//
//  Created by he on 14-7-19.
//
//

#import "JK_ViewController.h"
#import "JK_LineTableViewCell.h"

//#import "MonitorViewController.h"

#import "HTCameras.h"
#import "HTCameraStatus.h"

@interface JK_ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UITextField *deviceAddress;
@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UITextField *passWord;
@end

@implementation JK_ViewController
@synthesize dataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // _moblieDict = [[SockectManager defaultManager] readMobileFile];
        dataArray = [[NSMutableArray alloc]init];
    prefixDataArray = [[NSMutableArray alloc]init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *it =  [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addDeviceWithAddress)];
    self.navigationItem.rightBarButtonItems = @[it];
     [self startSearch];
}
-(void)addDeviceWithAddress
{


    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    _deviceAddress =[alert textFieldAtIndex:0];
    _deviceAddress.placeholder = @"ID";
   
    _passWord =[alert textFieldAtIndex:1];
    _passWord.placeholder = @"密码";
    _passWord.keyboardType =UIKeyboardTypeNumbersAndPunctuation;
    [alert show];
    
}
#pragma mark --UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 1:
        {
            NSDictionary *dict = @{@"roomCode":self.roomCode,
                                   @"deviceAddress":self.deviceAddress.text,
                                   @"nickName":self.userName.text,
                                   @"ico":@"list_camera",
                                   @"deviceType":@"100",
                                  @"validationCode":self.passWord.text,
                                   @"deviceCode":@"commonsxt"};
            __weak typeof(self) weakSelf = self;
            [BaseHttpService sendRequestAccess:@"http://114.55.89.143:8080/smarthome.IMCPlatform/xingUser/setDeviceInfo.action" parameters:dict success:^(id _Nonnull) {
                
                //摄像头里这个字段存的是账号 及密码
                // equip.icon = _userName.text;
                Equip *eq = [[Equip alloc]initWithEquipID:weakSelf.deviceAddress.text];
                eq.type = @"100";
                eq.name  = self.userName.text;
                eq.hostDeviceCode = @"commonsxt";
                eq.num = weakSelf.passWord.text;
                
                eq.roomCode = weakSelf.roomCode;
                [eq saveEquip];
                [[[UIAlertView alloc]initWithTitle:nil message:@"添加成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil]show];
                [weakSelf startSearch];
            }];
        }
            break;
            
        default:
            
            break;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
  //  [self.tabBarController.tabBar setHidden:NO];
 
    
}
- (void)handleTimer:(NSTimer *)timer{
    [self stopSearch];
    [self.tableView reloadData];
}

- (void) startSearch
{  [dataArray removeAllObjects];
    [prefixDataArray removeAllObjects];
    [self stopSearch];
    NSLog(@"-----%d",[DataWrapper getCameras].count)  ;
    [prefixDataArray addObjectsFromArray:[DataWrapper getCameras]];
    dvs = new CSearchDVS();
    dvs->searchResultDelegate = self;
    dvs->Open();
    
    //create the start timer
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
}
#pragma mark -
#pragma mark SearchCameraResultProtocol

- (void) SearchCameraResult:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString*)did{
    NSLog(@"name %@ did  %@",name, did);

    
    //剔除重复
   BOOL isExist = NO;
    
        for (Equip *e in prefixDataArray) {
            if ( [e.equipID isEqualToString:did] ) {
                isExist = YES;
                break;
            }
        }
   
   
    if (!isExist) {
       Equip *e=[[Equip alloc]initWithEquipID:did];
       // e.Name = @"admin";
        e.name = name;
        e.type = @"100";
        e.roomCode =  @"";
        [prefixDataArray addObject:e];
        [dataArray addObject:e];
    }
   
   
}
- (void) stopSearch
{
    if (dvs != NULL) {
        SAFE_DELETE(dvs);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"JK_LineTableViewCell";
    JK_LineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JK_LineTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    Equip *equip= [dataArray objectAtIndex:[indexPath row]];
    equip.roomCode = self.roomCode;
    [cell setModel:equip];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}

- (IBAction)doRightButtonAction:(UIButton *)sender {
//    MonitorViewController *moniVC = [[MonitorViewController alloc] init];
//    [self.navigationController pushViewController:moniVC animated:YES];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
@end
