//
//  YWMineViewController.m
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWMineViewController.h"
#import "YWMineTableHeadView.h"
#import "YWFollowingViewController.h"
#import "YWTrendsViewController.h"
#import "YWCollectionViewController.h"
#import "YWATMeViewController.h"
#import "YWCommentViewController.h"
#import "YWSupportViewController.h"
#import "YWMessageViewController.h"
#import "YWExperienceViewController.h"
#import "YWDraftViewController.h"
#import "YWSettingViewController.h"

@interface YWMineViewController ()<UITableViewDelegate, UITableViewDataSource, YWMineTableHeadViewDelegate>

@end

@implementation YWMineViewController
{
    NSMutableArray      *_dataSource;
    UITableView         *_tableView;
    YWMineTableHeadView *_headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [[NSMutableArray alloc] initWithArray:@[@"@我的", @"评论", @"赞", @"私信", @"经验值", @"草稿箱"]];
    [self createBackRightItemWithTitle:@"设置"];
    [self createSubViews];
}

- (void)createSubViews {
    _headView = [[YWMineTableHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    _headView.delegate = self;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorColor = RGBColor(30, 30, 30);
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _headView;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    YWSettingViewController *vc = [[YWSettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"设置";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = RGBColor(52, 52, 52);
    cell.contentView.backgroundColor = RGBColor(52, 52, 52);
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = _dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *className = @[@"YWATMeViewController", @"YWCommentViewController", @"YWSupportViewController", @"YWMessageViewController", @"YWExperienceViewController", @"YWDraftViewController"];
    UIViewController *vc = [[NSClassFromString(className[indexPath.row]) alloc] init];
    vc.title = _dataSource[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

////设置分割线顶左
//-(void)viewDidLayoutSubviews {
//    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
//    }
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
//    }
//}
//
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

#pragma mark - YWMineTableHeadViewDelegate
- (void)mineTableHeadViewDidSelectAvator {

}

- (void)mineTableHeadView:(YWMineTableHeadView *)view didSelectButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            YWTrendsViewController *vc = [[YWTrendsViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = @"动态";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            YWFollowingViewController *vc = [[YWFollowingViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.isFocus = YES;
            vc.title = @"关注";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            YWFollowingViewController *vc = [[YWFollowingViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.isFocus = NO;
            vc.title = @"粉丝";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            YWCollectionViewController *vc = [[YWCollectionViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = @"收藏";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


@end
