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
#import <MediaPlayer/MediaPlayer.h>
#import "MPMoviePlayerViewController+Rotation.h"
#import "YWRepeatDetailTableViewCell.h"
#import "YWMovieCardModel.h"
#import "YWMovieCardTableViewCell.h"
#import "YWEditMovieCallingCardViewController.h"

@interface YWTrendsViewController ()<UITableViewDelegate, UITableViewDataSource, YWFocusTableViewCellDelegate, UISearchBarDelegate, YWTrendsCategoryViewDelegate, YWRepeatDetailTableViewCellDelegate, YWMovieCardTableViewCellDelegate>

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
    UISegmentedControl      *_segmentedControl;
    NSMutableArray          *_movieCardDataSource;
    UIView                  *_footView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!_isFriendTrendsList) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"资料", @"动态"]];
        _segmentedControl.frame = CGRectMake(0, 0, 100, 35);
        _segmentedControl.selectedSegmentIndex = 1;
        [_segmentedControl addTarget:self action:@selector(actionSegValueChange) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.tintColor = RGBColor(255, 194, 0);
        self.navigationItem.titleView = _segmentedControl;
    }
    _dataSource = [[NSMutableArray alloc] init];
    _movieCardDataSource = [[NSMutableArray alloc] init];
    _allTrendsArray = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];
    _currentPage = 0;
    
    [self createSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_isFriendTrendsList) {
        [self requestFriendTrendsList];
    }else {
        [self requestTrendsList];
    }
}

