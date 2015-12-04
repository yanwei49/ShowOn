//
//  YWFollowingViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWFollowingViewController.h"
#import "YWFollowingTableViewCell.h"

#import "YWUserModel.h"

@interface YWFollowingViewController ()<UITableViewDelegate, UITableViewDataSource, YWFollowingTableViewCellDelegate>

@end

@implementation YWFollowingViewController
{
    NSMutableArray      *_dataSource;
    UITableView         *_tableView;
    UISearchBar         *_searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [[NSMutableArray alloc] init];
    [self createBackLeftItem];
    [self createSubViews];
    [self datatSource];
}

- (void)datatSource {
    for (NSInteger i=0; i<10; i++) {
        YWUserModel *model = [[YWUserModel alloc] init];
        model.userAvator = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
        model.userId = [NSString stringWithFormat:@"%ld", i];
        model.userName = [NSString stringWithFormat:@"测试账号%ld", i];
        model.userRelationType = _isFocus?kBeFocus:kFocus;
        
        [_dataSource addObject:model];
    }
    [_tableView reloadData];
}

- (void)createSubViews {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _searchBar.placeholder = @"搜索片名/用户名";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[YWFollowingTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _searchBar;
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
    YWFollowingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    cell.user = _dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - YWFollowingTableViewCellDelegate
- (void)followingTableViewCellDidSelectButton:(YWFollowingTableViewCell *)cell {

}

@end
