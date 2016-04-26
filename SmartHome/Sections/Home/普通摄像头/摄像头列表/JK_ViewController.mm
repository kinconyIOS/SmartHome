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

@end

@implementation JK_ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // _moblieDict = [[SockectManager defaultManager] readMobileFile];
        dataArray = [[NSMutableArray alloc] init];
           [self startSearch];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
{
    [dataArray removeAllObjects];
    [self stopSearch];
    
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
    for (HTCameras *c in dataArray) {
        if ( [c.ID isEqualToString:did] ) {
            isExist = YES;
            break;
        }
    }
    if (!isExist) {
        HTCameras *cameras=[HTCameras new];
        cameras.Name = @"admin";
        cameras.ID = did;
        cameras.deviceName = name;
        cameras.PassWord = @"hificat";
        cameras.deviceType = @"100";
        cameras.roomId =  @"";
         [dataArray addObject:cameras];
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
     HTCameras *cam4= [dataArray objectAtIndex:[indexPath row]];
    cam4.roomId = self.roomCode;
    [cell setModel:cam4];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    CameraVC *c = [CameraVC new];\
    c.cameraID = cam4.ID;
//    c.m_PPPPChannelMgt = nil;
//    c.username = cam4.Name;
//    c.password = cam4.PassWord;
     HTCameras *cam4= [dataArray objectAtIndex:[indexPath row]];
    HTPlayCamerViewController *playViewController = [[HTPlayCamerViewController alloc] initWithNibName:@"HTPlayCamerViewController" bundle:[NSBundle mainBundle]];
        
    playViewController.cameraID = cam4.ID;
    playViewController.m_PPPPChannelMgt = nil;
    playViewController.username = cam4.Name;
    playViewController.password = cam4.PassWord;
    
    [self.navigationController pushViewController:playViewController animated:YES];
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
