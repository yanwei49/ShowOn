//
//  YWTrendsDetailViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWTrendsDetailViewController.h"
#import "YWMovieModel.h"
#import "YWFocusTableViewCell.h"
#import "YWMovieCommentTableViewCell.h"
#import "YWMovieOtherInfosTableViewCell.h"
#import "YWUserDataViewController.h"
#import "YWWriteCommentViewController.h"
#import "YWNavigationController.h"
#import "UMSocialSnsService.h"
#import "UMSocialData.h"
#import "UMSocial.h"
#import "YWTrendsModel.h"
#import "YWHttpManager.h"
#import "YWParser.h"
#import "YWUserModel.h"
#import "YWDataBaseManager.h"
#import "YWTranscribeViewController.h"
#import "YWCommentModel.h"
#import "YWMovieTemplateModel.h"
#import "YWTrendsModel.h"
#import "YWMovieModel.h"
#import "YWMovieTemplateModel.h"
#import <MediaPlayer/MediaPlayer.h>

@interface YWTrendsDetailViewController()<UITableViewDataSource, UITableViewDelegate, YWFocusTableViewCellDelegate, YWMovieCommentTableViewCellDelegate, YWMovieOtherInfosTableViewCellDelegate, UIActionSheetDelegate>

@end

@implementation YWTrendsDetailViewController
{
    UITableView         *_tableView;
    UIButton            *_commentView;
    YWHttpManager       *_httpManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.title = _trends.trendsMovie.movieTemplate.templateName;
    [self createRightItemWithImage:@"more_normal.png"];
    _httpManager = [YWHttpManager shareInstance];
    
    [self createSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestTrendsDetail];
}

- (void)createSubViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[YWFocusTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[YWMovieCommentTableViewCell class] forCellReuseIdentifier:@"commentCell"];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[YWMovieOtherInfosTableViewCell class] forCellReuseIdentifier:@"sCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(64);
        make.bottom.offset(-49);
    }];
    
    _commentView = [[UIButton alloc] init];
    _commentView.backgroundColor = Subject_color;
    [_commentView addTarget:self action:@selector(actionWriteComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commentView];
    [_commentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(49);
    }];
    
    UITextField *tf = [[UITextField alloc] init];
    tf.placeholder = @"  说点什么";
    tf.userInteractionEnabled = NO;
    tf.font = [UIFont systemFontOfSize:15];
    tf.backgroundColor = [UIColor whiteColor];
    tf.layer.masksToBounds = YES;
    tf.layer.cornerRadius = 7;
    [_commentView addSubview:tf];
    [tf makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(_commentView.mas_centerY);
        make.height.offset(35);
        make.right.offset(-60);
    }];
    
    UIButton *sendButton = [[UIButton alloc] init];
    sendButton.userInteractionEnabled = NO;
    sendButton.backgroundColor = Subject_color;
    [sendButton setTitle:@"发布" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_commentView addSubview:sendButton];
    [sendButton makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(50);
        make.right.offset(-5);
        make.centerY.equalTo(_commentView.mas_centerY);
        make.height.offset(35);
    }];
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"举报" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:@"带有色情或政治内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"其    他" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"取    消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
    }]];
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)actionWriteComment:(UIButton *)button {
    YWWriteCommentViewController *vc = [[YWWriteCommentViewController alloc] init];
    YWNavigationController *nv = [[YWNavigationController alloc] initWithRootViewController:vc];
    nv.title = @"写评论";
    vc.trends = _trends;
    [self presentViewController:nv animated:YES completion:nil];
}

