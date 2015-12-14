//
//  YWNavigationController.m
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWNavigationController.h"

@interface YWNavigationController ()

@end

@implementation YWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = RGBColor(10, 10, 10);
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationBar.tintColor = [UIColor whiteColor];
//    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];

//    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
//    statusBarView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:statusBarView];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}



@end
