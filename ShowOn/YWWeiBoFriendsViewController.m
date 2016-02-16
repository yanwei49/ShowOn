//
//  YWWeiBoFriendsViewController.m
//  ShowOn
//
//  Created by David Yu on 16/2/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWWeiBoFriendsViewController.h"
#import "YWHttpManager.h"
#import "YWFollowingTableViewCell.h"
#import "YWUserModel.h"

@interface YWWeiBoFriendsViewController ()<UITableViewDataSource, UITableViewDelegate, YWFollowingTableViewCellDelegate>

@end

@implementation YWWeiBoFriendsViewController
{
    YWHttpManager   *_httpManager;
    UITableView     *_tableView;
    NSMutableArray  *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微博好友";
    _httpManager = [YWHttpManager shareInstance];

    [self requestWeiBoFriend];
}

#pragma mark - create
- (void)createSubViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[YWFollowingTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}

//cursor	false	int	返回结果的游标，下一页用返回值里的next_cursor，上一页用previous_cursor，默认为0。
#pragma mark - request
- (void)requestWeiBoFriend {
    NSDictionary *parameters = @{@"access_token": @"", @"uid": @"", @"cursor": @"0", @"count": @(190)};
    [[YWHttpManager shareInstance] requestWeiBoFriendList:parameters success:^(id responseObject) {
        NSArray *users = [responseObject objectForKey:@"users"];
        for (NSDictionary *dict in users) {
            YWUserModel *user = [[YWUserModel alloc] init];
            user.userName = [dict objectForKey:@"name"];
            user.portraitUri = [dict objectForKey:@"profile_image_url"];
            
            [_dataSource addObject:users];
        }
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
}

#pragma mark - YWFollowingTableViewCellDelegate
- (void)followingTableViewCellDidSelectButton:(YWFollowingTableViewCell *)cell {
    
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



@end
