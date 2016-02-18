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
#import "YWMovieModel.h"
#import "YWMovieTemplateModel.h"
#import "YWUserModel.h"
#import "YWCommentModel.h"
#import "YWSubsectionVideoModel.h"
#import "YWTrendsCategoryView.h"

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
    _currentPage = 0;
    
    [self createSubViews];
    [self dataSource];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self requestTrendsList];
}

- (void)dataSource {
    for (NSInteger i=0; i<10; i++) {
        YWTrendsModel *trends = [[YWTrendsModel alloc] init];
        trends.trendsId = [NSString stringWithFormat:@"%ld", i];
        trends.trendsType = [NSString stringWithFormat:@"%ld", (long)arc4random()%3+1];
        trends.trendsPubdate = @"2015-01-10";
        trends.trendsMoviePlayCount = @"100";
        trends.trendsContent = @"为己任内容我i让我去让我琼海请让我后悔千万人千万人薄荷问无人区普i人e王企鹅号叫恶趣味金额去维护去问恶趣味建行卡气温将客户而且我";
        trends.trendsIsSupport = @"1";
        
        YWUserModel *user = [[YWUserModel alloc] init];
        user.userId = [NSString stringWithFormat:@"%ld", i];
        user.portraitUri = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
        user.userName = [NSString stringWithFormat:@"测试用户%ld", i+1];
        trends.trendsUser = user;
        
        YWMovieModel *movie = [[YWMovieModel alloc] init];
        movie.movieCoverImage = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
        movie.movieUrl = @"";
        trends.trendsMovie = movie;
        
        YWMovieTemplateModel *template = [[YWMovieTemplateModel alloc] init];
        template.templateId = [NSString stringWithFormat:@"%ld", i];
        template.templateName = [NSString stringWithFormat:@"模板%ld", i];
        template.templateVideoUrl = @"";
        template.templateVideoTime = @"1分20秒";
        template.templateVideoCoverImage = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
        template.templateTypeId = [NSString stringWithFormat:@"%ld", (long)arc4random()%3+1];
        template.templatePlayUsers = @[user, user];
        
        YWSubsectionVideoModel *subsection = [[YWSubsectionVideoModel alloc] init];
        subsection.subsectionVideoId = [NSString stringWithFormat:@"%ld", i];
        subsection.subsectionVideoUrl = @"";
        subsection.subsectionVideoCoverImage = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
        subsection.subsectionVideoSort = subsection.subsectionVideoId;
        subsection.subsectionVideoType = subsection.subsectionVideoId;
        subsection.subsectionVideoPerformanceStatus = @"1";
        subsection.subsectionVideoPlayUserId = user.userId;
        subsection.subsectionVideoTemplateId = template.templateId;
        template.templateSubsectionVideos = @[subsection, subsection];
        
        YWCommentModel *comment = [[YWCommentModel alloc] init];
        comment.commentId = [NSString stringWithFormat:@"%ld", i];
        comment.commentTime = @"2015-10-20 03:21";
        comment.commentContent = @"为己任内容我i让我去让我琼海请让我后悔千万人千万人薄荷问无人区普i人";
        comment.commentUser = user;
        comment.isSupport = @"1";
        trends.trendsComments = @[comment, comment];
        trends.trendsType = [NSString stringWithFormat:@"%u", arc4random()%4];
        
        [_allTrendsArray addObject:trends];
    }
    [_dataSource addObjectsFromArray:_allTrendsArray];
    [_tableView reloadData];
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
        make.top.left.bottom.right.offset(0);
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
    NSDictionary *parameters = @{@"userId": _user.userId, @"loginUseruserId": [[YWDataBaseManager shareInstance] loginUser].userId?:@"", @"page": @(_currentPage)};
    [_httpManager requestTemplateList:parameters success:^(id responseObject) {
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
        
    }else {
        [self login];
    }
}

- (void)focusTableViewCellDidSelectPlay:(YWFocusTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        
    }else {
        [self login];
    }
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    YWSearchViewController *searchVC = [[YWSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
   
    return NO;
}


@end
