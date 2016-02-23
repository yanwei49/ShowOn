//
//  YWHomeViewController.m
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWHomeViewController.h"
#import "YWCustomTabBarViewController.h"
#import "YWHotView.h"
#import "YWHotItemViewController.h"
#import "YWArticleListTableViewCell.h"
#import "YWArticleDetailViewController.h"
#import "YWHttpManager.h"
#import "YWParser.h"
#import "YWDataBaseManager.h"
#import "YWUserModel.h"
#import "MJRefresh.h"
#import "YWMovieTemplateModel.h"
#import <MediaPlayer/MediaPlayer.h>

@interface YWHomeViewController ()<YWHotViewDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation YWHomeViewController
{
    YWHotView       *_hotView;
    BOOL             _isPushHotItem;
    UITableView     *_tableView;
    NSMutableArray  *_dataSource;
    YWHttpManager   *_httpManager;
    NSInteger        _currentPage;
    NSMutableArray  *_templateArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenHotView) name:@"HiddenHotView" object:nil];
    self.view.backgroundColor = Subject_color;
    self.title = @"图文";
    [self createLeftItemWithTitle:@"首页"];
    _dataSource = [[NSMutableArray alloc] init];
    _templateArray = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];
    _currentPage = 0;

    [self createSubViews];
    [self createHotView];
}

#pragma mark - NSNotification
- (void)hiddenHotView {
    self.navigationController.navigationBarHidden = NO;
    _hotView.hidden = YES;
    _tableView.hidden = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HiddenHotView" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isPushHotItem) {
        [self createHotView];
        _isPushHotItem = NO;
    }
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.hiddenState = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.hiddenState = NO;
    [self requestArticleList];
    [self requestTemplateList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.hiddenState = YES;
}

#pragma mark - create
- (void)createSubViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[YWArticleListTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self requestArticleList];
    }];
}

- (void)createHotView {
    _tableView.hidden = YES;
    if (_hotView) {
        _hotView.hidden = NO;
        self.navigationController.navigationBarHidden = YES;
    }else {
        _hotView = [[YWHotView alloc] init];
        _hotView.delegate = self;
        _hotView.dataSource = _templateArray;
        self.navigationController.navigationBarHidden = YES;
        [self.view addSubview:_hotView];
        [_hotView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20);
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
    }
}

#pragma mark - action
- (void)actionLeftItem:(UIButton *)button {
    [self createHotView];
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.itemSelectIndex = -1;
}

#pragma mark - request
- (void)requestArticleList {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId?:@""};
    [_httpManager requestArticleList:parameters success:^(id responseObject) {
        if (!_currentPage) {
            [_dataSource removeAllObjects];
        }
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser articleWithArray:responseObject[@"articleList"]];
        [_dataSource addObjectsFromArray:array];
        [self noContentViewShowWithState:_dataSource.count?NO:YES];
        if (array.count<20) {
            _tableView.footer = nil;
        }else {
            _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _currentPage ++;
                [self requestArticleList];
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWArticleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.article = _dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YWArticleDetailViewController *vc = [[YWArticleDetailViewController alloc] init];
    vc.article = _dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
    [self presentViewController:moviePlayerViewController animated:YES completion:nil];
}


@end
