//
//  MyScorllView.m
//  LongMaoSport
//
//  Created by SunZlin on 16/4/3.
//  Copyright © 2016年 SunZlin. All rights reserved.
//
//使用
//_images = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"demo.jpg"],[UIImage imageNamed:@"demo.jpg"],[UIImage imageNamed:@"demo.jpg"],nil];

//调用 setupPage方法
//[self setupPage];
#define CGI_IEGET_CAM_PARAMS		0x6003
#import "MySxtScorllView.h"
#include "MyAudioSession.h"
#include "APICommon.h"
#include "PPPPChannelManagement.h"
#import "PPPPDefine.h"
#import "obj_common.h"

#import "HTCameraStatus.h"

#import "UIImageView+WebCache.h"

@interface MySxtScorllView()<UIScrollViewDelegate>
@property (strong, nonatomic)  UIScrollView *scrollView;
@property  CPPPPChannelManagement* m_PPPPChannelMgt;
@property (nonatomic, retain) NSCondition *m_PPPPChannelMgtCondition;
@property (retain, nonatomic) UIPageControl *pageControl;
@property (nonatomic,strong) NSMutableArray <UIImageView *> *players;

@property (nonatomic, retain) NSMutableArray *camstatus;
@end
@implementation MySxtScorllView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self configView:frame];
     
       
    }
    return self;
}



-(void)configView:(CGRect)frame
{
    _players = [NSMutableArray array];
    //设置scrollview
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
     //初始化pageControl
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width,40)];
    //把scrollView与pageControl添加到当前视图中
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
}
-(void)config{
    //
    _m_PPPPChannelMgtCondition = [[NSCondition alloc] init];
    _m_PPPPChannelMgt = new CPPPPChannelManagement();
    _m_PPPPChannelMgt->pCameraViewController = self;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self Initialize:nil];
        dispatch_apply([self.dataArray count], queue, ^(size_t index){
            HTCameras *cam = [HTCameras new];
            cam = [self.dataArray objectAtIndex:index];
            [self ConnectCam:cam.ID user:cam.Name psw:cam.PassWord];
        });
    });

}

#pragma mark 设计视图使用的方法
//改变滚动视图的方法实现
- (void)setupPage
{
 
    //设置委托
    _scrollView.tag=111;
    _scrollView.delegate = self;
    //是否自动裁切超出部分
    _scrollView.clipsToBounds = YES;
    //是否自动裁切超出部分;
    self.scrollView.clipsToBounds = YES;
    //设置是否可以缩放
    self.scrollView.scrollEnabled = YES;
    //设置是否可以进行画面切换
    self.scrollView.pagingEnabled = YES;
    //设置在拖拽的时候是否锁定其在水平或者垂直的方向
    self.scrollView.directionalLockEnabled = YES;
    //隐藏滚动条设置（水平、跟垂直方向）
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.alwaysBounceVertical =  NO;
    self.scrollView.showsHorizontalScrollIndicator =  NO;
    self.scrollView.showsVerticalScrollIndicator =  NO;
    //设置是否可以缩放
    //用来记录页数
    NSUInteger pages = 0;
    //用来记录scrollView的x坐标
    int originX = 0;
    for(HTCameras * equip in _dataArray)
    {
        //创建一个视图
       UIImageView *playView = [[UIImageView alloc]initWithFrame:CGRectMake(originX, 0, _scrollView.frame.size.width,  _scrollView.frame.size.height)];
     
      
      
     
        //设置图片内容的显示模式()
        playView.contentMode = UIViewContentModeScaleAspectFill;
        //把视图添加到当前的滚动视图中
        playView.layer.masksToBounds=YES;
        [_scrollView addSubview:playView];
        [_players addObject:playView];
       
        //下一张视图的x坐标:offset为:self.scrollView.frame.size.width.
        originX += (self.scrollView.frame.size.width);
        //记录scrollView内imageView的个数
        pages++;
    }
    //设置页码控制器的响应方法
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    //设置总页数
    _pageControl.numberOfPages = pages;
    //默认当前页为第一页
    _pageControl.currentPage = 0;
    //为页码控制器设置标签
    _pageControl.tag = 110;
    //设置滚动视图的位置
    [_scrollView setContentSize:CGSizeMake(originX, 0)];
}

