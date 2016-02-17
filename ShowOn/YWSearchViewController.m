//
//  YWSearchViewController.m
//  ShowOn
//
//  Created by David Yu on 25/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWSearchViewController.h"
#import "YWFollowingTableViewCell.h"
#import "YWSearchTemplateTableViewCell.h"
#import "YWUserModel.h"
#import "YWHotItemViewController.h"
#import "YWHttpManager.h"
#import "YWDataBaseManager.h"

@interface YWSearchViewController ()<UITableViewDataSource, UITableViewDelegate, YWFollowingTableViewCellDelegate, YWSearchTemplateTableViewCellDelegate, UISearchBarDelegate>

@end

@implementation YWSearchViewController
{
    NSMutableArray      *_dataSource;
    UITableView         *_tableView;
    UISearchBar         *_searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    [self createLeftItemWithTitle:@"取消"];
    
    [self createSubView];
}

- (void)createSubView {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索片名/用户名";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[YWFollowingTableViewCell class] forCellReuseIdentifier:@"userCell"];
    [_tableView registerClass:[YWSearchTemplateTableViewCell class] forCellReuseIdentifier:@"templateCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _searchBar;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}

#pragma mark - action
- (void)actionLeftItem:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - request
- (void)requestSearch {
    NSDictionary *parameters = @{@"searchText": _searchBar.text, @"userId": [[YWDataBaseManager shareInstance] loginUser].userId?:@""};
    [[YWHttpManager shareInstance] requestSearch:parameters success:^(id responseObject) {
        NSArray *users = [responseObject objectForKey:@"users"];
        if (users.count) {
            [self noContentViewShowWithState:NO];
            for (NSDictionary *dict in users) {
                YWUserModel *user = [[YWUserModel alloc] init];
                user.userName = [dict objectForKey:@"name"];
                user.portraitUri = [dict objectForKey:@"profile_image_url"];
                
                [_dataSource addObject:users];
            }
            [_tableView reloadData];
        }else {
            [self noContentViewShowWithState:YES];
        }
    } otherFailure:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dataSource[indexPath.row] isKindOfClass:[YWUserModel class]]) {
        YWFollowingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.user = _dataSource[indexPath.row];
        
        return cell;
    }else {
        YWSearchTemplateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"templateCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.templates = _dataSource[indexPath.row];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dataSource[indexPath.row] isKindOfClass:[YWUserModel class]]) {
        return 80;
    }else {
        return 95*(indexPath.row/2+indexPath.row%2);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - YWFollowingTableViewCellDelegate
- (void)followingTableViewCellDidSelectButton:(YWFollowingTableViewCell *)cell {
    
}

#pragma mark - YWSearchTemplateTableViewCellDelegate
- (void)searchTemplateTableViewCellDidSelectCellWithTemplate:(YWMovieTemplateModel *)template {
    YWHotItemViewController *vc = [[YWHotItemViewController alloc] init];
    vc.template = template;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    [self requestSearch];
}

@end
