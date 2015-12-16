//
//  HScrollView.h
//  新闻客户端
//
//  Created by SunZlin on 15/5/19.
//  Copyright (c) 2015年 SunZlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HScrollView : UIScrollView
{
    //按钮集合
    NSMutableArray *btns;

}
-(HScrollView *)init;
-(void)addButton:(UIButton *)btn with:(float)height;
-(void)clearColor;
@end
