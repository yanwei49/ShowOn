//
//  YWSupportViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWSupportViewController.h"
#import "YWSupportTableViewCell.h"
#import "YWParser.h"
#import "YWHttpManager.h"
#import "YWUserModel.h"
#import "YWTrendsDetailViewController.h"
#import "YWHotItemViewController.h"
#import "YWDataBaseManager.h"
#import "MJRefresh.h"
#import "YWCommentModel.h"
#import "YWSupportModel.h"
#import "YWTrendsModel.h"

@interface YWSupportViewController()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation YWSupportViewController
{
    NSMutableArray      *_dataSource;
    UITableView         *_tableView;
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
    [self requestSupportList];
//    [_tableView setContentOffset:CGPointMake(0, 0)];
}

- (void)createSubViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[YWSupportTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self requestSupportList];
    }];
}

#pragma mark - request
- (void)requestSupportList {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"page": @(_currentPage)};
    [_httpManager requestSupportList:parameters success:^(id responseObject) {
        if (!_currentPage) {
            [_dataSource removeAllObjects];
        }
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser supportWithArray:responseObject[@"supportList"]];
        [_dataSource addObjectsFromArray:array];
        [self noContentViewShowWithState:_dataSource.count?NO:YES];
        if (array.count<20) {
            _tableView.footer = nil;
        }else {
            _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _currentPage ++;
                [self requestSupportList];
            }];
        }
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        [_tableView reloadData];
        [YWNoCotentView showNoCotentViewWithState:_dataSource.count?NO:YES];
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
    YWSupportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.support = _dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([_dataSource[indexPath.row] supportType].integerValue == 1) {
        YWTrendsDetailViewController *hotVC = [[YWTrendsDetailViewController alloc] init];
        hotVC.trends = [_dataSource[indexPath.row] trends];
        [self.navigationController pushViewController:hotVC animated:YES];
    }else if ([_dataSource[indexPath.row] supportType].integerValue == 2) {
        if ([_dataSource[indexPath.row] comments].commentTrends.trendsId.length) {
            YWTrendsDetailViewController *hotVC = [[YWTrendsDetailViewController alloc] init];
            YWCommentModel *comments = [_dataSource[indexPath.row] comments];
            hotVC.trends = comments.commentTrends;
            [self.navigationController pushViewController:hotVC animated:YES];
        }else {
            YWHotItemViewController *hotVC = [[YWHotItemViewController alloc] init];
            hotVC.template = [_dataSource[indexPath.row] comments].commentTemplate;
            hotVC.segSelectIndex = 1;
            [self.navigationController pushViewController:hotVC animated:YES];
        }
    }
}


@end
