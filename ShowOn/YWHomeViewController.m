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
#import "YWHotItemViewController.h"

@interface YWHomeViewController ()<YWHotViewDelegate>

@end

@implementation YWHomeViewController
{
    YWHotView       *_hotView;
    BOOL             _isPushHotItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenHotView) name:@"HiddenHotView" object:nil];
    self.view.backgroundColor = Subject_color;
    self.title = @"图文";
    [self createLeftItemWithTitle:@"首页"];

    [self createHotView];
}

- (void)hiddenHotView {
    self.navigationController.navigationBarHidden = NO;
    _hotView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isPushHotItem) {
        [self createHotView];
        _isPushHotItem = NO;
    }
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.hiddenState = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
        _hotView.delegate = self;
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


#pragma mark - YWHotViewDelegate
- (void)hotViewDidSelectItemWithIndex:(NSInteger)index {
    NSLog(@"========index");
    YWHotItemViewController *vc = [[YWHotItemViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    _isPushHotItem = YES;
}

@end
