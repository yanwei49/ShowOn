//
//  YWBaseViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"

@interface YWBaseViewController ()

@end

@implementation YWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)createBackLeftItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 70, 34)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor =[UIColor lightGrayColor].CGColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)actionBack:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createBackRightItemWithTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 5, 70, 34)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionRightItem:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor =[UIColor lightGrayColor].CGColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)actionRightItem:(UIButton *)button {

}

@end
