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

@interface YWBaseViewController ()<UIAlertViewDelegate>

@end

@implementation YWBaseViewController
{
    
    YWHttpManager       *_httpManager;
    UIView              *_noContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    _httpManager = [YWHttpManager shareInstance];
    
    [self createNoContentView];
}

- (void)createNoContentView {
    _noContentView = [[UIView alloc] init];
    _noContentView.backgroundColor = Subject_color;
    [self.view addSubview:_noContentView];
    [_noContentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = Subject_color;
    label.textColor = RGBColor(230, 230, 230);
    label.text = @"暂无内容";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [_noContentView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(20);
        make.centerY.equalTo(_noContentView.mas_centerY);
    }];
    _noContentView.hidden = YES;
}

#pragma mark - right/left item
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
        [self.navigationController pushViewController:alter animated:YES];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alter show];
    }
}

#pragma mark - noContentView show state
- (void)noContentViewShowWithState:(BOOL)state {
    _noContentView.hidden = !state;
    [self.view bringSubviewToFront:_noContentView];
}


@end
