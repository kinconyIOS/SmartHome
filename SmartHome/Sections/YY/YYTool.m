//
//  FirstViewController.m
//  FanHeater
//
//  Created by kincony on 15/7/15.
//  Copyright (c) 2015年 kincony. All rights reserved.
//

#import "YYTool.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import "iflyMSC/IFlyContact.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyUserWords.h"
#import "RecognizerFactory.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlyResourceUtil.h"
#import "PopupView.h"
#import "ISRDataHelper.h"
#define IOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
@interface YYTool ()

@end

@implementation YYTool
@synthesize voiceHud_;
static YYTool *yyTool = nil;

+ (instancetype)share
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        NSLog(@"重新创建manager－－－");
        yyTool = [[self alloc] init] ;
        
    }) ;
    
    return yyTool;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _iFlySpeechRecognizer = [RecognizerFactory CreateRecognizer:self Domain:@"iat"];
        _uploader = [[IFlyDataUploader alloc] init];
        [self onUploadUserWord];
        
        self.popUpView = [[PopupView alloc]initWithFrame:CGRectMake(100, 100, 0, 0)];
        _popUpView.ParentView = self.parentView;
    }
    return self;
}


    




-(void)viewWillAppear:(BOOL)animated
{
    //验证设备
       [self yyfuwu];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
#pragma mark 语音识别

-(void)cancel
{
    //取消识别
    [_iFlySpeechRecognizer cancel];
    [_iFlySpeechRecognizer setDelegate: nil];
    
}



#pragma mark - Helper Function

-(void) showVoiceHudOrHide:(BOOL)yesOrNo{
    if (yesOrNo) {
        
        if (!voiceHud_) {
            voiceHud_ = [[LCVoiceHud alloc] init];
            [ voiceHud_.btnCancel   addTarget:self action:@selector(cancelled:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [voiceHud_ show];
    }else{
        [voiceHud_ hide];
      //取消
        [self cancel];
    }
}

/*
 * @取消识别
 */
- (void)cancelled:(id)sender {
    
    NSLog(@"cancel");
    self.isCanceled = YES;
    
    [self showVoiceHudOrHide:NO];
    
    [_iFlySpeechRecognizer cancel];
    
    
}
#pragma mark - Button Handler
/*
 * @上传用户词
 */
#define NAME @"myuserwords"
#define USERWORDS   @"{\"userword\":[{\"name\":\"iflytek\",\"words\":[\"1档\",\"2档\",\"3档\",\"开启\",\"关闭\",\"开\",\"关\",\"加湿\",\"干燥\",\"摆风\",\"静止\",\"自然\",\"温控\",\"标准\",\"智能\",\"睡眠\",\"离子\",\"指示\",\"摇头\"]}]}"

- (void) onUploadUserWord
{
    [_iFlySpeechRecognizer stopListening];
    
    [self.uploader setParameter:@"iat" forKey:[IFlySpeechConstant SUBJECT]];
    [self.uploader setParameter:@"userword" forKey:[IFlySpeechConstant DATA_TYPE]];
    
    IFlyUserWords *iFlyUserWords = [[IFlyUserWords alloc] initWithJson:USERWORDS ];
    
    [self.uploader uploadDataWithCompletionHandler:^(NSString * grammerID, IFlySpeechError *error)
     {
         [self onUploadFinished:grammerID error:error];
         
     } name:NAME data:[iFlyUserWords toString]];
    
}

#pragma mark - IFlySpeechRecognizerDelegate

/**
 * @fn      onVolumeChanged
 * @brief   音量变化回调
 *
 * @param   volume      -[in] 录音的音量，音量范围1~100
 * @see
 */
- (void) onVolumeChanged: (int)volume
{
    
    if (self.isCanceled) {
        
        [self showVoiceHudOrHide:NO];
        
        return;
    }
    [voiceHud_ setProgress:volume/60.0f];
    
}

/**
 * @fn      onBeginOfSpeech
 * @brief   开始识别回调
 *
 * @see
 */
- (void) onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
}

/**
 * @fn      onEndOfSpeech
 * @brief   停止录音回调
 *
 * @see
 */
- (void) onEndOfSpeech
{
    [self showVoiceHudOrHide:NO];
    
    NSLog(@"onEndOfSpeech");
    
}


/**
 * @fn      onError
 * @brief   识别结束回调
 *
 * @param   errorCode   -[out] 错误类，具体用法见IFlySpeechError
 */
- (void) onError:(IFlySpeechError *) error
{
    NSString *text ;
    
    if (self.isCanceled) {
        text = @"识别取消";
    }
    else if (error.errorCode ==0 ) {
        
        if (_reString.length==0) {
            
            text = @"无识别结果";
        }
        else
        {
            text = @"识别成功";
        }
    }
    else
    {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        
        NSLog(@"%@",text);
    }
    [self showVoiceHudOrHide:NO];
    [_popUpView setText: text];
    
    [self.parentView addSubview:_popUpView];

    
}

/**
 * @fn      onResults
 * @brief   识别结果回调
 *
 * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 * @see
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
   NSMutableString *resultString = [[NSMutableString alloc] init];
    
    NSDictionary *dic = results[0];
    
   for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * resultFromJson =  [[ISRDataHelper shareInstance] getResultFromJson:resultString];
  
    NSLog(@"听写结果：%@",resultFromJson);
    if (isLast)
    {
       // NSLog(@"听写结果(json)：%@",  _reString);
    }
    
    NSLog(@"isLast=%d",isLast);
}

/**
 * @fn      onCancel
 * @brief   取消识别回调
 * 当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个短暂时间，您可以在此函数中实现对这段时间的界面显示。
 * @param
 * @see
 */
- (void) onCancel
{
    NSLog(@"识别取消");
}

#pragma mark - IFlyDataUploaderDelegate

/**
 * @fn  onUploadFinished
 * @brief   上传完成回调
 * @param grammerID 上传用户词为空
 * @param error 上传错误
 */
- (void) onUploadFinished:(NSString *)grammerID error:(IFlySpeechError *)error
{
    NSLog(@"%d",[error errorCode]);
}


-(void)yyfuwu{
    _reString=@"";
    self.isCanceled = NO;
    //[_iFlySpeechSynthesizer stopSpeaking];
    
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    BOOL ret = [_iFlySpeechRecognizer startListening];
    
    if (ret) {
        
    }
    else
    {
        [_popUpView setText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束，暂不支持多路并发
        [self.parentView addSubview:_popUpView];
    }
    
    [self showVoiceHudOrHide:YES];

}
-(void)onCompleted:(IFlySpeechError *)error
{
    NSLog(@"onCompleted error=%d",[error errorCode]);
    
    NSString *text = nil;
    
    if (self.isCanceled)
    {
        text = @"合成已取消";
    }
    else if (error.errorCode ==0 )
    {
        text = @"合成结束";
    }
    else
    {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
       // self.hasError = YES;
        NSLog(@"%@",text);
    }
   // [_iFlySpeechSynthesizer stopSpeaking];
  
    [_popUpView setText: text];
    [self.parentView addSubview:_popUpView];
}

@end
