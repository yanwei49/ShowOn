//
//  YWBaseViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"
#import "YWLoginViewController.h"

@interface YWBaseViewController ()

@end

@implementation YWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    
}

- (void)createLeftItemWithTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 70, 34)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(actionLeftItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)actionLeftItem:(UIButton *)button {

}

- (void)createRightItemWithTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 5, 70, 34)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(actionRightItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)createRightItemWithImage:(NSString *)imageName {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 5, 70, 34)];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionRightItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)actionRightItem:(UIButton *)button {

}

- (void)login {
    YWLoginViewController *loginVC = [[YWLoginViewController alloc] init];
    loginVC.backButtonHiddenState = NO;
    [self presentViewController:loginVC animated:YES completion:nil];
}

@end
