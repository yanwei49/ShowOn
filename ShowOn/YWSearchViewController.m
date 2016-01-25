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

@interface YWSearchViewController ()<UITableViewDataSource, UITableViewDelegate, YWFollowingTableViewCellDelegate, YWSearchTemplateTableViewCellDelegate>

@end

@implementation YWSearchViewController
{
    NSMutableArray      *_dataSource;
    UITableView         *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    [self createLeftItemWithTitle:@"取消"];

    
}

- (void)createSubView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[YWFollowingTableViewCell class] forCellReuseIdentifier:@"userCell"];
    [_tableView registerClass:[YWSearchTemplateTableViewCell class] forCellReuseIdentifier:@"templateCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
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

@end
