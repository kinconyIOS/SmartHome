//
//  MyScorllView.h
//  LongMaoSport
//
//  Created by SunZlin on 16/4/3.
//  Copyright © 2016年 SunZlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCameras.h"
#import "HIKLoadView.h"
@protocol TouchSXT
-(void)passTouch:(NSDictionary *)dict;
@end
@interface MySxtScorllView : UIView
@property (nonatomic,strong) NSArray<HTCameras *>* dataArray;
@property (nonatomic, strong) NSMutableArray<HIKLoadView *>*loadingViews;
@property (assign) id<TouchSXT> delegate;
- (void)setupPage;
- (void)config;
- (void)doBack;
@end
