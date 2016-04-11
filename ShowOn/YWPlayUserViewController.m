//
//  YWPlayUserViewController.m
//  ShowOn
//
//  Created by David Yu on 6/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWPlayUserViewController.h"
#import "YWFollowingTableViewCell.h"
#import "YWSearchViewController.h"
#import "YWDataBaseManager.h"
#import "YWWeiBoFriendsViewController.h"
#import "YWUserModel.h"
#import "YWUserDataViewController.h"

@interface YWPlayUserViewController()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@end

@implementation YWPlayUserViewController
{
    UITableView         *_tableView;
    UISearchBar         *_searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    
    [self createSubViews];
}

- (void)createSubViews {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索片名/用户名";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = RGBColor(50, 50, 50);
    [_tableView registerClass:[YWFollowingTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _searchBar;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWFollowingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.relationButtonState = YES;
    cell.user = _users[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YWUserDataViewController *vc = [[YWUserDataViewController alloc] init];
    vc.user = _users[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if ([[YWDataBaseManager shareInstance] loginUser].userPassword.length) {
        YWSearchViewController *searchVC = [[YWSearchViewController alloc] init];
        [self.navigationController pushViewController:searchVC animated:YES];
    }else {
        YWWeiBoFriendsViewController *wbVC = [[YWWeiBoFriendsViewController alloc] init];
        [self.navigationController pushViewController:wbVC animated:YES];
    }
    
    return NO;
}

@end
