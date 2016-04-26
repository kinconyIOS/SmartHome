//
//  HTPalyViewViewController.m
//  IPCam
//
//  Created by yaoyaodu on 13-6-17.
//  Copyright (c) 2013年 yaoyaodu. All rights reserved.
//

#import "HTPlayCamerViewController.h"
#include "MyAudioSession.h"
#include "APICommon.h"
#import "PPPPDefine.h"
#import "obj_common.h"
#import "UIImage+UIImageExtras.h"
#define EnterBackground    @"applicationDidEnterBackground" 
//应用程序进入后台
@interface HTPlayCamerViewController ()
@property (nonatomic, retain) NSCondition* m_PPPPChannelMgtCondition;

@end

@implementation HTPlayCamerViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//       
//        // Custom initialization
//    }
//    return self;
//}


-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    self.navigationController.navigationBarHidden = NO;
   
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
       toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        self.navigationController.navigationBarHidden = YES;
     
    }
}



-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    UIImage* image =[self imageWithColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];

    //初始化文字
    [self.ContrastButton setTitle:NSLocalizedString(@"Contrast", nil) forState:UIControlStateNormal];
    [self.MirrorHoriButton setTitle:NSLocalizedString(@"MirrorHori", nil) forState:UIControlStateNormal];
    [self.MirrorVerButton setTitle:NSLocalizedString(@"MirrorVer", nil) forState:UIControlStateNormal];
    [self.BrightnessButton setTitle:NSLocalizedString(@"Brightness", nil) forState:UIControlStateNormal];
    [self.HD_Button setTitle:NSLocalizedString(@"HD", nil) forState:UIControlStateNormal];
    [self.SD_Button setTitle:NSLocalizedString(@"SD", nil) forState:UIControlStateNormal];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back:) name:EnterBackground object:nil];
    
    if (self.statusLabel.text.length == 0 && !self.m_PPPPChannelMgt) {
        [self.statusLabel setText:NSLocalizedString(@"cameraPrompt", @"")];
    }
    
    [self initslider];
    
    shezhi=1;
    mode=1;
    yushe=1;
    flog=-1;
    horizontal=YES;
    vertical=YES;
    //    [self hidebar:nil];
    [self performSelector:@selector(hidebar:) withObject:nil afterDelay:0.5];
    
    _setView.frame=CGRectMake(120, 44, 120, 160);
    [self.view addSubview:_setView];
    _yusheView.frame=CGRectMake(60, 44, 120, 196);
    [self.view addSubview:_yusheView];
    _modeView.frame=CGRectMake(self.view.frame.size.width-99, 44, 99, 118);
    [self.view addSubview:_modeView];

    [self.Toolbar1 setBackgroundImage:[UIImage imageNamed:@"bar.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.Toolbar2 setBackgroundImage:[UIImage imageNamed:@"bar.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    _audioImgOn = [[self fitImage:[UIImage imageNamed:@"audio"] tofitHeight:35] retain];
    _audioImgOff = [[self fitImage:[UIImage imageNamed:@"ptz_audio_off"] tofitHeight:35] retain];
    _talkImgOn = [[self fitImage:[UIImage imageNamed:@"micro_on"] tofitHeight:35] retain];
    _talkImgOff = [[self fitImage:[UIImage imageNamed:@"microphone_off"] tofitHeight:35] retain];
}
- (UIImage*) fitImage:(UIImage*)image tofitHeight:(CGFloat)height{
    CGSize imagesize = image.size;
    CGFloat scale = 0.0;
    if (imagesize.height > height) {
        scale = imagesize.height / height;
    }
    imagesize = CGSizeMake(imagesize.width/scale, height);
    UIGraphicsBeginImageContext(imagesize);
    [image drawInRect:CGRectMake(0, 0, imagesize.width, imagesize.height)];
    UIImage* newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    if (_m_PPPPChannelMgt == nil) {
        _m_PPPPChannelMgtCondition = [[NSCondition alloc] init];
        _m_PPPPChannelMgt = new CPPPPChannelManagement();
        _m_PPPPChannelMgt->pCameraViewController = self;
        [self Initialize:nil];
        [self ConnectCam:self.username psw:self.password];
    }
    else{
        [self starVideo:nil];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopVideo:nil];
    if (_m_PPPPChannelMgt == nil) {
        [self stopCamera:nil];
    }
}
-(void)initslider{
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *plistPath1 = [paths objectAtIndex:0];
//    NSString *filename = [plistPath1 stringByAppendingPathComponent:@"config.plist"];
//    
//    NSMutableDictionary *data2 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
//    if ([[data2 objectForKey:_cameraID] objectForKey:@"contrast"] == nil) {
//        self.contrastSlider.value = 127;
//    } else {
//        self.contrastSlider.value = [[[data2 objectForKey:_cameraID] objectForKey:@"contrast"] floatValue];
//    }
//    if ([[data2 objectForKey:_cameraID] objectForKey:@"lightness"] == nil) {
//        self.lightnessSlider.value = 0;
//    } else {
//        self.lightnessSlider.value =[[[data2 objectForKey:_cameraID] objectForKey:@"lightness"] floatValue];
//    }
}


- (IBAction)Initialize:(id)sender {
    PPPP_Initialize((char*)[@"EFGBFFBJKDJBGNJBEBGMFOEIHPNFHGNOGHFBBOCPAJJOLDLNDBAHCOOPGJLMJGLKAOMPLMDINEIOLMFAFCPJJGAM" UTF8String]);//Input your company server address
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);
}


