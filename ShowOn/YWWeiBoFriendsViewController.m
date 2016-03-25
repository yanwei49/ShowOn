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
#import "YWDataBaseManager.h"
#import "YWParser.h"
#import "YWSearchViewController.h"

@interface YWWeiBoFriendsViewController ()<UITableViewDataSource, UITableViewDelegate, YWFollowingTableViewCellDelegate, UISearchBarDelegate>

@end

@implementation YWWeiBoFriendsViewController
{
    YWHttpManager   *_httpManager;
    UITableView     *_tableView;
    NSMutableArray  *_dataSource;
    UISearchBar     *_searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微博好友";
    _httpManager = [YWHttpManager shareInstance];

    [self createSubViews];
    [self requestWeiBoFriend];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

#pragma mark - create
- (void)createSubViews {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索片名/用户名";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = RGBColor(50, 50, 50);
    [_tableView registerClass:[YWFollowingTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableHeaderView = _searchBar;
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
    NSDictionary *parameters = @{@"access_token": @"", @"uid": [[YWDataBaseManager shareInstance] loginUser].userAccount?:@"", @"cursor": @"0", @"count": @(190)};
    [[YWHttpManager shareInstance] requestWeiBoFriendList:parameters success:^(id responseObject) {
        NSArray *users = [responseObject objectForKey:@"users"];
        NSMutableString *accounts = [NSMutableString stringWithString:@""];
        for (NSDictionary *dict in users) {
//            YWUserModel *user = [[YWUserModel alloc] init];
//            user.userName = [dict objectForKey:@"name"];
//            user.portraitUri = [dict objectForKey:@"profile_image_url"];
//            [_dataSource addObject:users];
            [accounts appendString:[dict objectForKey:@"uid"]];
            [accounts appendString:@"|"];
        }
        [self requestWeiboUserWithAccounts:accounts];
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
}

- (void)requestWeiboUserWithAccounts:(NSString *)accounts {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"accounts": accounts};
    [[YWHttpManager shareInstance] requestWeiBoUser:parameters success:^(id responseObject) {
        [_dataSource removeAllObjects];
        YWParser *parser = [[YWParser alloc] init];
        [_dataSource addObjectsFromArray:[parser userWithArray:responseObject[@"userList"]]];
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
    } failure:^(NSError *error) {
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

#pragma mark - YWFollowingTableViewCellDelegate
- (void)followingTableViewCellDidSelectButton:(YWFollowingTableViewCell *)cell {
    [self requestAddFollowWithUser:cell.user];
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


#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    YWSearchViewController *searchVC = [[YWSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
    return NO;
}



@end
