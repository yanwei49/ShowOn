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
#import "YWUserDataViewController.h"
#import "YWCustomTabBarViewController.h"
#import "YWHotView.h"
#import "YWHotItemViewController.h"
#import "YWDataBaseManager.h"
#import "YWHttpManager.h"
#import "YWParser.h"
#import "YWUserModel.h"
#import "YWMovieTemplateModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MPMoviePlayerViewController+Rotation.h"

@interface YWMineViewController ()<UITableViewDelegate, UITableViewDataSource, YWMineTableHeadViewDelegate, YWHotViewDelegate>

@end

@implementation YWMineViewController
{
    NSMutableArray      *_dataSource;
    UITableView         *_tableView;
    YWMineTableHeadView *_headView;
    YWHotView           *_hotView;
    BOOL                 _isPushHotItem;
    YWHttpManager       *_httpManager;
    NSMutableArray      *_templateArray;
    YWUserModel         *_loginUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = Subject_color;
    _httpManager = [YWHttpManager shareInstance];
    _templateArray = [[NSMutableArray alloc] init];
    _dataSource = [[NSMutableArray alloc] initWithArray:@[@"@我的", @"评论", @"赞", @"私信", @"好友动态", @"经验值", @"草稿箱"]];
    [self createRightItemWithTitle:@"设置"];
    [self createLeftItemWithTitle:@"首页"];
    _loginUser = [[YWDataBaseManager shareInstance] loginUser];
    
    [self createSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenHotView) name:@"HiddenHotView" object:nil];
}

- (void)hiddenHotView {
    self.navigationController.navigationBarHidden = NO;
    _hotView.hidden = YES;
    _tableView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isPushHotItem) {
        [self createHotView];
        _isPushHotItem = NO;
    }
    _headView.user = _loginUser;
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.hiddenState = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.hiddenState = NO;
    [self requestTemplateList];
    _loginUser = [[YWDataBaseManager shareInstance] loginUser];
    if (_loginUser) {
        [self requestUserDetails];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.hiddenState = YES;
}

- (void)actionLeftItem:(UIButton *)button {
    [self createHotView];
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.itemSelectIndex = -1;
}

- (void)createHotView {
    _tableView.hidden = YES;
    if (_hotView) {
        _hotView.hidden = NO;
        self.navigationController.navigationBarHidden = YES;
    }else {
        _hotView = [[YWHotView alloc] init];
        self.navigationController.navigationBarHidden = YES;
        _hotView.dataSource = _templateArray;
        _hotView.delegate = self;
        _hotView.dataSource = _templateArray;
        [self.view addSubview:_hotView];
        [_hotView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20);
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
    }
}

- (void)createSubViews {
    _headView = [[YWMineTableHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) withUserIsSelf:YES];
    _headView.delegate = self;
    _headView.user = _loginUser;
    
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
        make.left.bottom.right.offset(0);
        make.top.offset(64);
    }];
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    if (_loginUser) {
        YWSettingViewController *setVC = [[YWSettingViewController alloc] init];
        [self.navigationController pushViewController:setVC animated:YES];
    }else {
        [self login];
    }
}

#pragma mark - request
- (void)requestTemplateList {
    [_httpManager requestTemplateList:nil success:^(id responseObject) {
        [_templateArray removeAllObjects];
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser templateWithArray:responseObject[@"templateList"]];
        [_templateArray addObjectsFromArray:array];
        _hotView.dataSource = _templateArray;
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestUserDetails {
    NSDictionary *parameters = @{@"userId": _loginUser.userId?:@""};
    [_httpManager requestUserDetail:parameters success:^(id responseObject) {
        YWParser *parser = [[YWParser alloc] init];
        _loginUser = [parser userWithDict:responseObject[@"user"]];
        _loginUser.userId = [[YWDataBaseManager shareInstance] loginUser].userId;
        _headView.user = _loginUser;
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - YWHotViewDelegate
- (void)hotViewDidSelectItemWithTemplate:(YWMovieTemplateModel *)template {
    YWHotItemViewController *vc = [[YWHotItemViewController alloc] init];
    vc.template = template;
    [self.navigationController pushViewController:vc animated:YES];
    _isPushHotItem = YES;
}

- (void)hotViewDidSelectPlayItemWithTemplate:(YWMovieTemplateModel *)template {
    NSString *urlStr = [template.templateVideoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [moviePlayerViewController rotateVideoViewWithDegrees:0];
    [self presentViewController:moviePlayerViewController animated:YES completion:nil];
    [self requestPlayModelId:template.templateId withType:1];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    view.backgroundColor = RGBColor(52, 52, 52);
    YWUserModel *user = _loginUser;
    NSArray *array = @[user.userATMeNums?:@"", user.userCommentNums?:@"", user.userSupportNums?:@""];
    if (indexPath.row<3 && [array[indexPath.row] integerValue]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 20, 20)];
        label.backgroundColor = [UIColor redColor];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = array[indexPath.row];
        [view addSubview:label];
    }
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 10, 20)];
    img.backgroundColor = RGBColor(52, 52, 52);
    img.image = [UIImage imageNamed:@"next.png"];
    [view addSubview:img];
    cell.accessoryView = view;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_loginUser) {
        NSArray *className = @[@"YWATMeViewController", @"YWCommentViewController", @"YWSupportViewController", @"YWMessageViewController", @"YWTrendsViewController", @"YWExperienceViewController", @"YWDraftViewController"];
        UIViewController *vc = [[NSClassFromString(className[indexPath.row]) alloc] init];
        vc.title = _dataSource[indexPath.row];
        if (indexPath.row == 4) {
            YWTrendsViewController *v = (YWTrendsViewController *)vc;
            v.isFriendTrendsList = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self login];
    }
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
    if (_loginUser) {
        YWUserDataViewController *vc = [[YWUserDataViewController alloc] init];
        vc.isSelf = YES;
        vc.user = _loginUser;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self login];
    }
}

- (void)mineTableHeadView:(YWMineTableHeadView *)view didSelectButtonWithIndex:(NSInteger)index {
    if (_loginUser) {
        switch (index) {
            case 0:
            {
                YWTrendsViewController *vc = [[YWTrendsViewController alloc] init];
                vc.title = @"动态";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                YWFollowingViewController *vc = [[YWFollowingViewController alloc] init];
                vc.relationType = 1;
                vc.title = @"关注";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                YWFollowingViewController *vc = [[YWFollowingViewController alloc] init];
                vc.relationType = 2;
                vc.title = @"粉丝";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                YWCollectionViewController *vc = [[YWCollectionViewController alloc] init];
                vc.title = @"收藏";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }else {
        [self login];
    }
}


@end