- (void)ConnectCam:(NSString *)user psw:(NSString *)psw
{
    _m_PPPPChannelMgt->Start([_cameraID UTF8String], [user UTF8String], [psw UTF8String]);
}

- (IBAction)starVideo:(id)sender {
    if (_m_PPPPChannelMgt != NULL) {
        if (_m_PPPPChannelMgt->StartPPPPLivestream([_cameraID UTF8String], 10, self) == 0) {
            _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
            _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
            return;
        }
    }
}

- (IBAction)starAudio:(id)sender{
    _m_PPPPChannelMgt->StartPPPPAudio([_cameraID UTF8String]);
}

- (IBAction)stopVideo:(id)sender{
    _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
    _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
    dispatch_async(dispatch_get_main_queue(),^{
        _playView.image = nil;
    });
}

- (IBAction)stopAudio:(id)sender{
    _m_PPPPChannelMgt->Stop([_cameraID UTF8String]);
}

- (IBAction)stopCamera:(id)sender{
    [_m_PPPPChannelMgtCondition lock];
    if (_m_PPPPChannelMgt == NULL) {
        [_m_PPPPChannelMgtCondition unlock];
        return;
    }
    _m_PPPPChannelMgt->StopAll();
    [_m_PPPPChannelMgtCondition unlock];
    dispatch_async(dispatch_get_main_queue(),^{
        _playView.image = nil;
    });
    
}

// PPPPStatusDelegate
- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status{
    NSString* strPPPPStatus;
    switch (status) {
        case PPPP_STATUS_UNKNOWN:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_FAILED:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvaliduserpwd", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    dispatch_async(dispatch_get_main_queue(),^{
        self.statusLabel.text=strPPPPStatus;
        if (status==2) {
            [self performSelector:@selector(starVideo:) withObject:nil afterDelay:0.1];
        }
        //        if ([self.statusLabel.text isEqualToString:NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil)]) {
        //        }
        //        else
    });
}



//ImageNotifyProtocol
- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp DID:(NSString *)did{
    [self performSelector:@selector(refreshImage:) withObject:image];
}

- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did{
    
    UIImage* image = [APICommon YUV420ToImage:yuv width:width height:height];
    [self performSelector:@selector(refreshImage:) withObject:image];
    
}

- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp{
    
}

