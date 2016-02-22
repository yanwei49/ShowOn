//
//  YWFocusViewController.m
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWTrendsViewController.h"
#import "YWFocusTableViewCell.h"
#import "YWTrendsDetailViewController.h"
#import "YWParser.h"
#import "YWHttpManager.h"
#import "YWSearchViewController.h"
#import "YWDataBaseManager.h"
#import "MJRefresh.h"
#import "YWTrendsModel.h"
#import "YWUserModel.h"
#import "YWTrendsCategoryView.h"
#import "YWTranscribeViewController.h"
#import "YWMovieModel.h"

@interface YWTrendsViewController ()<UITableViewDelegate, UITableViewDataSource, YWFocusTableViewCellDelegate, UISearchBarDelegate, YWTrendsCategoryViewDelegate>

@end

@implementation YWTrendsViewController
{
    NSMutableArray          *_dataSource;
    UITableView             *_tableView;
    UISearchBar             *_searchBar;
    YWHttpManager           *_httpManager;
    NSInteger                _trendsType;
    YWTrendsCategoryView    *_categoryView;
    NSMutableArray          *_allTrendsArray;
    NSInteger                _currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [[NSMutableArray alloc] init];
    _allTrendsArray = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];
    _currentPage = 0;
    
    [self createSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestTrendsList];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)createSubViews {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索片名/用户名";

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[YWFocusTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _searchBar;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.top.offset(64);
    }];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self requestTrendsList];
    }];
}

#pragma mark - action
- (void)actionTrendsCategoryOnClick:(UIButton *)button {
    NSArray *array = @[@"全部", @"原创", @"合作", @"转发"];
    if (_categoryView) {
        _categoryView.hidden = !_categoryView.hidden;
    }else {
        _categoryView = [[YWTrendsCategoryView alloc] init];
        _categoryView.delegate = self;
        _categoryView.categoryArray = array;
        [self.view addSubview:_categoryView];
    }
    [_categoryView makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(array.count*30);
        make.top.equalTo(button.mas_bottom);
        make.right.equalTo(-20);
    }];
}

#pragma mark - request
- (void)requestTrendsList {
    NSDictionary *parameters = @{@"userId": _user.userId?:[[YWDataBaseManager shareInstance] loginUser].userId, @"loginUseruserId": [[YWDataBaseManager shareInstance] loginUser].userId?:@"", @"page": @(_currentPage)};
    [_httpManager requestTrendsList:parameters success:^(id responseObject) {
        if (!_currentPage) {
            [_allTrendsArray removeAllObjects];
        }
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser trendsWithArray:responseObject[@"trendsList"]];
        [_allTrendsArray addObjectsFromArray:array];
        [self trendsCategoryView:_categoryView didSelectCategoryWithIndex:_trendsType];
        [self noContentViewShowWithState:_allTrendsArray.count?NO:YES];
        if (array.count<20) {
            _tableView.footer = nil;
        }else {
            _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _currentPage ++;
                [self requestTrendsList];
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

#pragma mark - YWTrendsCategoryViewDelegate
- (void)trendsCategoryView:(YWTrendsCategoryView *)view didSelectCategoryWithIndex:(NSInteger)index {
    _categoryView.hidden = YES;
    _trendsType = index;
    [_dataSource removeAllObjects];
    for (YWTrendsModel *trends in _allTrendsArray) {
        if (trends.trendsType.integerValue == index || !index) {
            [_dataSource addObject:trends];
        }
    }
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    cell.trends = _dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YWFocusTableViewCell cellHeightWithTrends:_dataSource[indexPath.row] type:kTrendsListType];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    view.backgroundColor = RGBColor(50, 50, 50);
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = RGBColor(50, 50, 50);
    NSArray *array = @[@"全部", @"原创", @"合作", @"转发"];
    [button setTitle:[NSString stringWithFormat:@"%@ %ld", array[_trendsType], _dataSource.count] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button addTarget:self action:@selector(actionTrendsCategoryOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.width.offset(100);
        make.right.offset(-20);
    }];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YWTrendsDetailViewController *vc = [[YWTrendsDetailViewController alloc] init];
    vc.trends = _dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - YWFocusTableViewCellDelegate
- (void)focusTableViewCellDidSelectCooperate:(YWFocusTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self login];
    }
}

- (void)focusTableViewCellDidSelectPlay:(YWFocusTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.template = _trends.trendsMovie.movieTemplate;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self login];
    }
}

- (void)focusTableViewCellDidSelectPlaying:(YWFocusTableViewCell *)cell {

}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    YWSearchViewController *searchVC = [[YWSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
   
    return NO;
}


@end
