//
//  SZLSideView.m
//  DeliBaoxiang
//
//  Created by sunzl on 15/8/24.
//  Copyright (c) 2015年 sunzl. All rights reserved.
//

#import "SZLSideView.h"

@implementation SZLSideView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{

    self=[super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)closeTap {
    NSLog(@"close");
    //close
    [UIView beginAnimations:@"closeSide" context:nil];
    [UIView setAnimationDuration:0.30f];
    self.frame=CGRectMake([UIScreen mainScreen].bounds.size.width, 0, self.frame.size.width,  self.frame.size.height);
    [UIView commitAnimations];
}

- (void)openTap {
    //open
       NSLog(@"open");
    [UIView beginAnimations:@"openSide" context:nil];
    [UIView setAnimationDuration:0.30f];
    self.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-self.frame.size.width, 0, self.frame.size.width,  self.frame.size.height);
    [UIView commitAnimations];
}
@end