//改变页码的方法实现
- (void)changePage:(id)sender
{
    NSLog(@"指示器的当前索引值为:%li",(long)_pageControl.currentPage);
    //获取当前视图的页码
    CGRect rect = _scrollView.frame;
    //设置视图的横坐标，一幅图为320*460，横坐标一次增加或减少320像素
    rect.origin.x = _pageControl.currentPage * self.scrollView.frame.size.width;
    //设置视图纵坐标为0
    rect.origin.y = 0;
    //scrollView可视区域
    [_scrollView scrollRectToVisible:rect animated:YES];
}
#pragma mark-----UIScrollViewDelegate---------
//实现协议UIScrollViewDelegate的方法，必须实现的
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取当前视图的宽度
    CGFloat pageWith = scrollView.frame.size.width;
    //根据scrolView的左右滑动,对pageCotrol的当前指示器进行切换(设置currentPage)
    int page = floor((scrollView.contentOffset.x - pageWith/2)/pageWith)+1;
    //切换改变页码，小圆点
    self.pageControl.currentPage = page;
 
}




- (void)Initialize:(id)sender{
    PPPP_Initialize((char*)[@"EFGBFFBJKDJBGNJBEBGMFOEIHPNFHGNOGHFBBOCPAJJOLDLNDBAHCOOPGJLMJGLKAOMPLMDINEIOLMFAFCPJJGAM" UTF8String]);//Input your company server address
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);
}

- (void)ConnectCam:(NSString *)cameraID user:(NSString *)user psw:(NSString *)psw{
    _m_PPPPChannelMgt->Start([cameraID UTF8String], [user UTF8String], [psw UTF8String]);
}

//ImageNotifyProtocol
- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp DID:(NSString *)did{
    NSArray *arr = [NSArray arrayWithObjects:image,did, nil];
    [self performSelector:@selector(refreshImage:) withObject:arr];
}

- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did{
    UIImage* image = [APICommon YUV420ToImage:yuv width:width height:height];
    NSArray *arr = [NSArray arrayWithObjects:image,did, nil];
    [self performSelector:@selector(refreshImage:) withObject:arr];
}

- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp{
   
}

// PPPPStatusDelegate
- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status{
    NSLog(@"状态 ： %d",status);
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
            [self starVideo:nil];
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            dispatch_async(dispatch_get_main_queue(),^{
                
            });
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
       
        HTCameras *cam4 = self.dataArray[[self getCameraIndex:strDID]];
        if (status == 2) {
            [self starVideo:cam4.ID];
        }
        
    });
}

-(int)getCameraIndex:(NSString *)strDID
{
    int i ;
    for (  i = 0; i < self.dataArray.count; i++) {
        HTCameras *cam = [HTCameras new];
        cam = [self.dataArray objectAtIndex:i];
        if ([strDID isEqualToString:cam.ID]) {
            break;
        }
    }
    return i;

}
//refreshImage
- (void) refreshImage:(NSArray* ) arr{
    NSLog(@"走图像协议了");
    if ([arr objectAtIndex:0] != nil) {
        dispatch_async(dispatch_get_main_queue(),^{
          _players[[self getCameraIndex:arr[1]]].image = arr[0];
            NSLog(@"加载image了");
         // [self stopVideo:arr[1]];
        });
    }
}

- (void)starVideo:(NSString *)caid{
    if (_m_PPPPChannelMgt != NULL) {
        _m_PPPPChannelMgt -> StartPPPPAudio([caid UTF8String]);
        if (_m_PPPPChannelMgt->StartPPPPLivestream([caid UTF8String], 10, self) == 0) {
            _m_PPPPChannelMgt->StopPPPPAudio([caid UTF8String]);
            _m_PPPPChannelMgt->StopPPPPLivestream([caid UTF8String]);
        }
        
        _m_PPPPChannelMgt -> StopPPPPAudio([caid UTF8String]);
        _m_PPPPChannelMgt->GetCGI([caid UTF8String], CGI_IEGET_CAM_PARAMS);
    }
}

- (void)stopVideo:(NSString *)caid{
    _m_PPPPChannelMgt->StopPPPPAudio([caid UTF8String]);
    _m_PPPPChannelMgt->StopPPPPLivestream([caid UTF8String]);
}
- (void)doBack {
    _m_PPPPChannelMgt->StopAll();
}







@end
