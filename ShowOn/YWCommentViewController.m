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
#import "YWHotDetailViewController.h"
#import "YWDataBaseManager.h"

@interface YWCommentViewController()<UITableViewDataSource, UITableViewDelegate, YWCommentTableViewCellDelegate>

@end

@implementation YWCommentViewController
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
//    [self dataSource];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestCommentList];
}

//- (void)dataSource {
//    for (NSInteger i=0; i<10; i++) {
//        [_dataSource addObject:@""];
//    }
//    
//    [_tableView reloadData];
//}

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
        make.top.left.bottom.right.offset(0);
    }];
}

#pragma mark - request
- (void)requestCommentList {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId};
    [_httpManager requestCommentList:parameters success:^(id responseObject) {
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser aiTeWithArray:responseObject[@"aiTeList"]];
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
    YWCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.comment = _dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YWCommentTableViewCell cellHeightForMode:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YWHotDetailViewController *hotVC = [[YWHotDetailViewController alloc] init];
    hotVC.trends = [_dataSource[indexPath.row] trends];
    [self.navigationController pushViewController:hotVC animated:YES];
}

#pragma mark - YWCommentTableViewCellDelegate
- (void)commentTableViewCellDidSelectPlay:(YWCommentTableViewCell *)cell {

}

@end
