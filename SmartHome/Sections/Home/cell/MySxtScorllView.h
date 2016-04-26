//
//  MyScorllView.h
//  LongMaoSport
//
//  Created by SunZlin on 16/4/3.
//  Copyright © 2016年 SunZlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCameras.h"

@interface MySxtScorllView : UIView
@property (nonatomic,strong) NSArray<HTCameras *>* dataArray;
- (void)setupPage;
-(void)config;
@end
