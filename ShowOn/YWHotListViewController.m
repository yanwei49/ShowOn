//
//  YWHotListViewController.m
//  ShowOn
//
//  Created by David Yu on 8/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWHotListViewController.h"

@implementation YWHotListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.navigationController.navigationBar.barTintColor = RGBColor(10, 10, 10);
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self createLeftItemWithTitle:@"取消"];

    
}

- (void)actionLeftItem:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
