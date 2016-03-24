//
//  YWCommentViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWCommentViewController.h"
#import "YWCommentTableViewCell.h"
#import "YWParser.h"
#import "YWHttpManager.h"
#import "YWUserModel.h"
#import "YWTrendsDetailViewController.h"
#import "YWDataBaseManager.h"
#import "MJRefresh.h"
#import "YWHotItemViewController.h"
#import "YWCommentModel.h"

@interface YWCommentViewController()<UITableViewDataSource, UITableViewDelegate, YWCommentTableViewCellDelegate>

@end

@implementation YWCommentViewController
{
    NSMutableArray      *_dataSource;
    UITableView         *_tableView;
    YWHttpManager       *_httpManager;
    NSInteger            _currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];
    _currentPage = 0;

    [self createSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestCommentList];
    [_tableView setContentOffset:CGPointMake(0, 0)];
}

- (void)createSubViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[YWCommentTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.top.offset(64);
    }];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self requestCommentList];
    }];
}

#pragma mark - request
- (void)requestCommentList {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"page": @(_currentPage)};
    [_httpManager requestCommentList:parameters success:^(id responseObject) {
        if (!_currentPage) {
            [_dataSource removeAllObjects];
        }
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser commentsWithArray:responseObject[@"commentList"]];
        [_dataSource addObjectsFromArray:array];
        [self noContentViewShowWithState:_dataSource.count?NO:YES];
        if (array.count<20) {
            _tableView.footer = nil;
        }else {
            _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _currentPage ++;
                [self requestCommentList];
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
    YWCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.comment = _dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YWCommentTableViewCell cellHeightForMode:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YWCommentModel *comment = _dataSource[indexPath.row];
    if (comment.commentType == 1 || comment.commentType == 2) {
        YWTrendsDetailViewController *trendsDVC = [[YWTrendsDetailViewController alloc] init];
        trendsDVC.trends = comment.commentTrends;
        [self.navigationController pushViewController:trendsDVC animated:YES];
    }else {
        YWHotItemViewController *hotVC = [[YWHotItemViewController alloc] init];
        hotVC.template = comment.commentTemplate;
        hotVC.segSelectIndex = 1;
        [self.navigationController pushViewController:hotVC animated:YES];
    }
}

#pragma mark - YWCommentTableViewCellDelegate
- (void)commentTableViewCellDidSelectPlay:(YWCommentTableViewCell *)cell {

}

@end
