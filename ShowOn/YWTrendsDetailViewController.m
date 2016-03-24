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
#import "MPMoviePlayerViewController+Rotation.h"
#import "YWFollowingViewController.h"
#import "YWRepeatDetailTableViewCell.h"
#import "YWHttpGlobalDefine.h"

@interface YWTrendsDetailViewController()<UITableViewDataSource, UITableViewDelegate, YWFocusTableViewCellDelegate, YWMovieCommentTableViewCellDelegate, YWMovieOtherInfosTableViewCellDelegate, UIActionSheetDelegate, YWRepeatDetailTableViewCellDelegate>

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
    [_tableView registerClass:[YWRepeatDetailTableViewCell class] forCellReuseIdentifier:@"cell1"];
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
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"举报" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [sheet addAction:[UIAlertAction actionWithTitle:@"带有色情或政治内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self requestReport:0];
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"其    他" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self requestReport:0];
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"取    消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            
        }]];
        [self presentViewController:sheet animated:YES completion:nil];
    }else {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"举报" delegate:self cancelButtonTitle:@"取    消" destructiveButtonTitle:nil otherButtonTitles:@"带有色情或政治内容", @"其    他", nil];
        sheet.tag = 110;
        [sheet showInView:self.view];
    }
}

- (void)actionWriteComment:(UIButton *)button {
    YWWriteCommentViewController *vc = [[YWWriteCommentViewController alloc] init];
    YWNavigationController *nv = [[YWNavigationController alloc] initWithRootViewController:vc];
    nv.title = @"写评论";
    vc.trends = _trends;
    vc.type = 1;
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
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"praiseTargetId": _trends.trendsId, @"praiseTypeId": @(1), @"state": @(!_trends.trendsIsSupport)};
    [_httpManager requestSupport:parameters success:^(id responseObject) {
        _trends.trendsIsSupport = _trends.trendsIsSupport.integerValue?@"0":@"1";
        _trends.trendsSuppotNumbers = [NSString stringWithFormat:@"%ld", (long)_trends.trendsIsSupport.integerValue?(long)_trends.trendsSuppotNumbers.integerValue+1:(long)_trends.trendsSuppotNumbers.integerValue-1];
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestCommentSupport:(YWCommentModel *)comment {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"praiseTargetId": comment.commentId, @"praiseTypeId": @(2), @"state": @(!comment.isSupport.integerValue)};
    [_httpManager requestSupport:parameters success:^(id responseObject) {
        comment.isSupport = [NSString stringWithFormat:@"%ld", (long)!comment.isSupport.integerValue];
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestReport:(NSInteger)index {
    NSArray *arr = @[@"带色情或政治内容", @"其他"];
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId?:@"", @"informTypeId": @"2", @"informTargetId": _trends.trendsId, @"informContent": arr[index]};
    [_httpManager requestReport:parameters success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestRepeat {
    YWWriteCommentViewController *vc = [[YWWriteCommentViewController alloc] init];
    YWNavigationController *nv = [[YWNavigationController alloc] initWithRootViewController:vc];
    nv.title = @"转发";
    vc.trends = _trends;
    vc.type = 3;
    [self presentViewController:nv animated:YES completion:nil];
}

- (void)requestShare {
    NSString *url = [NSString stringWithFormat:@"%@&trendsId=%@", HOST_URL(Share_Method) , _trends.trendsId];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMengAppKey shareText:@"来自【角儿】" shareImage:nil shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,UMShareToQQ] delegate:nil];
    NSString *title = _trends.trendsContent.length>0?_trends.trendsContent:@"";
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.url =  url;
    [UMSocialData defaultData].extConfig.qqData.title =  title;
    [UMSocialData defaultData].extConfig.qzoneData.title =  title;
    [UMSocialData defaultData].extConfig.wechatSessionData.url =  url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url =  url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title =  title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title =  title;
}

- (void)requestTrendsCollect {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"collectionTargetId": _trends.trendsId,@"collectionTypeId": @(1), @"state": @(!_trends.trendsIsCollect.integerValue)};
    [_httpManager requestCollect:parameters success:^(id responseObject) {
        _trends.trendsIsCollect = _trends.trendsIsCollect.integerValue?@"0":@"1";
        _trends.trendsCollectionNumbers = [NSString stringWithFormat:@"%ld", (long)_trends.trendsIsCollect.integerValue?(long)_trends.trendsCollectionNumbers.integerValue+1:(long)_trends.trendsCollectionNumbers.integerValue-1];
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
            if (_trends.trendsType.integerValue == 3) {
                YWRepeatDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
                cell.trends = _trends;
                
                return cell;
            }else {
                YWFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
                cell.trends = _trends;
                
                return cell;
            }
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
            if (_trends.trendsType.integerValue == 3) {
                return [YWRepeatDetailTableViewCell cellHeightWithTrends:_trends type:kRepeatTrendsListType];
            }else {
                return [YWFocusTableViewCell cellHeightWithTrends:_trends type:kTrendsDetailType];
            }
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
        if ([[YWDataBaseManager shareInstance] loginUser]) {
            YWWriteCommentViewController *vc = [[YWWriteCommentViewController alloc] init];
            YWNavigationController *nv = [[YWNavigationController alloc] initWithRootViewController:vc];
            nv.title = @"写评论";
            vc.type = 2;
            vc.trends = _trends;
            vc.comment = _trends.trendsComments[indexPath.row-2];
            [self presentViewController:nv animated:YES completion:nil];
        }else {
            [self login];
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        if (actionSheet.tag == 110) {
            if (buttonIndex != actionSheet.cancelButtonIndex) {
                [self requestReport:buttonIndex];
            }
        }else {
            if (buttonIndex == 0) {
                [self requestRepeat];
            }else if (buttonIndex == 1) {
                [self requestShare];
            }
        }
    }else {
        [self login];
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

- (void)repeatDetailTableViewCellDidSelectAvator:(YWRepeatDetailTableViewCell *)cell {
    YWUserDataViewController *vc = [[YWUserDataViewController alloc] init];
    vc.user = cell.trends.trendsUser;
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)focusTableViewCellDidSelectAvator:(YWFocusTableViewCell *)cell {
    YWUserDataViewController *vc = [[YWUserDataViewController alloc] init];
    vc.user = cell.trends.trendsUser;
    [self.navigationController pushViewController:vc animated:YES];
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
    YWFollowingViewController *vc = [[YWFollowingViewController alloc] init];
    vc.templateId = cell.trends.trendsMovie.movieTemplate.templateId;
    vc.title = @"表演者列表";
    [self.navigationController pushViewController:vc animated:YES];
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