//refreshImage
- (void) refreshImage:(UIImage* ) image{
    if (image != nil) {
        dispatch_async(dispatch_get_main_queue(),^{
            _playView.image = image;
        });
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"yusheCell" owner:self options:nil];
        cell = self.yusheCell;
        self.yusheCell = nil;
    }
    UILabel *label;
    label=(UILabel *)[cell viewWithTag:2];
    label.text=[NSString stringWithFormat:@"%@%d",NSLocalizedString(@"yuShe", nil),row+1];
    UIButton *btn;
    btn=(UIButton *)[cell viewWithTag:3];
    btn.tag=row;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,                                                                          NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath2 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.png",_cameraID,row]];
    UIImage *img = [UIImage imageWithContentsOfFile:filePath2];
    UIImageView *image=(UIImageView *)[cell viewWithTag:1];
    if (img!=nil) {
        [image setImage:img];
    }
    
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 39;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_RUN0);
            break;
        case 1:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_RUN1);
            break;
        case 2:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_RUN2);
            break;
        case 3:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_RUN3);
            break;
        case 4:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_RUN4);
            break;
        default:
            break;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self stopVideo:nil];
        [self.navigationController popViewControllerAnimated:YES];
 
    
    if (_m_PPPPChannelMgt == nil) {
        [self stopCamera:nil];
        //        _m_PPPPChannelMgt->StopAll();
        //        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)hideView{
    _contrastSlider.hidden=YES;
    _lightnessSlider.hidden=YES;
    _setView.hidden=YES;
    _modeView.hidden=YES;
    _yusheView.hidden=YES;
}
- (IBAction)left_right:(id)sender {
    [self hideView];
    if (![self.left_rightButton.tintColor isEqual:[UIColor redColor]]) {
        [self.leftrightButton setImage:[UIImage imageNamed:@"ico3on.png"] forState:UIControlStateNormal];
        self.left_rightButton.tintColor=[UIColor redColor];
        _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_LEFT_RIGHT);
    }else{
        [self.leftrightButton setImage:[UIImage imageNamed:@"ico3.png"] forState:UIControlStateNormal];
        self.left_rightButton.tintColor=nil;
        _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_LEFT_RIGHT_STOP);
    }
}
- (void)dealloc {
      NSLog(@"视图销毁");
    [_playView release];
    [_left_rightButton release];
    [_up_downButton release];
    [_Toolbar1 release];
    [_Toolbar2 release];
    [_setView release];
    [_contrastSlider release];
    [_lightnessSlider release];
    [_modeView release];
    [_yusheView release];
    [_yusheCell release];
    [_tableView release];
    [_leftrightButton release];
    [_updownButton release];
    [_leftImage release];
    [_upImage release];
    [_downImage release];
    [_rightImage release];
    [_statusLabel release];
    [_yuShe release];
    [_ContrastButton release];
    [_BrightnessButton release];
    [_MirrorHoriButton release];
    [_MirrorVerButton release];
    [_HD_Button release];
    [_SD_Button release];
    
    if (_audioImgOn) {
        [_audioImgOn release];
        _audioImgOn = nil;
    }
    if (_audioImgOff) {
        [_audioImgOff release];
        _audioImgOff = nil;
    }
    if (_talkImgOn) {
        [_talkImgOn release];
        _talkImgOn = nil;
    }
    if (_talkImgOff) {
        [_talkImgOff  release];
        _talkImgOff = nil;
    }
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPlayView:nil];
    [self setLeft_rightButton:nil];
    [self setUp_downButton:nil];
    [self setToolbar1:nil];
    [self setToolbar2:nil];
    [self setSetView:nil];
    [self setContrastSlider:nil];
    [self setLightnessSlider:nil];
    [self setModeView:nil];
    [self setYusheView:nil];
    [self setYusheCell:nil];
    [self setTableView:nil];
    [self setLeftrightButton:nil];
    [self setUpdownButton:nil];
    [self setLeftImage:nil];
    [self setUpImage:nil];
    [self setDownImage:nil];
    [self setRightImage:nil];
    [self setStatusLabel:nil];
    [self setYuShe:nil];
    [self setContrastButton:nil];
    [self setBrightnessButton:nil];
    [self setMirrorHoriButton:nil];
    [self setMirrorVerButton:nil];
    [self setHD_Button:nil];
    [self setSD_Button:nil];
    [super viewDidUnload];
}
- (IBAction)up_down:(id)sender {
    [self hideView];
    if (![self.up_downButton.tintColor isEqual:[UIColor redColor]]) {
        [self.updownButton setImage:[UIImage imageNamed:@"ico4on.png"] forState:UIControlStateNormal];
        self.up_downButton.tintColor=[UIColor redColor];
        _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_UP_DOWN);
    }else{
        [self.updownButton setImage:[UIImage imageNamed:@"ico4.png"] forState:UIControlStateNormal];
        self.up_downButton.tintColor=nil;
        _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_UP_DOWN_STOP);
    }
}
- (IBAction)left:(id)sender {
    self.leftImage.hidden=NO;
    [self performSelector:@selector(hideImage) withObject:nil afterDelay:0.3];
    
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_LEFT);
}

- (IBAction)right:(id)sender {
    self.rightImage.hidden=NO;
    [self performSelector:@selector(hideImage) withObject:nil afterDelay:0.3];
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_RIGHT);
}

- (IBAction)up:(id)sender {
    self.upImage.hidden=NO;
    [self performSelector:@selector(hideImage) withObject:nil afterDelay:0.3];
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_UP);
}

