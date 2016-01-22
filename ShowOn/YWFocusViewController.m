//
//  YWFocusViewController.m
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWFocusViewController.h"
#import "YWFocusTableViewCell.h"
#import "YWHotDetailViewController.h"

#import "YWTrendsModel.h"
#import "YWMovieModel.h"
#import "YWMovieTemplateModel.h"
#import "YWUserModel.h"
#import "YWCommentModel.h"
#import "YWSubsectionVideoModel.h"

@interface YWFocusViewController ()<UITableViewDelegate, UITableViewDataSource, YWFocusTableViewCellCellDelegate>

@end

@implementation YWFocusViewController
{
    NSMutableArray      *_dataSource;
    UITableView         *_tableView;
    UISearchBar         *_searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [[NSMutableArray alloc] init];
    
    [self createSubViews];
    [self dataSource];
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
        subsection.subsectionVideoPlayUser = user;
        subsection.subsectionVideoTemplate = template;
        template.templateSubsectionVideos = @[subsection, subsection];
        
        YWCommentModel *comment = [[YWCommentModel alloc] init];
        comment.commentId = [NSString stringWithFormat:@"%ld", i];
        comment.commentTime = @"2015-10-20 03:21";
        comment.commentContent = @"为己任内容我i让我去让我琼海请让我后悔千万人千万人薄荷问无人区普i人";
        comment.commentUser = user;
        comment.isSupport = @"1";
        trends.trendsComments = @[comment, comment];
        
        [_dataSource addObject:trends];
    }
    [_tableView reloadData];
}

- (void)createSubViews {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YWHotDetailViewController *vc = [[YWHotDetailViewController alloc] init];
    vc.trends = _dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - YWFocusTableViewCellCellDelegate
- (void)focusTableViewCellDidSelectCooperate:(YWFocusTableViewCell *)cell {
    if (false) {
        
    }else {
        [self login];
    }
}

- (void)focusTableViewCellDidSelectPlay:(YWFocusTableViewCell *)cell {
    if (false) {
        
    }else {
        [self login];
    }
}


@end
