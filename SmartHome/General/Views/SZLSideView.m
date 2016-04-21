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
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
   
    self.isOpen = NO;
      
    }
    return self;
}

-(void)setDelegate:(id<UITableViewDataSource,UITableViewDelegate>)delegate
{
    self.tableView.dataSource=delegate;
    self.tableView.delegate=delegate;
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemCell" bundle:nil] forCellReuseIdentifier:@"itemcell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddCell" bundle:nil] forCellReuseIdentifier:@"addcell"];
}

- (void)closeTap {
    NSLog(@"close");
      self.isOpen =  !self.isOpen;;
    //close
    [UIView beginAnimations:@"closeSide" context:nil];
    [UIView setAnimationDuration:0.30f];
    self.frame=CGRectMake([UIScreen mainScreen].bounds.size.width, self.frame.origin.y, self.frame.size.width,  self.frame.size.height);
    [UIView commitAnimations];
}

- (void)openTap {
    //open
       NSLog(@"open");
    self.isOpen =  !self.isOpen;
    [UIView beginAnimations:@"openSide" context:nil];
    [UIView setAnimationDuration:0.30f];
    self.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-self.frame.size.width, self.frame.origin.y, self.frame.size.width,  self.frame.size.height);
    [UIView commitAnimations];
}
@end