- (IBAction)down:(id)sender {
    self.downImage.hidden=NO;
    [self performSelector:@selector(hideImage) withObject:nil afterDelay:0.3];
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_DOWN);
}
-(void)hideImage{
    _downImage.hidden=YES;
    _rightImage.hidden=YES;
    _leftImage.hidden=YES;
    _upImage.hidden=YES;
}
- (IBAction)hidebar:(id)sender {
    [UIView beginAnimations:@"doflip" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    if (flog==-1) {
        self.Toolbar1.frame=CGRectMake(0, -44, self.Toolbar1.frame.size.width,44);
        self.Toolbar2.frame=CGRectMake(0, self.Toolbar2.frame.origin.y+44, self.Toolbar2.frame.size.width,44);
        flog=0;
    }else{
        self.Toolbar1.frame=CGRectMake(0,0, self.Toolbar1.frame.size.width,44);
        self.Toolbar2.frame=CGRectMake(0,self.Toolbar2.frame.origin.y-44, self.Toolbar2.frame.size.width,44);
        flog=-1;
    }
    [self hideView];
    [UIView commitAnimations];
}
- (IBAction)Contrast:(id)sender {
    _setView.hidden=YES;
    _contrastSlider.hidden=NO;
}

- (IBAction)lightness:(id)sender {
    _setView.hidden=YES;
    _lightnessSlider.hidden=NO;
}

- (IBAction)horizontal_mirror:(id)sender {
    if (horizontal&&vertical) {
        _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 2);
    }else{
        
        if (!vertical) {
            _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 3);
        }else{
            _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 0);
        }
        if (!horizontal&&!vertical) {
            _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 1);
        }
    }
    
    horizontal=!horizontal;
    UIButton *button=(UIButton *)sender;
    if (button.backgroundColor==[UIColor blueColor]) {
        button.backgroundColor=[UIColor clearColor];
    }else{
        button.backgroundColor=[UIColor blueColor];
    }
}

- (IBAction)vertical_mirror:(id)sender {
    if (vertical&& horizontal) {
        _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 1);
    }else{
        
        if (!horizontal) {
            _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 3);
        }else{
            _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 0);
        }
        if (!horizontal&&!vertical) {
            _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 2);
        }
    }
    
    vertical=!vertical;
    UIButton *button=(UIButton *)sender;
    if (button.backgroundColor==[UIColor blueColor]) {
        button.backgroundColor=[UIColor clearColor];
    }else{
        button.backgroundColor=[UIColor blueColor];
    }
}

- (IBAction)showSetView:(id)sender {
    [self hideView];
    if (shezhi==1) {
        _setView.hidden=NO;
    }else{
        _setView.hidden=YES;
    }
    shezhi=-shezhi;
}

- (IBAction)contrastSetValue:(id)sender {
    _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 2, _contrastSlider.value);
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"config.plist"];
    
    
    NSMutableDictionary *data2 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
    NSMutableDictionary *data1 = [NSMutableDictionary dictionary];
    
    [data1 setObject:[NSString stringWithFormat:@"%f",_contrastSlider.value] forKey:@"contrast"];
    [data1 setObject:[NSString stringWithFormat:@"%f",_lightnessSlider.value] forKey:@"lightness"];
    [data2 setObject:data1 forKey:_cameraID];
    
    [data2 writeToFile:filename atomically:YES];
    
    
}

- (IBAction)lightnessSetValue:(id)sender {
    _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 1, _lightnessSlider.value);
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"config.plist"];
    
    
    NSMutableDictionary *data2 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
    NSMutableDictionary *data1 = [NSMutableDictionary dictionary];
    
    [data1 setObject:[NSString stringWithFormat:@"%f",_contrastSlider.value] forKey:@"contrast"];
    [data1 setObject:[NSString stringWithFormat:@"%f",_lightnessSlider.value] forKey:@"lightness"];
    [data2 setObject:data1 forKey:_cameraID];
    
    [data2 writeToFile:filename atomically:YES];
}

- (IBAction)mode:(id)sender {
    [self hideView];
    
    if (mode==1) {
        _modeView.hidden=NO;
    }else{
        _modeView.hidden=YES;
    }
    mode=-mode;
}

- (IBAction)modeHD:(id)sender {
    _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 3, 1);
    UIButton *button=(UIButton *)[_modeView viewWithTag:500];
    UIButton *button2=(UIButton *)[_modeView viewWithTag:501];
    if (button.backgroundColor==[UIColor blueColor]) {
        button.backgroundColor=[UIColor clearColor];
    }else{
        button.backgroundColor=[UIColor blueColor];
        button2.backgroundColor=[UIColor clearColor];
        button.enabled=NO;
        button2.enabled=YES;
    }
}

