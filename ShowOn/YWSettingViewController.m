//
//  YWSettingViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWSettingViewController.h"
#import "YWUserProtocolViewController.h"
#import "YWSuggestionViewController.h"
#import "YWFollowingViewController.h"
#import "YWPrivacyViewController.h"
#import <SDImageCache.h>
#import "YWDataBaseManager.h"
#import "NSObject+Cache.h"

@interface YWSettingViewController()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@end

@implementation YWSettingViewController
{
    NSMutableArray      *_dataSource;
    UITableView         *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = Subject_color;
    _dataSource = [[NSMutableArray alloc] initWithArray:@[@"黑名单", @"清除缓存", @"建议反馈", @"关于角儿（用户使用协议）"]];
    
    [self createSubViews];
}

- (void)createSubViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    footView.backgroundColor = Subject_color;
    UIButton *resigsterBtn = [[UIButton alloc] init];
    [resigsterBtn setTitle:@"注销登录" forState:UIControlStateNormal];
    resigsterBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    resigsterBtn.backgroundColor = RGBColor(30, 30, 30);
    [resigsterBtn addTarget:self action:@selector(actionResigster) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:resigsterBtn];
    [resigsterBtn makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.bottom.offset(0);
        make.left.offset(40);
        make.right.offset(-40);
    }];
    _tableView.tableFooterView = footView;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(kScreenHeight-64);
    }];
}

#pragma mark - action
- (void)actionResigster {
    [[YWDataBaseManager shareInstance] cleanLoginUsers];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - pravite
- (NSString *)obtainCache {
    return [NSString stringWithFormat:@"%.2f", [NSObject obtainCacheSize]];
}

- (void) cleanCache {
    [NSObject clearCache:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"清除缓存成功"];
            [_tableView reloadData];
        });
    }];
}

- (void)showCleanCache {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"是否清除缓存" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cleanCache];
            [_tableView reloadData];
        }]];
        [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alter animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"是否清除缓存" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        view.backgroundColor = Subject_color;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 60, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = [NSString stringWithFormat:@"%@M", [self obtainCache]];
        [view addSubview:label];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(70, 0, 10, 20)];
        img.backgroundColor = Subject_color;
        img.image = [UIImage imageNamed:@"next.png"];
        [view addSubview:img];
        cell.accessoryView = view;
    }else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor = Subject_color;
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row != 1) {
        NSArray *className = @[@"YWFollowingViewController", @"", @"YWSuggestionViewController", @"YWUserProtocolViewController"];
        UIViewController *vc = [[NSClassFromString(className[indexPath.row]) alloc] init];
        if (indexPath.row == 0) {
            YWFollowingViewController *c = (YWFollowingViewController *)vc;
            c.title = @"黑名单";
            c.relationType = 3;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self showCleanCache];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self cleanCache];
    }
}

@end
