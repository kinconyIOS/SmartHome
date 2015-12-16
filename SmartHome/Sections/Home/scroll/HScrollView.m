//
//  HScrollView.m
//  新闻客户端
//
//  Created by SunZlin on 15/5/19.
//  Copyright (c) 2015年 SunZlin. All rights reserved.
//

#import "HScrollView.h"
#define SCROLLWIDTH 15
@implementation HScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(HScrollView *)init{
    self =[super init];
    if (self) {
        //实例化集合
        btns=[[NSMutableArray alloc]initWithCapacity:10];
        //背景颜色
        self.scrollEnabled=YES;
        self.alpha=0;
        self.showsHorizontalScrollIndicator=NO;
        self.showsVerticalScrollIndicator=NO;
    }
    
    return self;
}
-(void)addButton:(UIButton *)btn with:(float)height{
    NSInteger width=SCROLLWIDTH;
    UIButton *last_btn=[btns lastObject];
    if (last_btn) {
        width+=last_btn.frame.origin.x+last_btn.frame.size.width;
    }else{
        width=0;
    }
    CGRect frame=btn.frame;
    //设定x，y；
    frame.origin.x=width;
    frame.origin.y=20;
    btn.frame=frame;
    //放的滚动视图上
    [self addSubview:btn];
    //在集合中保存这个按钮；
    [btns addObject:btn];
    if (width>self.frame.size.width) {
        self.contentSize=CGSizeMake(width+btn.frame.size.width+5, height);
    }
}

-(void)clearColor
{
    for (UIButton *btn in btns) {
        [btn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor clearColor];
    }
}
@end
