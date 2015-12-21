//
//  SZLSideView.h
//  DeliBaoxiang
//
//  Created by sunzl on 15/8/24.
//  Copyright (c) 2015年 sunzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZLSideView : UIView
@property (weak,nonatomic) id<UITableViewDataSource,UITableViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
-(void)setDelegate:(id<UITableViewDataSource,UITableViewDelegate>)delegate
;
- (void)closeTap;

- (void)openTap;
@end