- (void)createSubViews {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索片名/用户名";

    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    _footView.backgroundColor = Subject_color;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(40, 40, kScreenWidth-80, 40)];
    button.backgroundColor = RGBColor(241, 81, 81);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [button setTitle:@"制作视频名片" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(actionMovieCard) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:button];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[YWFocusTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[YWRepeatDetailTableViewCell class] forCellReuseIdentifier:@"cell1"];
    [_tableView registerClass:[YWMovieCardTableViewCell class] forCellReuseIdentifier:@"cell2"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _searchBar;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        if (_isFriendTrendsList) {
            [self requestFriendTrendsList];
        }else {
            [self requestTrendsList];
        }
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

- (void)actionMovieCard {
    YWEditMovieCallingCardViewController *vc = [[YWEditMovieCallingCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionSegValueChange {
    [_dataSource removeAllObjects];
    if (_segmentedControl.selectedSegmentIndex) {
        _tableView.tableFooterView = [[UIView alloc] init];
        [self trendsCategoryView:_categoryView didSelectCategoryWithIndex:_trendsType];
    }else {
        [_dataSource addObjectsFromArray:_movieCardDataSource];
        _tableView.tableFooterView = _footView;
        [_tableView reloadData];
    }
    [YWNoCotentView showNoCotentViewWithState:_dataSource.count?NO:YES];
}

#pragma mark - request
- (void)requestFriendTrendsList {
    NSDictionary *parameters = @{@"userId": _user.userId?:[[YWDataBaseManager shareInstance] loginUser].userId, @"loginUseruserId": [[YWDataBaseManager shareInstance] loginUser].userId?:@"", @"page": @(_currentPage)};
    [_httpManager requestFriendsTrendsList:parameters success:^(id responseObject) {
        if (!_currentPage) {
            [_allTrendsArray removeAllObjects];
            [_movieCardDataSource removeAllObjects];
        }
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser trendsWithArray:responseObject[@"trendsList"]];
        NSArray *movieCard = [parser movieCardWithArray:responseObject[@"movieCardList"]];
        [_movieCardDataSource addObjectsFromArray:movieCard];
        [_allTrendsArray addObjectsFromArray:array];
        [self noContentViewShowWithState:_allTrendsArray.count?NO:YES];
        if (array.count<20) {
            _tableView.footer = nil;
        }else {
            _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _currentPage ++;
                [self requestFriendTrendsList];
            }];
        }
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        [self actionSegValueChange];
    } otherFailure:^(id responseObject) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}

- (void)requestTrendsList {
    NSDictionary *parameters = @{@"userId": _user.userId?:[[YWDataBaseManager shareInstance] loginUser].userId, @"loginUseruserId": [[YWDataBaseManager shareInstance] loginUser].userId?:@"", @"page": @(_currentPage)};
    [_httpManager requestTrendsList:parameters success:^(id responseObject) {
        if (!_currentPage) {
            [_allTrendsArray removeAllObjects];
            [_movieCardDataSource removeAllObjects];
        }
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser trendsWithArray:responseObject[@"trendsList"]];
        NSArray *movieCard = [parser movieCardWithArray:responseObject[@"movieCardList"]];
        [_movieCardDataSource addObjectsFromArray:movieCard];
        [_allTrendsArray addObjectsFromArray:array];
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
        [self actionSegValueChange];
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
    if (_segmentedControl && !_segmentedControl.selectedSegmentIndex) {
        YWMovieCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = _dataSource[indexPath.row];
        
        return cell;
    }else {
        if ([_dataSource[indexPath.row] trendsType].integerValue == 3) {
            YWRepeatDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            cell.delegate = self;
            cell.trends = _dataSource[indexPath.row];
            
            return cell;
        }else {
            YWFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.delegate = self;
            cell.trends = _dataSource[indexPath.row];
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_segmentedControl && !_segmentedControl.selectedSegmentIndex) {
        return [YWMovieCardTableViewCell cellHeightWithModel:_dataSource[indexPath.row]];
    }else {
        if ([_dataSource[indexPath.row] trendsType].integerValue == 3) {
            return [YWRepeatDetailTableViewCell cellHeightWithTrends:_dataSource[indexPath.row] type:kRepeatTrendsListType];
        }else {
            return [YWFocusTableViewCell cellHeightWithTrends:_dataSource[indexPath.row] type:kTrendsListType];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (_segmentedControl && !_segmentedControl.selectedSegmentIndex)?0.0001:30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_segmentedControl && !_segmentedControl.selectedSegmentIndex) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    view.backgroundColor = RGBColor(50, 50, 50);
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = RGBColor(50, 50, 50);
    NSArray *array = @[@"全部", @"原创", @"合作", @"转发"];
    [button setTitle:[NSString stringWithFormat:@"%@ %ld", array[_trendsType], (unsigned long)_dataSource.count] forState:UIControlStateNormal];
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
    if (_segmentedControl && !_segmentedControl.selectedSegmentIndex) {
        
    }else {
        YWTrendsDetailViewController *vc = [[YWTrendsDetailViewController alloc] init];
        vc.trends = _dataSource[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - YWRepeatDetailTableViewCellDelegate
- (void)repeatDetailTableViewCellDidSelectCooperate:(YWRepeatDetailTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.template = cell.trends.trendsMovie.movieTemplate;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self login];
    }
}

- (void)repeatDetailTableViewCellDidSelectPlay:(YWRepeatDetailTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.template = cell.trends.trendsMovie.movieTemplate;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self login];
    }
}

- (void)repeatDetailTableViewCellDidSelectPlaying:(YWRepeatDetailTableViewCell *)cell {
    if (cell.trends.trendsMovie.movieUrl.length) {
        NSString *urlStr = [cell.trends.trendsMovie.movieUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlStr];
        MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
        [moviePlayerViewController rotateVideoViewWithDegrees:90];
        [self presentViewController:moviePlayerViewController animated:YES completion:nil];
        [self requestPlayModelId:cell.trends.trendsId withType:2];
    }else {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.trends = cell.trends;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - YWFocusTableViewCellDelegate
- (void)focusTableViewCellDidSelectCooperate:(YWFocusTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.template = cell.trends.trendsMovie.movieTemplate;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self login];
    }
}

- (void)focusTableViewCellDidSelectPlay:(YWFocusTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.template = cell.trends.trendsMovie.movieTemplate;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self login];
    }
}

- (void)focusTableViewCellDidSelectPlaying:(YWFocusTableViewCell *)cell {
    if (cell.trends.trendsMovie.movieUrl.length) {
        NSString *urlStr = [cell.trends.trendsMovie.movieUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlStr];
        MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
        [moviePlayerViewController rotateVideoViewWithDegrees:90];
        [self presentViewController:moviePlayerViewController animated:YES completion:nil];
        [self requestPlayModelId:cell.trends.trendsId withType:2];
    }else {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.trends = cell.trends;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    YWSearchViewController *searchVC = [[YWSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
   
    return NO;
}

#pragma mark - YWMovieCardTableViewCellDelegate
- (void)movieCardTableViewCellDidSelectPlayingButton:(YWMovieCardTableViewCell *)cell {
    NSString *urlStr = [cell.model.trends.trendsMovie.movieUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [moviePlayerViewController rotateVideoViewWithDegrees:90];
    [self presentViewController:moviePlayerViewController animated:YES completion:nil];
}

@end
