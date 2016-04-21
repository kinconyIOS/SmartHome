//
//  Wrapper.m
//  SmartHome
//
//  Created by sunzl on 16/4/11.
//  Copyright © 2016年 sunzl. All rights reserved.
//

#import "Wrapper.h"
#import "JK_ViewController.h"
#import "HTPlayCamerViewController.h"
@implementation Wrapper
-(void)push:(UIViewController *)view
{
    JK_ViewController *jk=[JK_ViewController new];
    jk.hidesBottomBarWhenPushed = YES;
    [view.navigationController pushViewController:jk animated:YES];
}
-(BOOL)kindsOfHTPlayCamerViewController:(UINavigationController *)view{
    return [view.topViewController isKindOfClass:HTPlayCamerViewController.class];

}
@end