- (IBAction)modeSD:(id)sender {
    _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 3, 0);
    UIButton *button2=(UIButton *)[_modeView viewWithTag:500];
    UIButton *button=(UIButton *)[_modeView viewWithTag:501];
    if (button.backgroundColor==[UIColor blueColor]) {
        button.backgroundColor=[UIColor clearColor];
    }else{
        button.backgroundColor=[UIColor blueColor];
        button2.backgroundColor=[UIColor clearColor];
        button.enabled=NO;
        button2.enabled=YES;
    }
}
- (IBAction)yushewei:(id)sender {
    [self hideView];
    
    if (yushe==1) {
        self.yusheView.hidden=NO;
    }else{
        self.yusheView.hidden=YES;
    }
    yushe=-yushe;
}

- (IBAction)yusheButton:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:1];
    imageView.image = self.playView.image;
    switch ([sender tag]) {
        case 0:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_SET0);
            break;
        case 1:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_SET1);
            break;
        case 2:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_SET2);
            break;
        case 3:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_SET3);
            break;
        case 4:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_SET4);
            break;
        default:
            break;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.png",_cameraID,[sender tag]]];
    
    UIImage *image = self.playView.image;
    NSData *imageData = UIImageJPEGRepresentation(image,0.5);
    
    BOOL result = [imageData writeToFile:uniquePath atomically:YES];
    if (result) {
        NSLog(@"success");
    }else {
        NSLog(@"no success");
    }
}


- (void) StartAudio
{
    _m_PPPPChannelMgt->StartPPPPAudio([_cameraID UTF8String]);
}

- (void) StopAudio
{
    _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
}

- (void) StartTalk
{
    _m_PPPPChannelMgt->StartPPPPTalk([_cameraID UTF8String]);
}

- (void) StopTalk
{
    _m_PPPPChannelMgt->StopPPPPTalk([_cameraID UTF8String]);
}
- (IBAction)btnAudioControl:(id)sender
{
    if (_m_bAudioStarted) {
        [self StopAudio];
        [_audioBtn setImage:_audioImgOff forState:UIControlStateNormal];
        //btnAudioControl.style = UIBarButtonItemStyleBordered;
        //btnAudioControl.image = [UIImage imageNamed:@"ptz_audio_off"];
        //[btnAudioControl setBackgroundImage:[UIImage imageNamed:@"ptz_audio_off"] forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
    }else {
        if (_m_bTalkStarted) {
            [self StopTalk];
            _m_bTalkStarted = !_m_bTalkStarted;
            [_talkBtn setImage:_talkImgOff forState:UIControlStateNormal];
            //btnTalkControl.style = UIBarButtonItemStyleBordered;
            //btnTalkControl.image = [UIImage imageNamed:@"microphone_off"];
            //[btnAudioControl setBackgroundImage:[UIImage imageNamed:@"audio"] forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
        }
        [self StartAudio];
        [_audioBtn setImage:_audioImgOn forState:UIControlStateNormal];
        //btnAudioControl.style = UIBarButtonItemStyleDone;
        //btnAudioControl.image = [UIImage imageNamed:@"audio"];
    }
    
    _m_bAudioStarted = !_m_bAudioStarted;
    
    /*if (m_bAudioStarted) {
     btnTalkControl.enabled = NO;
     }else {
     btnTalkControl.enabled = YES;
     }*/
}
//
- (IBAction)btnTalkControl:(id)sender
{
    if (_m_bTalkStarted) {
        [self StopTalk];
        [_talkBtn setImage:_talkImgOff forState:UIControlStateNormal];
        //btnTalkControl.style = UIBarButtonItemStyleBordered;
        //btnTalkControl.image = [UIImage imageNamed:@"microphone_off"];
        //[btnTalkControl setBackgroundImage:[UIImage imageNamed:@"microphone_off"] forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
    }else {
        if (_m_bAudioStarted) {
            [self StopAudio];
            _m_bAudioStarted = !_m_bAudioStarted;
            [_audioBtn setImage:_audioImgOff forState:UIControlStateNormal];
            //btnAudioControl.style = UIBarButtonItemStyleBordered;
            //btnAudioControl.image = [UIImage imageNamed:@"ptz_audio_off"];
            //[btnTalkControl setBackgroundImage:[UIImage imageNamed:@"micro_on"] forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
        }
        [self StartTalk];
        [_talkBtn setImage:_talkImgOn forState:UIControlStateNormal];
        //btnTalkControl.style = UIBarButtonItemStyleDone;
        //btnTalkControl.image = [UIImage imageNamed:@"micro_on"];
    }
    _m_bTalkStarted = !_m_bTalkStarted;
    
    /*if (m_bTalkStarted) {
     btnAudioControl.enabled = NO;
     }else {
     btnAudioControl.enabled = YES;
     }*/
}

@end