#pragma mark - request
- (void)requestTrendsDetail {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"trendsId": _trends.trendsId};
    [_httpManager requestTrendsDetail:parameters success:^(id responseObject) {
        YWParser *parser = [[YWParser alloc] init];
        _trends = [parser trendsWithDict:responseObject[@"trends"]];
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestTrendsSupport {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"praiseTargetId": _trends.trendsId, @"praiseTypeId": @(1)};
    [_httpManager requestSupport:parameters success:^(id responseObject) {
        _trends.trendsIsSupport = _trends.trendsIsSupport.integerValue?@"0":@"1";
        _trends.trendsSuppotNumbers = [NSString stringWithFormat:@"%ld", _trends.trendsIsSupport.integerValue?_trends.trendsSuppotNumbers.integerValue+1:_trends.trendsSuppotNumbers.integerValue-1];
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

- (void)requestRepeat {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"trendsId": _trends.trendsId, @"forwardComments": @(2)};
    [_httpManager requestRepeat:parameters success:^(id responseObject) {

    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestShare {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"trendsId": _trends.trendsId};
    [_httpManager requestShare:parameters success:^(id responseObject) {
        [UMSocialSnsService presentSnsIconSheetView:self appKey:UMengAppKey shareText:@"来自【角儿】" shareImage:nil shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,UMShareToQQ] delegate:nil];
        NSString *url = responseObject[@"url"];
        NSString *title = _trends.trendsContent.length>0?_trends.trendsContent:@"";
        [UMSocialData defaultData].extConfig.qqData.url = url;
        [UMSocialData defaultData].extConfig.qzoneData.url =  url;
        [UMSocialData defaultData].extConfig.qqData.title =  title;
        [UMSocialData defaultData].extConfig.qzoneData.title =  title;
        [UMSocialData defaultData].extConfig.wechatSessionData.url =  url;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url =  url;
        [UMSocialData defaultData].extConfig.wechatSessionData.title =  title;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title =  title;
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestTrendsCollect {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"collectionTargetId": _trends.trendsId,@"collectionTypeId": @(1)};
    [_httpManager requestCollect:parameters success:^(id responseObject) {
        _trends.trendsIsCollect = _trends.trendsIsCollect.integerValue?@"0":@"1";
        _trends.trendsCollectionNumbers = [NSString stringWithFormat:@"%ld", _trends.trendsIsCollect.integerValue?_trends.trendsCollectionNumbers.integerValue+1:_trends.trendsCollectionNumbers.integerValue-1];
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2+_trends.trendsComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            YWFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.delegate = self;
            cell.trends = _trends;
            
            return cell;
        }
            break;
        case 1:
        {
            YWMovieOtherInfosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.trends = _trends;

            return cell;
        }
            break;
        default:
        {
            YWMovieCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
            cell.delegate = self;
            cell.comment = _trends.trendsComments[indexPath.row-2];

            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return [YWFocusTableViewCell cellHeightWithTrends:_trends type:kTrendsDetailType];
            break;
        case 1:
            return 100;
            break;
        default:
            return [YWMovieCommentTableViewCell cellHeightWithComment:_trends.trendsComments[indexPath.row-2]];
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row > 1) {
        YWWriteCommentViewController *vc = [[YWWriteCommentViewController alloc] init];
        YWNavigationController *nv = [[YWNavigationController alloc] initWithRootViewController:vc];
        nv.title = @"写评论";
        vc.trends = _trends;
        vc.comment = _trends.trendsComments[indexPath.row-2];
        [self presentViewController:nv animated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self requestRepeat];
    }else if (buttonIndex == 1) {
        [self requestShare];
    }
}

#pragma mark - YWFocusTableViewCellDelegate
- (void)focusTableViewCellDidSelectCooperate:(YWFocusTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.trends = _trends;
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
    if (cell.trends.trendsMovie.movieUrl.length) {
        NSString *urlStr = cell.trends.trendsMovie.movieUrl;
        NSURL *url = [NSURL URLWithString:urlStr];
        MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
        [self presentViewController:moviePlayerViewController animated:YES completion:nil];
    }else {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.trends = cell.trends;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - YWMovieOtherInfosTableViewCellDelegate
- (void)movieOtherInfosTableViewCellDidSelectShare:(YWMovieOtherInfosTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"转发/分享" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [sheet addAction:[UIAlertAction actionWithTitle:@"转发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self requestRepeat];
            }]];
            [sheet addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self requestShare];
            }]];
            [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:sheet animated:YES completion:nil];
        }else {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"转发/分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"转发", @"分享", nil];
            [sheet showInView:self.view];
        }
    }else {
        [self login];
    }
}

- (void)movieOtherInfosTableViewCellDidSelectSupport:(YWMovieOtherInfosTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        [self requestTrendsSupport];
    }else {
        [self login];
    }
}

- (void)movieOtherInfosTableViewCellDidSelectMore:(YWMovieOtherInfosTableViewCell *)cell {

}

- (void)movieOtherInfosTableViewCellDidSelectCollect:(YWMovieOtherInfosTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        [self requestTrendsCollect];
    }else {
        [self login];
    }
}

- (void)movieOtherInfosTableViewCell:(YWMovieOtherInfosTableViewCell *)cell didSelectUserAvator:(YWUserModel *)user {
    YWUserDataViewController *vc = [[YWUserDataViewController alloc] init];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - YWMovieCommentTableViewCellDelegate
- (void)movieCommentTableViewCellDidSelectSupport:(YWMovieCommentTableViewCell *)cell {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        [self requestCommentSupport:cell.comment];
    }else {
        [self login];
    }
}


@end
