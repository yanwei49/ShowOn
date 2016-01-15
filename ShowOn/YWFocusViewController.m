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

#import "YWMovieModel.h"
#import "YWUserModel.h"
#import "YWCommentModel.h"

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
        YWMovieModel *movie = [[YWMovieModel alloc] init];
        movie.movieId = [NSString stringWithFormat:@"%ld", i];
        movie.moviePlayNumbers = @"221";
        movie.movieTimeLength = @"02:12";
        movie.movieName = [NSString stringWithFormat:@"测试模板%ld", i+1];
        movie.movieIsSupport = [NSString stringWithFormat:@"%d", arc4random()%2];
        movie.movieImageUrl = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
        movie.movieInfos = @"为己任内容我i让我去让我琼海请让我后悔千万人千万人薄荷问无人区普i人e王企鹅号叫恶趣味金额去维护去问恶趣味建行卡气温将客户而且我";
        YWUserModel *user = [[YWUserModel alloc] init];
        user.userId = [NSString stringWithFormat:@"%ld", i];
        user.portraitUri = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
        user.userName = [NSString stringWithFormat:@"测试用户%ld", i+1];
        movie.movieReleaseUser = user;
        YWCommentModel *comment = [[YWCommentModel alloc] init];
        comment.commentId = [NSString stringWithFormat:@"%ld", i];
        comment.commentTime = @"2015-10-20 03:21";
        comment.commentContent = @"为己任内容我i让我去让我琼海请让我后悔千万人千万人薄荷问无人区普i人";
        comment.commentUser = user;
        comment.isSupport = @"1";
        movie.movieComments = @[comment, comment];
        
        [_dataSource addObject:movie];
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
    cell.movie = _dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YWFocusTableViewCell cellHeightWithMovie:_dataSource[indexPath.row] type:kMovieListType];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YWHotDetailViewController *vc = [[YWHotDetailViewController alloc] init];
    vc.movie = _dataSource[indexPath.row];
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
