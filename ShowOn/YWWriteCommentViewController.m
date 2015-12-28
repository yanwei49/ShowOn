//
//  YWWriteCommentViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/27.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWWriteCommentViewController.h"

@interface YWWriteCommentViewController ()

@end

@implementation YWWriteCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    [self createRightItemWithTitle:@"发布"];
    [self createLeftItemWithTitle:@"取消"];

}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {

}

- (void)actionLeftItem:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
