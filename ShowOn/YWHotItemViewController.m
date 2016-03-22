//
//  YWHotItemViewController.m
//  ShowOn
//
//  Created by 颜魏 on 16/1/12.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWHotItemViewController.h"
#import "YWMovieCommentTableViewCell.h"
#import "YWHotTableViewCell.h"
#import "YWHttpManager.h"
#import "YWMovieTemplateModel.h"
#import "YWParser.h"
#import "YWDataBaseManager.h"
#import "YWUserModel.h"
#import "YWTemplateTrendsTableViewCell.h"
#import "YWTranscribeViewController.h"
#import "YWTrendsDetailViewController.h"
#import "YWTrendsModel.h"
#import "YWCommentModel.h"
#import "YWMovieModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "YWTranscribeViewController.h"
#import "YWWriteCommentViewController.h"
#import "YWNavigationController.h"
#import "MPMoviePlayerViewController+Rotation.h"
#import "YWRepeatTableViewCell.h"

@interface YWHotItemViewController ()<UITableViewDataSource, UITableViewDelegate, YWMovieCommentTableViewCellDelegate, YWTemplateTrendsTableViewCellDelegate, YWHotTableViewCellDelegate, UIActionSheetDelegate, YWRepeatTableViewCellDelegate>

@end

@implementation YWHotItemViewController
{
    UISegmentedControl      *_segmentedControl;
    UITableView             *_tableView;
    NSMutableArray          *_dataSource;
    NSMutableArray          *_trends;
    NSMutableArray          *_comments;
    YWHttpManager           *_httpManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.navigationController.navigationBarHidden = NO;
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"排行", @"评论"]];
    _segmentedControl.frame = CGRectMake(0, 0, 100, 35);
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self action:@selector(actionSegValueChange) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor redColor];
    self.navigationItem.titleView = _segmentedControl;
    _dataSource = [[NSMutableArray alloc] init];
    _trends = [[NSMutableArray alloc] init];
    _comments = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];
    
    [self createSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestTemplateDetail];
}

#pragma mark - private
- (void)createSubViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[YWMovieCommentTableViewCell class] forCellReuseIdentifier:@"commentCell"];
    [_tableView registerClass:[YWHotTableViewCell class] forCellReuseIdentifier:@"templateCell"];
    [_tableView registerClass:[YWRepeatTableViewCell class] forCellReuseIdentifier:@"repeatTrendsCell"];
    [_tableView registerClass:[YWTemplateTrendsTableViewCell class] forCellReuseIdentifier:@"trendsCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.top.offset(64);
    }];
}

#pragma mark - action
- (void)actionSegValueChange {
    [_dataSource removeAllObjects];
    if (!_segmentedControl.selectedSegmentIndex) {
        [_dataSource addObjectsFromArray:_trends];
    }else {
        [_dataSource addObjectsFromArray:_comments];
    }
    [_tableView reloadData];
}

