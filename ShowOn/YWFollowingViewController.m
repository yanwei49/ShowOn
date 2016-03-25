//
//  YWFollowingViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWFollowingViewController.h"
#import "YWFollowingTableViewCell.h"
#import "YWHttpManager.h"
#import "YWParser.h"
#import "YWUserModel.h"
#import "YWDataBaseManager.h"
#import "MJRefresh.h"
#import "YWWeiBoFriendsViewController.h"
#import "YWSearchViewController.h"

@interface YWFollowingViewController ()<UITableViewDelegate, UITableViewDataSource, YWFollowingTableViewCellDelegate, UISearchBarDelegate>

@end

@implementation YWFollowingViewController
{
    NSMutableArray      *_dataSource;
    UITableView         *_tableView;
    UISearchBar         *_searchBar;
    YWHttpManager       *_httpManager;
    NSInteger            _currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    _dataSource = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];
    _currentPage = 0;

    [self createSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_templateId) {
        [self requestUserList];
    }else {
        [self requestVedioPlayUserList];
    }
//    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
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
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self requestUserList];
    }];
}

#pragma mark - request
- (void)requestUserList {
    NSDictionary *parameters = @{@"relationTypeId": @(_relationType), @"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"page": @(_currentPage)};
    [_httpManager requestUserList:parameters success:^(id responseObject) {
        if (!_currentPage) {
            [_dataSource removeAllObjects];
        }
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser userWithArray:responseObject[@"userList"]];
        [_dataSource addObjectsFromArray:array];
        [self noContentViewShowWithState:_dataSource.count?NO:YES];
        if (array.count<20) {
            _tableView.footer = nil;
        }else {
            _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _currentPage ++;
                [self requestUserList];
            }];
        }
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}

- (void)requestVedioPlayUserList {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId?:@"", @"templateId": _templateId, @"page": @(_currentPage)};
    [_httpManager requestTemplatePlayUserList:parameters success:^(id responseObject) {
        if (!_currentPage) {
            [_dataSource removeAllObjects];
        }
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser userWithArray:responseObject[@"userList"]];
        [_dataSource addObjectsFromArray:array];
        [self noContentViewShowWithState:_dataSource.count?NO:YES];
        if (array.count<20) {
            _tableView.footer = nil;
        }else {
            _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _currentPage ++;
                [self requestVedioPlayUserList];
            }];
        }
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}

- (void)requestAddFollowWithUser:(YWUserModel *)user {
    NSInteger state = 0;
    switch (user.userRelationType) {
        case kEachOtherNoFocus:
            state = kFocus;
            break;
        case kFocus:
            state = kEachOtherNoFocus;
            break;
        case kBeFocus:
            state = kEachOtherFocus;
            break;
        case kBlackList:
            state = kEachOtherNoFocus;
            break;
        case kEachOtherFocus:
            state = kBeFocus;
            break;
        default:
            break;
    }
    NSDictionary *parameters = @{@"state": @(state), @"userId": [[YWDataBaseManager shareInstance] loginUser].userId};
    [_httpManager requestChangeRelationType:parameters success:^(id responseObject) {
        user.userRelationType = state;
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_dataSource indexOfObject:user] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWFollowingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    cell.user = _dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - YWFollowingTableViewCellDelegate
- (void)followingTableViewCellDidSelectButton:(YWFollowingTableViewCell *)cell {
    [self requestAddFollowWithUser:cell.user];
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
