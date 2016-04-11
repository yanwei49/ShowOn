//
//  YWPreviewMovieCardViewController.m
//  ShowOn
//
//  Created by David Yu on 9/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWPreviewMovieCardViewController.h"
#import "YWMovieCardModel.h"
#import "YWTrendsModel.h"
#import "YWMovieModel.h"
#import "YWMovieCardTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MPMoviePlayerViewController+Rotation.h"
#import "YWHttpManager.h"
#import "UMSocialSnsService.h"
#import "UMSocialData.h"
#import "UMSocial.h"
#import "YWHttpGlobalDefine.h"
#import "YWDataBaseManager.h"
#import "YWUserModel.h"

@interface YWPreviewMovieCardViewController()<UITableViewDataSource, UITableViewDelegate, YWMovieCardTableViewCellDelegate, UIActionSheetDelegate>

@end

@implementation YWPreviewMovieCardViewController
{
    UITableView     *_tableView;
    BOOL             _isShare;
    YWHttpManager   *_httpManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览";
    [self createRightItemWithTitle:@"完成"];
    _httpManager = [YWHttpManager shareInstance];
    
    [self createSubView];
}

#pragma mark - subview
- (void)createSubView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[YWMovieCardTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [sheet addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _isShare = YES;
            [self requestCommitMovieCard];
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requestCommitMovieCard];
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:sheet animated:YES completion:nil];
    }else {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享", @"保存", nil];
        [sheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        _isShare = YES;
        [self requestCommitMovieCard];
    }else if (buttonIndex == 1) {
        [self requestCommitMovieCard];
    }
}

#pragma mark - request
- (void)requestCommitMovieCard {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"authentication": _model.authentication, @"address": _model.address, @"bwh": _model.bwh, @"age": _model.age, @"constellation": _model.constellation, @"height": _model.height, @"announce": _model.announce, @"email": _model.email, @"info": _model.info, @"trendsId": _model.trends.trendsId};
    [_httpManager requestCommitMovieCard:parameters success:^(id responseObject) {
        if (_isShare) {
            [self requestShare];
        }else {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } otherFailure:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
}

- (void)requestShare {
    NSString *url = [NSString stringWithFormat:@"%@&cardId=%@", HOST_URL(Share_Movie_Method) , _model.cardId];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMengAppKey shareText:@"来自【角儿】" shareImage:nil shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,UMShareToQQ] delegate:nil];
    NSString *title = _model.info.length>0?_model.info:@"";
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.url =  url;
    [UMSocialData defaultData].extConfig.qqData.title =  title;
    [UMSocialData defaultData].extConfig.qzoneData.title =  title;
    [UMSocialData defaultData].extConfig.wechatSessionData.url =  url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url =  url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title =  title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title =  title;
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWMovieCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.model = _model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YWMovieCardTableViewCell cellHeightWithModel:_model];
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
