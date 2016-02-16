//
//  YWCollectionViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWCollectionViewController.h"
#import "YWCollectionTableViewCell.h"
#import "YWParser.h"
#import "YWHttpManager.h"
#import "YWUserModel.h"
#import "YWHotDetailViewController.h"
#import "YWDataBaseManager.h"

@interface YWCollectionViewController()<UITableViewDelegate, UITableViewDataSource, YWCollectionTableViewCellDelegate>

@end

@implementation YWCollectionViewController
{
    NSMutableArray      *_dataSource;
    UITableView         *_tableView;
    YWHttpManager       *_httpManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];
    
    [self createSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestCollectList];
}

- (void)createSubViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[YWCollectionTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}

#pragma mark - request
- (void)requestCollectList {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId};
    [_httpManager requestCollectList:parameters success:^(id responseObject) {
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser trendsWithArray:responseObject[@"collectList"]];
        [_dataSource addObjectsFromArray:array];
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    cell.trends = _dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YWCollectionTableViewCell cellHeightWithTrends:_dataSource[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YWHotDetailViewController *hotVC = [[YWHotDetailViewController alloc] init];
    hotVC.trends = _dataSource[indexPath.row];
    [self.navigationController pushViewController:hotVC animated:YES];
}

#pragma mark - YWCollectionTableViewCellDelegate
- (void)collectionTableViewCellDidSelectCooperate:(YWCollectionTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        
    }else {
        [self login];
    }
}

- (void)collectionTableViewCellDidSelectPlay:(YWCollectionTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        
    }else {
        [self login];
    }
}



@end
