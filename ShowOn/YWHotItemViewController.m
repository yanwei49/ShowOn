//
//  YWHotItemViewController.m
//  ShowOn
//
//  Created by 颜魏 on 16/1/12.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWHotItemViewController.h"

@interface YWHotItemViewController ()

@end

@implementation YWHotItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.navigationController.navigationBarHidden = NO;
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"排行", @"评论"]];
    segmentedControl.frame = CGRectMake(0, 0, 100, 35);
    segmentedControl.selectedSegmentIndex = 2;//设置默认选择项索引
    segmentedControl.tintColor = [UIColor redColor];
    self.navigationItem.titleView = segmentedControl;
    
    
}


@end
