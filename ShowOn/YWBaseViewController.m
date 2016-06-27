//
//  YWBaseViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"
#import "YWLoginViewController.h"
#import "YWHttpManager.h"
#import "YWParser.h"
#import "YWNavigationController.h"
#import "UIAlertView+Block.h"

@interface YWBaseViewController ()<UIAlertViewDelegate>

@end

@implementation YWBaseViewController
{
    
    YWHttpManager       *_httpManager;
    UILabel             *_noContentLabel;
    BOOL                 _isWIFI;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    _httpManager = [YWHttpManager shareInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [YWNoCotentView showNoCotentViewWithState:NO];
    [_httpManager getNetWorkNotificationCenterWithState:^(bool isWIFI) {
        _isWIFI = isWIFI;
    }];
}

- (BOOL)checkNewWorkIsWifi {
//    _isWIFI = YES;
    return _isWIFI;
}

#pragma mark - create right/left item
- (void)createLeftItemWithTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 50, 34)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(actionLeftItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)createRightItemWithTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 5, 50, 34)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(actionRightItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)createRightItemWithImage:(NSString *)imageName {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 5, 50, 34)];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionRightItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - right/left item action
- (void)actionLeftItem:(UIButton *)button {
    
}

- (void)actionRightItem:(UIButton *)button {

}

#pragma mark - request 
- (void)requestPlayModelId:(NSString *)modelId withType:(NSInteger)type {
    NSDictionary *parameters = @{@"id": modelId, @"type": @(type)};
    [[YWHttpManager shareInstance] requestPlay:parameters success:^(id responseObject) {
        
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - login
- (void)login {
    YWLoginViewController *loginVC = [[YWLoginViewController alloc] init];
    loginVC.backButtonHiddenState = NO;
    YWNavigationController *nv = [[YWNavigationController alloc] initWithRootViewController:loginVC];
    nv.navigationBarHidden = YES;
    [self presentViewController:nv animated:YES completion:nil];
}

#pragma mark - alter
- (void)showAlterWithTitle:(NSString *)title {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alter animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alter show];
    }
}

#pragma mark - noContentView show state
- (void)noContentViewShowWithState:(BOOL)state {
    if (state) {
        _noContentLabel.hidden = NO;
        [self.view bringSubviewToFront:_noContentLabel];
    }else {
        _noContentLabel.hidden = YES;
        [self.view insertSubview:_noContentLabel atIndex:0];
    }
}


@end
