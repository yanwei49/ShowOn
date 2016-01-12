//
//  YWHomeViewController.m
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWHomeViewController.h"
#import "YWCustomTabBarViewController.h"
#import "YWHotView.h"

@interface YWHomeViewController ()

@end

@implementation YWHomeViewController
{
    YWHotView       *_hotView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.title = @"图文";
    [self createLeftItemWithTitle:@"返回"];

    [self createHotView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenHotView) name:@"HiddenHotView" object:nil];
}

- (void)hiddenHotView {
    self.navigationController.navigationBarHidden = NO;
    _hotView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.hiddenState = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.hiddenState = YES;
}

- (void)actionLeftItem:(UIButton *)button {
    [self createHotView];
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.itemSelectIndex = -1;
}

- (void)createHotView {
    if (_hotView) {
        _hotView.hidden = NO;
        self.navigationController.navigationBarHidden = YES;
    }else {
        _hotView = [[YWHotView alloc] init];
        self.navigationController.navigationBarHidden = YES;
        _hotView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:_hotView];
        [_hotView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
    }
}


@end
