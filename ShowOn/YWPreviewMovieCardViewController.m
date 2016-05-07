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
#import "YWPreViewHeadView.h"
#import "YWMovieCardMovieTableViewCell.h"

@interface YWPreviewMovieCardViewController()<UITableViewDataSource, UITableViewDelegate, YWMovieCardMovieTableViewCellDelegate, UIActionSheetDelegate>

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
//    [self createRightItemWithTitle:@"完成"];
    _httpManager = [YWHttpManager shareInstance];
    
    [self createSubView];
}

#pragma mark - subview
- (void)createSubView {
    NSInteger cnt=1;
    if (_model.address.length || _model.constellation.length) {
        cnt += 2;
    }else {
        cnt += 1;
    }
    cnt += 2;
    if (_model.announce.length) {
        cnt += 1;
    }
    if (_model.info.length) {
        cnt += 1;
    }
    CGFloat height = 40*cnt+60;
    YWPreViewHeadView *headView = [[YWPreViewHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height) model:_model];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    view.backgroundColor = Subject_color;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth-40, 30)];
    button.backgroundColor = RGBColor(30, 30, 30);
    [button setTitleColor:RGBColor(255, 194, 0) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionDown) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"生成" forState:UIControlStateNormal];
    [view addSubview:button];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[YWMovieCardMovieTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.backgroundColor = RGBColor(50, 50, 50);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = headView;
    _tableView.tableFooterView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    _isShare = NO;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [sheet addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _isShare = YES;
            [self requestCommitMovieCard];
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requestCommitMovieCard];
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:sheet animated:YES completion:nil];
    }else {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享", @"上传", nil];
        [sheet showInView:self.view];
    }
}

- (void)actionDown {
    [self actionRightItem:nil];
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
    NSMutableArray *ids = [NSMutableArray array];
    for (YWTrendsModel *trends in _model.trends) {
        [ids addObject:trends.trendsId];
    }
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"authentication": _model.authentication, @"address": _model.address, @"bwh": _model.bwh, @"age": _model.age, @"constellation": _model.constellation, @"height": _model.height, @"announce": _model.announce, @"email": _model.email, @"info": _model.info, @"trendsId": (ids.count==1)?ids.firstObject:[ids componentsJoinedByString:@"|"]};
    if (!_isShare) {
        [SVProgressHUD showInfoWithStatus:@"上传中..."];
    }
    [_httpManager requestCommitMovieCard:parameters success:^(id responseObject) {
        if (_isShare) {
            [self requestShare];
        }else {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } otherFailure:^(id responseObject) {
        [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
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

#pragma mark - YWMovieCardMovieTableViewCellDelegate
- (void)movieCardMovieTableViewCellDidSelectPlay:(YWMovieCardMovieTableViewCell *)cell {
    NSString *urlStr = [cell.trends.trendsMovie.movieUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [moviePlayerViewController rotateVideoViewWithDegrees:90];
    [self presentViewController:moviePlayerViewController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.trends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWMovieCardMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.trends = _model.trends[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YWMovieCardMovieTableViewCell cellHeightWithModel:_model.trends[indexPath.row]];
}

#pragma mark - YWMovieCardTableViewCellDelegate
- (void)movieCardTableViewCellDidSelectPlayingButton:(YWTrendsModel *)trend {
    NSString *urlStr = [trend.trendsMovie.movieUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [moviePlayerViewController rotateVideoViewWithDegrees:90];
    [self presentViewController:moviePlayerViewController animated:YES completion:nil];
}

@end