#pragma mark - request
- (void)requestTemplateDetail {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"templateId": _template.templateId};
    [_httpManager requestTemplateDetail:parameters success:^(id responseObject) {
        YWParser *parser = [[YWParser alloc] init];
        [_trends removeAllObjects];
        [_comments removeAllObjects];
        [_dataSource removeAllObjects];
        NSArray *subVideos = _template.templateSubsectionVideos;
        _template = [parser templateWithDict:responseObject[@"templateInfo"]];
        if (!_template.templateSubsectionVideos.count) {
            _template.templateSubsectionVideos = subVideos;
        }
        [_trends addObjectsFromArray:_template.templateTrends];
        [_comments addObjectsFromArray:_template.templateComments];
        [_dataSource addObjectsFromArray:_trends];
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestCommentSupport:(YWCommentModel *)comment {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"praiseTargetId": comment.commentId, @"praiseTypeId": @(2)};
    [_httpManager requestSupport:parameters success:^(id responseObject) {
        comment.isSupport = @"1";
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma nmark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_segmentedControl.selectedSegmentIndex) {
        return 2;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_segmentedControl.selectedSegmentIndex) {
        return !section?1:_dataSource.count;
    }else {
        return _dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_segmentedControl.selectedSegmentIndex) {
        if (!indexPath.section) {
            YWHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"templateCell"];
            cell.template = _template;
            cell.delegate = self;
            
            return cell;
        }else {
            if ([_dataSource[indexPath.row] trendsType].integerValue == 3) {
                YWRepeatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repeatTrendsCell"];
                cell.delegate = self;
                cell.trends = _dataSource[indexPath.row];
                
                return cell;
            }else {
                YWTemplateTrendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trendsCell"];
                cell.delegate = self;
                cell.trends = _dataSource[indexPath.row];
                
                return cell;
            }
        }
    }else {
        YWMovieCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        cell.delegate = self;
        cell.comment = _dataSource[indexPath.row];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_segmentedControl.selectedSegmentIndex) {
        if (!indexPath.section) {
            return 200;
        }else {
            if ([_dataSource[indexPath.row] trendsType].integerValue == 3) {
                return [YWRepeatTableViewCell cellHeightWithTrends:_dataSource[indexPath.row]];
            }else {
                return [YWTemplateTrendsTableViewCell cellHeightWithTrends:_dataSource[indexPath.row]];
            }
        }
    }else {
        return 80;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!_segmentedControl.selectedSegmentIndex && section) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        view.backgroundColor = RGBColor(30, 30, 30);
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = RGBColor(30, 30, 30);
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"排行榜";
        [view addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.offset(10);
        }];
        
        return view;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!_segmentedControl.selectedSegmentIndex && section) {
        return 30;
    }else {
        return 0.00001;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_segmentedControl.selectedSegmentIndex) {
        YWWriteCommentViewController *vc = [[YWWriteCommentViewController alloc] init];
        YWNavigationController *nv = [[YWNavigationController alloc] initWithRootViewController:vc];
        nv.title = @"写评论";
        vc.comment = _dataSource[indexPath.row];
        [self presentViewController:nv animated:YES completion:nil];
    }else {
        if (!indexPath.section) {
            if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
                UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [sheet addAction:[UIAlertAction actionWithTitle:@"去录制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
                    vc.template = _template;
                    [self.navigationController pushViewController:vc animated:YES];
                }]];
                [sheet addAction:[UIAlertAction actionWithTitle:@"评论模板" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    YWWriteCommentViewController *vc = [[YWWriteCommentViewController alloc] init];
                    YWNavigationController *nv = [[YWNavigationController alloc] initWithRootViewController:vc];
                    nv.title = @"写评论";
                    vc.template = _template;
                    [self presentViewController:nv animated:YES completion:nil];
                }]];
                [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:sheet animated:YES completion:nil];
            }else {
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去录制", @"评论模板", nil];
                [sheet showInView:self.view];
            }
        }else {
            YWTrendsDetailViewController *vc = [[YWTrendsDetailViewController alloc] init];
            vc.trends = _dataSource[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.template = _template;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (buttonIndex == 1) {
        YWWriteCommentViewController *vc = [[YWWriteCommentViewController alloc] init];
        YWNavigationController *nv = [[YWNavigationController alloc] initWithRootViewController:vc];
        nv.title = @"写评论";
        vc.template = _template;
        [self presentViewController:nv animated:YES completion:nil];
    }
}

#pragma mark - YWHotTableViewCellDelegate
- (void)hotTableViewCellDidSelectPlay:(YWHotTableViewCell *)cell {
    NSString *urlStr = [cell.template.templateVideoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [moviePlayerViewController rotateVideoViewWithDegrees:0];
    [self presentViewController:moviePlayerViewController animated:YES completion:nil];
    [self requestPlayModelId:cell.template.templateId withType:1];
}

#pragma mark - YWMovieCommentTableViewCellDelegate
- (void)movieCommentTableViewCellDidSelectSupport:(YWMovieCommentTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        [self requestCommentSupport:cell.comment];
    }else {
        [self login];
    }
}

#pragma mark - YWRepeatTableViewCell
- (void)repeatTableViewCellDidSelectCooperate:(YWRepeatTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.trends = cell.trends;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self login];
    }
}

- (void)repeatTableViewCellDidSelectPlay:(YWRepeatTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.trends = cell.trends;
        vc.template = _template;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self login];
    }
}

- (void)repeatTableViewCellDidSelectPlaying:(YWRepeatTableViewCell *)cell {
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

#pragma mark - YWTemplateTrendsTableViewCellDelegate
- (void)templateTrendsTableViewCellDidSelectCooperate:(YWTemplateTrendsTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.trends = cell.trends;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self login];
    }
}

- (void)templateTrendsTableViewCellDidSelectPlay:(YWTemplateTrendsTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.trends = cell.trends;
        vc.template = _template;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self login];
    }
}

- (void)templateTrendsTableViewCellDidSelectPlaying:(YWTemplateTrendsTableViewCell *)cell {
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


@end
