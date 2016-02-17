//
//  YWUserListViewController.m
//  ShowOn
//
//  Created by David Yu on 17/2/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWUserListViewController.h"
#import "MJRefresh.h"
#import "YWHttpManager.h"
#import "YWParser.h"
#import "YWUserTableViewCell.h"

@interface YWUserListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation YWUserListViewController
{
    UITableView     *_tableView;
    NSMutableArray  *_dataSource;
    YWHttpManager   *_httpManager;
    NSInteger        _currentPage;
    NSMutableArray  *_stateArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择用户";
    [self createRightItemWithTitle:@"完成"];
    _dataSource = [[NSMutableArray alloc] init];
    _stateArray = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];
    _currentPage = 0;

    [self createSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestUserList];
}

#pragma mark - create
- (void)actionRightItem:(UIButton *)button {
    NSMutableArray *users = [NSMutableArray array];
    for (NSInteger i=0; i<_stateArray.count; i++) {
        if ([_stateArray[i] boolValue]) {
            [users addObject:_dataSource[i]];
        }
    }
    if ([_delegate respondsToSelector:@selector(userListViewControllerDidSelectUsers:)]) {
        [_delegate userListViewControllerDidSelectUsers:users];
    }
}

#pragma mark - create
- (void)createSubViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[YWUserTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.right.offset(0);
    }];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self requestUserList];
    }];
}

#pragma mark - request
- (void)requestUserList {
    NSDictionary *parameters = @{@"relationTypeId": @(0), @"userId": @"", @"page": @(_currentPage)};
    [_httpManager requestUserList:parameters success:^(id responseObject) {
        if (!_currentPage) {
            [_dataSource removeAllObjects];
            [_stateArray removeAllObjects];
        }
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser userWithArray:responseObject[@"userList"]];
        [_dataSource addObjectsFromArray:array];
        [self noContentViewShowWithState:_dataSource.count?NO:YES];
        for (NSInteger i=0; i<array.count; i++) {
            [_stateArray addObject:@(NO)];
        }
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.user = _dataSource[indexPath.row];
    cell.state = [_stateArray[indexPath.row] boolValue];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BOOL state = [_stateArray[indexPath.row] boolValue];
    [_stateArray replaceObjectAtIndex:indexPath.row withObject:@(!state)];
    YWUserTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.state = [_stateArray[indexPath.row] boolValue];
}



@end
